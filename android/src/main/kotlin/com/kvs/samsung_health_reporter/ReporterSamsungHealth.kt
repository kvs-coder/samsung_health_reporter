package com.kvs.samsung_health_reporter

import android.app.Activity
import android.content.Context
import com.kvs.samsunghealthreporter.SamsungHealthException
import com.kvs.samsunghealthreporter.SamsungHealthReporter
import com.kvs.samsunghealthreporter.model.Aggregate
import com.kvs.samsunghealthreporter.model.ChangeSet
import com.kvs.samsunghealthreporter.model.Device
import com.kvs.samsunghealthreporter.model.Ordering
import com.kvs.samsunghealthreporter.model.Page
import com.kvs.samsunghealthreporter.model.Permission
import com.kvs.samsunghealthreporter.model.SourceFilter
import com.kvs.samsunghealthreporter.model.TimeGroup
import com.kvs.samsunghealthreporter.model.TimeRange
import com.kvs.samsunghealthreporter.model.payload.Sample
import com.kvs.samsunghealthreporter.model.payload.UserProfile
import com.kvs.samsunghealthreporter.model.payload.WritableSample
import com.kvs.samsunghealthreporter.model.type.Aggregation
import com.kvs.samsunghealthreporter.model.type.HealthType
import com.kvs.samsunghealthreporter.service.aggregate
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlin.time.Duration

/**
 * [SamsungHealth] over one **SamsungHealthReporter**, connected on the first call that needs it.
 *
 * Connecting fails with **SamsungHealthException.Resolvable** until Samsung Health is installed and set up, so the
 * reporter is created lazily, and the last resolvable error of any call is kept for [resolve].
 */
class ReporterSamsungHealth(
    private val context: Context,
    private val activity: () -> Activity?,
) : SamsungHealth {
    private var connected: SamsungHealthReporter? = null
    private var resolvable: SamsungHealthException.Resolvable? = null

    private val reporter: SamsungHealthReporter
        get() = connected ?: SamsungHealthReporter(context).also { connected = it }

    private val foregroundActivity: Activity
        get() = activity() ?: throw SamsungHealthException.Platform("No activity: the app is not in the foreground")

    /** Keeps a resolvable error of [call] for [resolve] */
    private inline fun <T> keepingResolvable(call: () -> T): T =
        try {
            call()
        } catch (exception: SamsungHealthException.Resolvable) {
            resolvable = exception
            throw exception
        }

    override fun isAvailable(): Boolean = SamsungHealthReporter.isAvailable(context)

    override suspend fun requestPermissions(
        read: Set<HealthType>,
        write: Set<HealthType>,
    ): Set<Permission> = keepingResolvable { reporter.manager.requestPermissions(foregroundActivity, read, write) }

    override suspend fun grantedPermissions(
        read: Set<HealthType>,
        write: Set<HealthType>,
    ): Set<Permission> = keepingResolvable { reporter.manager.grantedPermissions(read, write) }

    override suspend fun isAuthorized(
        read: Set<HealthType>,
        write: Set<HealthType>,
    ): Boolean = keepingResolvable { reporter.manager.isAuthorized(read, write) }

    override fun resolve(): Boolean {
        val exception = resolvable ?: return false
        val resolved = keepingResolvable { reporter.manager.resolve(foregroundActivity, exception) }
        resolvable = null
        return resolved
    }

    override suspend fun localDevice(): Device = keepingResolvable { reporter.manager.localDevice() }

    override suspend fun devices(): List<Device> = keepingResolvable { reporter.manager.devices() }

    override suspend fun device(id: String): Device? = keepingResolvable { reporter.manager.device(id) }

    override suspend fun read(
        type: HealthType,
        range: TimeRange,
        ordering: Ordering,
        limit: Int?,
        source: SourceFilter?,
    ): List<Sample> = keepingResolvable { reporter.reader.read(type, range, ordering, limit, source) }

    override suspend fun readPage(
        type: HealthType,
        range: TimeRange,
        pageSize: Int,
        pageToken: String?,
        ordering: Ordering,
        source: SourceFilter?,
    ): Page<Sample> = keepingResolvable { reporter.reader.readPage(type, range, pageSize, pageToken, ordering, source) }

    override suspend fun userProfile(): UserProfile? = keepingResolvable { reporter.reader.userProfile() }

    override suspend fun aggregate(
        aggregation: Aggregation,
        range: TimeRange,
        group: TimeGroup?,
        ordering: Ordering,
    ): List<Aggregate> = keepingResolvable { reporter.reader.aggregate(aggregation, range, group, ordering) }

    override suspend fun insert(samples: List<WritableSample>): List<WritableSample> =
        keepingResolvable { reporter.writer.insert(samples) }

    override suspend fun update(samples: List<WritableSample>) = keepingResolvable { reporter.writer.update(samples) }

    override suspend fun delete(sample: Sample) = keepingResolvable { reporter.writer.delete(sample) }

    override suspend fun deleteByUids(
        type: HealthType,
        uids: List<String>,
    ) = keepingResolvable { reporter.writer.delete(type, uids) }

    override suspend fun deleteByClientDataIds(
        type: HealthType,
        clientDataIds: List<String>,
    ) = keepingResolvable { reporter.writer.deleteByClientDataIds(type, clientDataIds) }

    override suspend fun changes(
        type: HealthType,
        since: Long,
        until: Long?,
    ): ChangeSet =
        keepingResolvable {
            if (until == null) reporter.observer.changes(type, since) else reporter.observer.changes(type, since, until)
        }

    // Connecting happens when the flow is collected, so its errors reach the collector
    override fun observe(
        type: HealthType,
        since: Long,
        interval: Duration,
    ): Flow<ChangeSet> =
        flow {
            keepingResolvable { reporter.observer.observe(type, since, interval).collect { emit(it) } }
        }
}
