package com.kvs.samsung_health_reporter

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
import kotlinx.coroutines.flow.Flow
import kotlin.time.Duration

/**
 * The SamsungHealthReporter calls the dispatcher makes, one per Dart method.
 *
 * The library's services need the Samsung Health Data SDK on the classpath, which a unit test doesn't have,
 * so the dispatcher talks to this interface and [ReporterSamsungHealth] forwards it to the library.
 */
interface SamsungHealth {
    fun isAvailable(): Boolean

    suspend fun requestPermissions(
        read: Set<HealthType>,
        write: Set<HealthType>,
    ): Set<Permission>

    suspend fun grantedPermissions(
        read: Set<HealthType>,
        write: Set<HealthType>,
    ): Set<Permission>

    suspend fun isAuthorized(
        read: Set<HealthType>,
        write: Set<HealthType>,
    ): Boolean

    fun resolve(): Boolean

    suspend fun localDevice(): Device

    suspend fun devices(): List<Device>

    suspend fun device(id: String): Device?

    suspend fun read(
        type: HealthType,
        range: TimeRange,
        ordering: Ordering,
        limit: Int?,
        source: SourceFilter?,
    ): List<Sample>

    suspend fun readPage(
        type: HealthType,
        range: TimeRange,
        pageSize: Int,
        pageToken: String?,
        ordering: Ordering,
        source: SourceFilter?,
    ): Page<Sample>

    suspend fun userProfile(): UserProfile?

    suspend fun aggregate(
        aggregation: Aggregation,
        range: TimeRange,
        group: TimeGroup?,
        ordering: Ordering,
    ): List<Aggregate>

    suspend fun insert(samples: List<WritableSample>): List<WritableSample>

    suspend fun update(samples: List<WritableSample>)

    suspend fun delete(sample: Sample)

    suspend fun deleteByUids(
        type: HealthType,
        uids: List<String>,
    )

    suspend fun deleteByClientDataIds(
        type: HealthType,
        clientDataIds: List<String>,
    )

    suspend fun changes(
        type: HealthType,
        since: Long,
        until: Long?,
    ): ChangeSet

    fun observe(
        type: HealthType,
        since: Long,
        interval: Duration,
    ): Flow<ChangeSet>
}
