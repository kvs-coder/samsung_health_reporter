package com.kvs.samsung_health_reporter

import android.app.Activity
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.kvs.samsunghealthreporter.*
import com.kvs.samsunghealthreporter.decorator.toJson
import com.kvs.samsunghealthreporter.manager.SamsungHealthPermissionListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.lang.Exception
import java.util.*

/** SamsungHealthReporterPlugin */
class SamsungHealthReporterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    internal enum class Method(val string: String) {
        AUTHORIZE("authorize"),
        READ_STEPS("readSteps");

        companion object {
            fun initWith(string: String): Method? {
                return when (string) {
                    AUTHORIZE.string -> AUTHORIZE
                    READ_STEPS.string -> READ_STEPS
                    else -> null
                }
            }
        }
    }

    private lateinit var mChannel: MethodChannel
    private var mReporter: SamsungHealthReporter? = null
    private var mActivity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        mChannel = MethodChannel(
                flutterPluginBinding.binaryMessenger,
                "samsung_health_reporter_method_channel"
        )
        try {
            mReporter = SamsungHealthReporter(flutterPluginBinding.applicationContext)
            mReporter?.openConnection()
        } catch (exception: Exception) {
            exception.printStackTrace()
        }
        mChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val reporter = mReporter
        if (reporter != null) {
            val callMethod = call.method
            val method = Method.initWith(callMethod)
            if (method != null) {
                when (method) {
                    Method.AUTHORIZE -> {
                        authorize(reporter, call, result)
                    }
                    Method.READ_STEPS -> {
                        readSteps(reporter, call, result)
                    }
                }
            } else {
                result.error(
                        "Method",
                        "Method is NULL",
                        callMethod
                )
            }
        } else {
            result.error(
                    "SamsungHealthReporter",
                    "Reporter is NULL",
                    null
            )
        }
    }

    private fun readSteps(reporter: SamsungHealthReporter, call: MethodCall, result: MethodChannel.Result) {
        val startTime = call.argument("startTime") as? Long
        val endTime = call.argument("endTime") as? Long
        if (startTime != null && endTime != null) {
            runOnBackground {
                val steps = reporter.resolver.stepCountResolver.read(
                        Date(startTime),
                        Date(endTime),
                        null,
                        null
                )
                runOnMain {
                    result.success(steps.toJson())
                }
            }
        } else {
            result.error(
                    "Arguments",
                    "Invalid start or end time. ${call.arguments}",
                    null
            )
        }
    }

    private fun authorize(reporter: SamsungHealthReporter, call: MethodCall, result: MethodChannel.Result) {
        val activity = mActivity
        if (activity != null) {
            val manager = reporter.manager
            manager.permissionListener = object : SamsungHealthPermissionListener {
                override fun onAcquired(success: Boolean) {
                    result.success(success)
                }

                override fun onException(exception: Exception) {
                    result.error(
                            "SamsungHealthReporter",
                            "onException",
                            exception
                    )
                }
            }
            val toReadArguments = call.argument("toRead") as? List<String>
            val toWriteArguments = call.argument("toWrite") as? List<String>
            manager.authorize(
                    activity,
                    toReadTypes = if (toReadArguments != null) parse(toReadArguments) else setOf(),
                    toWriteTypes = if (toWriteArguments != null) parse(toWriteArguments) else setOf()
            )
        } else {
            result.error(
                    "Authorize",
                    "Activity was NULL",
                    null
            )
        }
    }

    private fun parse(arguments: List<String>): Set<HealthType> {
        val set = mutableSetOf<HealthType>()
        for (element in arguments) {
            try {
                val type = HealthType.initWith(element)
                set.add(type)
            } catch (exception: Exception) {
                continue
            }
        }
        return set
    }

    private fun runOnBackground(function: () -> Unit) {
        Thread {
            function()
        }.start()
    }

    private fun runOnMain(function: () -> Unit) {
        Handler(Looper.getMainLooper()).post {
            function()
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        mActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mActivity = binding.activity
    }

    override fun onDetachedFromActivity() {
        mActivity = null
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        mChannel.setMethodCallHandler(null)
        mReporter?.closeConnection()
        mReporter = null
    }
}
