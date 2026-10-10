package com.kvs.samsung_health_reporter

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.cancel

/**
 * The Android side of the plugin: Samsung Health through SamsungHealthReporter.
 *
 * One [ReporterSamsungHealth] serves the method channel and every observe subscription. Calls run in a
 * plugin-owned scope on the main thread, which is cancelled when the engine detaches.
 */
class SamsungHealthReporterPlugin :
    FlutterPlugin,
    ActivityAware {
    private var methodChannel: MethodChannel? = null
    private var scope: CoroutineScope? = null
    private var activity: Activity? = null

    /** The event channel of every observe subscription, until Dart cancels it */
    private val eventChannels = mutableMapOf<String, EventChannel>()

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val messenger = binding.binaryMessenger
        val scope = MainScope().also { scope = it }
        val dispatcher =
            SamsungHealthDispatcher(
                health = ReporterSamsungHealth(binding.applicationContext) { activity },
                scope = scope,
                open = { name, handler -> open(messenger, name, handler) },
                close = { name -> eventChannels.remove(name)?.setStreamHandler(null) },
            )
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL).apply { setMethodCallHandler(dispatcher) }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        eventChannels.values.forEach { it.setStreamHandler(null) }
        eventChannels.clear()
        scope?.cancel()
        scope = null
    }

    private fun open(
        messenger: BinaryMessenger,
        name: String,
        handler: EventChannel.StreamHandler,
    ) {
        eventChannels[name] = EventChannel(messenger, name).apply { setStreamHandler(handler) }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
