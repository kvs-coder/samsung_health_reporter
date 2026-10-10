package com.kvs.samsung_health_reporter

import com.kvs.samsunghealthreporter.SamsungHealthException
import com.kvs.samsunghealthreporter.model.Ordering
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import java.util.UUID
import kotlin.time.Duration.Companion.milliseconds
import kotlin.time.Duration.Companion.minutes

/** The method channel of every [Method] */
const val METHOD_CHANNEL = "samsung_health_reporter_method_channel"

/** Prefix of the event channel of every observe subscription */
const val OBSERVE_EVENT_CHANNEL = "samsung_health_reporter_event_channel_observe_"

/** Dart methods of `SamsungHealthReporter`, named like them */
@Suppress("EnumEntryName", "ktlint:standard:enum-entry-name-case")
enum class Method {
    isAvailable,
    requestPermissions,
    grantedPermissions,
    isAuthorized,
    resolve,
    localDevice,
    devices,
    device,
    read,
    readPage,
    userProfile,
    aggregate,
    insert,
    update,
    delete,
    deleteByUids,
    deleteByClientDataIds,
    changes,
    observe,
}

/**
 * Runs the method calls of `SamsungHealthReporter` in [scope] and replies on its thread, the platform thread.
 *
 * Results are the library's JSON (lists as JSON arrays) or bools; every failure replies a `PlatformException` whose
 * code is the method name, message the error's message and details its kind (see [details]).
 *
 * @param open registers an event channel of an observe subscription
 * @param close unregisters it once Dart cancels the subscription
 */
class SamsungHealthDispatcher(
    private val health: SamsungHealth,
    private val scope: CoroutineScope,
    private val open: (name: String, handler: EventChannel.StreamHandler) -> Unit,
    private val close: (name: String) -> Unit,
) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        val method = Method.entries.firstOrNull { it.name == call.method } ?: return result.notImplemented()
        scope.launch {
            try {
                result.success(reply(method, call.argumentMap))
            } catch (exception: CancellationException) {
                throw exception
            } catch (exception: Exception) {
                result.error(method.name, exception.description, exception.details)
            }
        }
    }

    private val MethodCall.argumentMap: Map<String, Any?>
        get() =
            when (val arguments = arguments) {
                null -> emptyMap()
                is Map<*, *> -> arguments.entries.associate { (key, value) -> key.toString() to value }
                else -> throw SamsungHealthException.InvalidValue("Invalid arguments: $arguments")
            }

    @Suppress("CyclomaticComplexMethod")
    private suspend fun reply(
        method: Method,
        arguments: Map<String, Any?>,
    ): Any? =
        when (method) {
            Method.isAvailable -> {
                health.isAvailable()
            }

            Method.requestPermissions -> {
                health.requestPermissions(arguments.healthTypes("read"), arguments.healthTypes("write")).json
            }

            Method.grantedPermissions -> {
                health.grantedPermissions(arguments.healthTypes("read"), arguments.healthTypes("write")).json
            }

            Method.isAuthorized -> {
                health.isAuthorized(arguments.healthTypes("read"), arguments.healthTypes("write"))
            }

            Method.resolve -> {
                health.resolve()
            }

            Method.localDevice -> {
                health.localDevice().json
            }

            Method.devices -> {
                health.devices().json
            }

            Method.device -> {
                health.device(arguments.string("id"))?.json
            }

            Method.read -> {
                health
                    .read(
                        arguments.healthType(),
                        arguments.timeRange(),
                        arguments.ordering(Ordering.DESCENDING),
                        arguments.optionalInt("limit"),
                        arguments.sourceFilter(),
                    ).json
            }

            Method.readPage -> {
                health
                    .readPage(
                        arguments.healthType(),
                        arguments.timeRange(),
                        arguments.optionalInt("pageSize") ?: DEFAULT_PAGE_SIZE,
                        arguments.optionalString("pageToken"),
                        arguments.ordering(Ordering.DESCENDING),
                        arguments.sourceFilter(),
                    ).json
            }

            Method.userProfile -> {
                health.userProfile()?.json
            }

            Method.aggregate -> {
                health
                    .aggregate(
                        arguments.aggregation(),
                        arguments.timeRange(),
                        arguments.timeGroup(),
                        arguments.ordering(Ordering.ASCENDING),
                    ).json
            }

            Method.insert -> {
                health.insert(arguments.maps("samples").map { it.writableSample }).json
            }

            Method.update -> {
                health.update(arguments.maps("samples").map { it.writableSample }).let { true }
            }

            Method.delete -> {
                health.delete(arguments.map("sample").sample).let { true }
            }

            Method.deleteByUids -> {
                health.deleteByUids(arguments.healthType(), arguments.strings("uids")).let { true }
            }

            Method.deleteByClientDataIds -> {
                health
                    .deleteByClientDataIds(arguments.healthType(), arguments.strings("clientDataIds"))
                    .let { true }
            }

            Method.changes -> {
                health.changes(arguments.healthType(), arguments.long("since"), arguments.optionalLong("until")).json
            }

            Method.observe -> {
                openObserveChannel(arguments)
            }
        }

    /**
     * Checks the arguments of an observe subscription and opens its event channel; Dart listens to it to start
     * polling and cancels it to stop polling and close the channel.
     *
     * @return **String** the event channel's name
     */
    private fun openObserveChannel(arguments: Map<String, Any?>): String {
        val type = arguments.healthType()
        if (!type.isObservable) throw SamsungHealthException.InvalidType("${type.identifier} is not observable")
        val since = arguments.long("since")
        val interval = arguments.optionalLong("interval")?.milliseconds ?: 1.minutes
        val name = OBSERVE_EVENT_CHANNEL + UUID.randomUUID()
        open(name, ObserveStreamHandler(health.observe(type, since, interval), scope) { close(name) })
        return name
    }

    private companion object {
        const val DEFAULT_PAGE_SIZE = 100
    }
}
