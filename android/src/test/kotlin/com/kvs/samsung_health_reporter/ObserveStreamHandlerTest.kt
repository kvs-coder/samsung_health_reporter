package com.kvs.samsung_health_reporter

import com.kvs.samsunghealthreporter.SamsungHealthException
import com.kvs.samsunghealthreporter.model.ChangeSet
import com.kvs.samsunghealthreporter.model.type.HealthType
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.awaitCancellation
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@OptIn(ExperimentalCoroutinesApi::class)
class ObserveStreamHandlerTest {
    private val scope = TestScope(UnconfinedTestDispatcher())
    private val changeSet = ChangeSet(HealthType.HEART_RATE, 1, 2, emptyList(), listOf("gone"))

    /** Records the events of one subscription */
    private class Events : EventChannel.EventSink {
        val values = mutableListOf<Any?>()
        val errors = mutableListOf<Triple<String, String?, Any?>>()

        override fun success(event: Any?) {
            values += event
        }

        override fun error(
            errorCode: String,
            errorMessage: String?,
            errorDetails: Any?,
        ) {
            errors += Triple(errorCode, errorMessage, errorDetails)
        }

        override fun endOfStream() = Unit
    }

    @Test
    fun listening_sends_every_change_set_as_json() {
        val events = Events()
        val sut = ObserveStreamHandler(flowOf(changeSet, changeSet), scope) {}

        sut.onListen(null, events)

        assertEquals(listOf<Any?>(changeSet.json, changeSet.json), events.values)
    }

    @Test
    fun an_error_reaches_dart_with_the_observe_code() {
        val events = Events()
        val sut =
            ObserveStreamHandler(
                flow<ChangeSet> { throw SamsungHealthException.NotAuthorized("No permission") },
                scope,
            ) {}

        sut.onListen(null, events)

        assertEquals(
            listOf<Triple<String, String?, Any?>>(Triple("observe", "No permission", "NotAuthorized")),
            events.errors,
        )
    }

    @Test
    fun cancelling_stops_polling_and_closes_the_channel() {
        var polling = false
        var closed = false
        val sut =
            ObserveStreamHandler(
                flow<ChangeSet> {
                    polling = true
                    try {
                        awaitCancellation()
                    } finally {
                        polling = false
                    }
                },
                scope,
            ) { closed = true }

        sut.onListen(null, Events())
        assertTrue(polling)
        sut.onCancel(null)

        assertEquals(false, polling)
        assertTrue(closed)
    }
}
