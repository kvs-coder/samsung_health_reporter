package com.kvs.samsung_health_reporter

import com.kvs.samsunghealthreporter.model.ChangeSet
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.launch

/**
 * Collects the change sets of one observe subscription while Dart listens and sends each as its JSON.
 *
 * An error ends polling and reaches Dart's `onError` with the code `observe`. Cancelling stops polling and calls
 * [onClose], so the subscription's event channel is closed.
 */
class ObserveStreamHandler(
    private val changeSets: Flow<ChangeSet>,
    private val scope: CoroutineScope,
    private val onClose: () -> Unit,
) : EventChannel.StreamHandler {
    private var job: Job? = null

    override fun onListen(
        arguments: Any?,
        events: EventChannel.EventSink,
    ) {
        job =
            scope.launch {
                try {
                    changeSets.collect { events.success(it.json) }
                } catch (exception: CancellationException) {
                    throw exception
                } catch (exception: Exception) {
                    events.error(Method.observe.name, exception.description, exception.details)
                }
            }
    }

    override fun onCancel(arguments: Any?) {
        job?.cancel()
        job = null
        // Not while the channel still handles the cancel message
        scope.launch { onClose() }
    }
}
