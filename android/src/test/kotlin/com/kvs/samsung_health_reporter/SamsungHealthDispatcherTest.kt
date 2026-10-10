package com.kvs.samsung_health_reporter

import com.kvs.samsunghealthreporter.SamsungHealthException
import com.kvs.samsunghealthreporter.model.Aggregate
import com.kvs.samsunghealthreporter.model.ChangeSet
import com.kvs.samsunghealthreporter.model.Device
import com.kvs.samsunghealthreporter.model.Ordering
import com.kvs.samsunghealthreporter.model.Page
import com.kvs.samsunghealthreporter.model.Permission
import com.kvs.samsunghealthreporter.model.SourceFilter
import com.kvs.samsunghealthreporter.model.TimeGroup
import com.kvs.samsunghealthreporter.model.TimeRange
import com.kvs.samsunghealthreporter.model.payload.HeartRate
import com.kvs.samsunghealthreporter.model.payload.SkinTemperature
import com.kvs.samsunghealthreporter.model.payload.UserProfile
import com.kvs.samsunghealthreporter.model.type.AccessType
import com.kvs.samsunghealthreporter.model.type.Aggregation
import com.kvs.samsunghealthreporter.model.type.HealthType
import com.kvs.samsunghealthreporter.model.type.TimeGroupUnit
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.mockk.coEvery
import io.mockk.coVerify
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.emptyFlow
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull
import kotlin.test.assertTrue
import kotlin.time.Duration.Companion.minutes
import kotlin.time.Duration.Companion.seconds

@OptIn(ExperimentalCoroutinesApi::class)
class SamsungHealthDispatcherTest {
    private val health = mockk<SamsungHealth>()
    private val opened = mutableMapOf<String, EventChannel.StreamHandler>()
    private val closed = mutableListOf<String>()
    private val sut =
        SamsungHealthDispatcher(
            health,
            TestScope(UnconfinedTestDispatcher()),
            open = { name, handler -> opened[name] = handler },
            close = { closed += it },
        )

    private val heartRateMap =
        mapOf(
            "type" to "heart_rate",
            "startTimestamp" to 1_760_000_000_000L,
            "endTimestamp" to 1_760_000_060_000L,
            "harmonized" to mapOf("heartRate" to 72.0),
        )
    private val heartRate = HeartRate(1_760_000_000_000L, 1_760_000_060_000L, HeartRate.Harmonized(72f))
    private val range = mapOf("start" to 1_760_000_000_000L, "end" to 1_760_086_400_000L)

    /** Records the reply of one call */
    private class Reply : MethodChannel.Result {
        var value: Any? = null
        var error: Triple<String, String?, Any?>? = null
        var notImplemented = false

        override fun success(result: Any?) {
            value = result
        }

        override fun error(
            errorCode: String,
            errorMessage: String?,
            errorDetails: Any?,
        ) {
            error = Triple(errorCode, errorMessage, errorDetails)
        }

        override fun notImplemented() {
            notImplemented = true
        }
    }

    private fun call(
        method: String,
        arguments: Any? = null,
    ): Reply = Reply().also { sut.onMethodCall(MethodCall(method, arguments), it) }

    @Test
    fun unknown_method_is_not_implemented() {
        assertTrue(call("unknown").notImplemented)
    }

    @Test
    fun is_available_replies_the_check() {
        every { health.isAvailable() } returns true

        assertEquals(true, call("isAvailable").value)
    }

    @Test
    fun request_permissions_sends_the_types_and_replies_the_granted_permissions() {
        coEvery {
            health.requestPermissions(
                setOf(HealthType.HEART_RATE, HealthType.SLEEP),
                setOf(HealthType.SLEEP),
            )
        } returns
            setOf(Permission(HealthType.HEART_RATE, AccessType.READ))

        val sut = call("requestPermissions", mapOf("read" to listOf("heart_rate", "sleep"), "write" to listOf("sleep")))

        assertEquals("""[{"type":"HEART_RATE","access":"READ"}]""", sut.value)
    }

    @Test
    fun granted_permissions_and_is_authorized_read_without_write() {
        coEvery { health.grantedPermissions(setOf(HealthType.STEPS), emptySet()) } returns emptySet()
        coEvery { health.isAuthorized(setOf(HealthType.STEPS), emptySet()) } returns false

        assertEquals("[]", call("grantedPermissions", mapOf("read" to listOf("steps"))).value)
        assertEquals(false, call("isAuthorized", mapOf("read" to listOf("steps"))).value)
    }

    @Test
    fun resolve_replies_whether_a_fix_started() {
        every { health.resolve() } returns false

        assertEquals(false, call("resolve").value)
    }

    @Test
    fun devices_reply_their_json() {
        val device = Device("phone", "MOBILE", "Samsung", "SM-S928B", "Galaxy")
        coEvery { health.localDevice() } returns device
        coEvery { health.devices() } returns listOf(device)
        coEvery { health.device("phone") } returns device
        coEvery { health.device("watch") } returns null

        assertEquals(device.json, call("localDevice").value)
        assertEquals("[${device.json}]", call("devices").value)
        assertEquals(device.json, call("device", mapOf("id" to "phone")).value)
        assertNull(call("device", mapOf("id" to "watch")).value)
    }

    @Test
    fun read_sends_every_argument_and_replies_a_json_array() {
        coEvery {
            health.read(
                HealthType.HEART_RATE,
                TimeRange(1_760_000_000_000L, 1_760_086_400_000L),
                Ordering.ASCENDING,
                10,
                SourceFilter.App("com.example"),
            )
        } returns listOf(heartRate, heartRate)

        val sut =
            call(
                "read",
                range +
                    mapOf(
                        "type" to "heart_rate",
                        "ordering" to "ASCENDING",
                        "limit" to 10,
                        "source" to "app",
                        "appId" to "com.example",
                    ),
            )

        assertEquals("[${heartRate.json},${heartRate.json}]", sut.value)
    }

    @Test
    fun read_defaults_to_newest_first_from_every_source() {
        coEvery { health.read(HealthType.SLEEP, any(), Ordering.DESCENDING, null, null) } returns emptyList()

        assertEquals("[]", call("read", range + mapOf("type" to "sleep")).value)
    }

    @Test
    fun read_page_replies_the_items_and_the_next_token() {
        coEvery {
            health.readPage(HealthType.HEART_RATE, any(), 100, null, Ordering.DESCENDING, SourceFilter.LocalDevice)
        } returns Page(listOf(heartRate), "next")
        coEvery {
            health.readPage(HealthType.HEART_RATE, any(), 5, "next", Ordering.DESCENDING, SourceFilter.SamsungHealth)
        } returns Page(emptyList(), null)

        val first = call("readPage", range + mapOf("type" to "heart_rate", "source" to "localDevice"))
        val last =
            call(
                "readPage",
                range +
                    mapOf("type" to "heart_rate", "pageSize" to 5, "pageToken" to "next", "source" to "samsungHealth"),
            )

        assertEquals("""{"items":[${heartRate.json}],"nextPageToken":"next"}""", first.value)
        assertEquals("""{"items":[]}""", last.value)
    }

    @Test
    fun user_profile_replies_its_json_or_null() {
        coEvery { health.userProfile() } returnsMany listOf(UserProfile(nickname = "kvs"), null)

        assertEquals(UserProfile(nickname = "kvs").json, call("userProfile").value)
        assertNull(call("userProfile").value)
    }

    @Test
    fun aggregate_sends_the_group_and_defaults_to_oldest_first() {
        val aggregate = Aggregate(Aggregation.STEPS_TOTAL, 0, 1, 1234.0)
        coEvery {
            health.aggregate(
                Aggregation.STEPS_TOTAL,
                any(),
                TimeGroup(TimeGroupUnit.HOURLY, 2),
                Ordering.ASCENDING,
            )
        } returns listOf(aggregate)
        coEvery { health.aggregate(Aggregation.SLEEP_TOTAL_DURATION, any(), null, Ordering.DESCENDING) } returns
            emptyList()

        val grouped =
            call(
                "aggregate",
                range + mapOf("aggregation" to "STEPS_TOTAL", "groupUnit" to "HOURLY", "groupMultiplier" to 2),
            )
        val whole =
            call("aggregate", range + mapOf("aggregation" to "SLEEP_TOTAL_DURATION", "ordering" to "DESCENDING"))

        assertEquals("[${aggregate.json}]", grouped.value)
        assertEquals("[]", whole.value)
    }

    @Test
    fun insert_makes_samples_from_maps_and_replies_the_inserted_ones() {
        val inserted = heartRate.copy(clientDataId = "id")
        coEvery { health.insert(listOf(heartRate)) } returns listOf(inserted)

        assertEquals("[${inserted.json}]", call("insert", mapOf("samples" to listOf(heartRateMap))).value)
    }

    @Test
    fun update_and_delete_reply_true() {
        coEvery { health.update(listOf(heartRate)) } returns Unit
        coEvery { health.delete(heartRate) } returns Unit
        coEvery { health.deleteByUids(HealthType.HEART_RATE, listOf("uid")) } returns Unit
        coEvery { health.deleteByClientDataIds(HealthType.WATER_INTAKE, listOf("id")) } returns Unit

        assertEquals(true, call("update", mapOf("samples" to listOf(heartRateMap))).value)
        assertEquals(true, call("delete", mapOf("sample" to heartRateMap)).value)
        assertEquals(true, call("deleteByUids", mapOf("type" to "heart_rate", "uids" to listOf("uid"))).value)
        assertEquals(
            true,
            call("deleteByClientDataIds", mapOf("type" to "water_intake", "clientDataIds" to listOf("id"))).value,
        )
        coVerify { health.deleteByClientDataIds(HealthType.WATER_INTAKE, listOf("id")) }
    }

    @Test
    fun delete_takes_read_only_samples() {
        val skin = SkinTemperature(0, 1, SkinTemperature.Harmonized(33f), uid = "uid")
        coEvery { health.delete(skin) } returns Unit

        val map =
            mapOf(
                "type" to "skin_temperature",
                "startTimestamp" to 0,
                "endTimestamp" to 1,
                "uid" to "uid",
                "harmonized" to mapOf("skinTemperature" to 33),
            )

        assertEquals(true, call("delete", mapOf("sample" to map)).value)
    }

    @Test
    fun insert_of_a_read_only_sample_fails_with_invalid_type() {
        val map =
            mapOf(
                "type" to "skin_temperature",
                "startTimestamp" to 0,
                "endTimestamp" to 1,
                "harmonized" to mapOf("skinTemperature" to 33),
            )

        val sut = call("insert", mapOf("samples" to listOf(map)))

        assertEquals("insert", sut.error?.first)
        assertEquals("InvalidType", sut.error?.third)
    }

    @Test
    fun changes_send_the_window() {
        val changeSet = ChangeSet(HealthType.SLEEP, 1, 2, emptyList(), listOf("gone"))
        coEvery { health.changes(HealthType.SLEEP, 1, null) } returns changeSet
        coEvery { health.changes(HealthType.SLEEP, 1, 2) } returns changeSet

        assertEquals(changeSet.json, call("changes", mapOf("type" to "sleep", "since" to 1)).value)
        assertEquals(changeSet.json, call("changes", mapOf("type" to "sleep", "since" to 1, "until" to 2)).value)
    }

    @Test
    fun observe_opens_an_event_channel_of_its_own_per_subscription() {
        every { health.observe(HealthType.HEART_RATE, 1, 30.seconds) } returns emptyFlow()
        every { health.observe(HealthType.SLEEP, 1, 1.minutes) } returns emptyFlow()

        val first = call("observe", mapOf("type" to "heart_rate", "since" to 1, "interval" to 30_000)).value as String
        val second = call("observe", mapOf("type" to "sleep", "since" to 1)).value as String

        assertTrue(first.startsWith("samsung_health_reporter_event_channel_observe_"))
        assertTrue(first != second)
        assertEquals(setOf(first, second), opened.keys)
    }

    @Test
    fun cancelling_an_observe_subscription_closes_its_channel() {
        every { health.observe(HealthType.HEART_RATE, 1, 1.minutes) } returns emptyFlow()
        val name = call("observe", mapOf("type" to "heart_rate", "since" to 1)).value as String

        opened.getValue(name).onCancel(null)

        assertEquals(listOf(name), closed)
    }

    @Test
    fun observe_of_a_type_without_changes_fails_the_call() {
        val sut = call("observe", mapOf("type" to "steps", "since" to 1))

        assertEquals(Triple("observe", "steps is not observable", "InvalidType"), sut.error)
        assertTrue(opened.isEmpty())
        verify(exactly = 0) { health.observe(any(), any(), any()) }
    }

    @Test
    fun missing_arguments_fail_with_the_method_as_code() {
        val sut = call("read", mapOf("type" to "heart_rate"))

        assertEquals(Triple("read", "Missing argument: start", "InvalidValue"), sut.error)
    }

    @Test
    fun non_map_arguments_fail_with_invalid_value() {
        assertEquals("InvalidValue", call("read", listOf(1)).error?.third)
    }

    @Test
    fun library_errors_reply_their_message_and_kind() {
        coEvery { health.localDevice() } throws SamsungHealthException.NotAuthorized("No permission")
        coEvery { health.devices() } throws SamsungHealthException.Platform("Policy", 2003)

        assertEquals(Triple("localDevice", "No permission", "NotAuthorized"), call("localDevice").error)
        assertEquals(Triple("devices", "Policy", "Platform(2003)"), call("devices").error)
    }
}
