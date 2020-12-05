package com.kvs.samsung_health_reporter
//
//import android.app.Activity
//import com.kvs.samsunghealthreporter.HealthType
//import com.kvs.samsunghealthreporter.SamsungHealthConnectionException
//import com.kvs.samsunghealthreporter.SamsungHealthInitializationException
//import com.kvs.samsunghealthreporter.SamsungHealthReporter
//import com.kvs.samsunghealthreporter.manager.SamsungHealthConnectionListener
//import com.kvs.samsunghealthreporter.manager.SamsungHealthManager
//import com.kvs.samsunghealthreporter.manager.SamsungHealthPermissionListener
//import com.kvs.samsunghealthreporter.observer.SamsungHealthObserver
//import com.kvs.samsunghealthreporter.resolver.SamsungHealthResolver
//import io.flutter.embedding.engine.plugins.FlutterPlugin
//import io.flutter.plugin.common.EventChannel
//import java.lang.Exception
//
//class SamsungHealthReporterStreamHandler(
//        private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
//) {
//    enum class Event(private val string: String) {
//        ON_CONNECTION_OPEN("on_connection_open"),
//        ON_CONNECTED("on_connected"),
//        ON_CONNECTION_FAILED("on_connection_failed"),
//        ON_DISCONNECTED("on_disconnected"),
//        ON_PERMISSION_ACQUIRED("on_permission_acquired"),
//        ON_PERMISSION_EXCEPTION("on_exception"),
//        ON_OBSERVER_CHANGE("on_observer_change"),
//        ON_OBSERVER_EXCEPTION("on_observer_exception");
//
//        companion object {
//            fun initWith(string: String): Event? {
//                return when (string) {
//                    ON_CONNECTION_OPEN.string -> ON_CONNECTION_OPEN
//                    ON_CONNECTED.string -> ON_CONNECTED
//                    ON_CONNECTION_FAILED.string -> ON_CONNECTION_FAILED
//                    ON_DISCONNECTED.string -> ON_DISCONNECTED
//                    ON_PERMISSION_ACQUIRED.string -> ON_PERMISSION_ACQUIRED
//                    ON_PERMISSION_EXCEPTION.string -> ON_PERMISSION_EXCEPTION
//                    ON_OBSERVER_CHANGE.string -> ON_OBSERVER_CHANGE
//                    ON_OBSERVER_EXCEPTION.string -> ON_OBSERVER_EXCEPTION
//                    else -> null
//                }
//            }
//        }
//
//        val channelName: String get() = "samsung_health_reporter_event_channel_$string"
//    }
//
//    fun setStreamHandler(activity: Activity, forEvent: Event) {
//        val eventChannel = EventChannel(
//                flutterPluginBinding.binaryMessenger,
//                forEvent.channelName
//        )
//        eventChannel.setStreamHandler(
//                object : EventChannel.StreamHandler {
//                    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
//                        if (arguments != null) {
//                            val args = arguments as Map<*, *>
//                            val eventMethod = args["eventMethod"] as? String
//                            if (eventMethod != null) {
//                                val event = Event.initWith(eventMethod)
//                                if (event != null) {
//                                    try {
//                                        var mngr: SamsungHealthManager? = null
//                                        var rslvr: SamsungHealthResolver? = null
//                                        var obsrv: SamsungHealthObserver? = null
//                                        val connectionListener = object : SamsungHealthConnectionListener {
//                                            override fun onConnected(manager: SamsungHealthManager) {
//                                                mngr = manager
//                                                events?.success(true)
//                                            }
//
//                                            override fun onDisconnected() {
//                                                mngr = null
//                                                events?.success(false)
//                                            }
//
//                                            override fun onConnectionFailed(exception: SamsungHealthConnectionException) {
//                                                mngr = null
//                                                events?.error(
//                                                        "onConnectionFailed",
//                                                        "Failed to connect to Samsung Health",
//                                                        exception
//                                                )
//                                            }
//                                        }
//                                        val permissionListener = object : SamsungHealthPermissionListener {
//                                            override fun onPermissionAcquired(
//                                                    types: Set<HealthType>,
//                                                    resolver: SamsungHealthResolver,
//                                                    observer: SamsungHealthObserver
//                                            ) {
//                                                rslvr = resolver
//                                                obsrv = observer
//                                                events?.success(true)
//                                            }
//
//                                            override fun onException(exception: Exception) {
//                                                events?.success(false)
//                                            }
//                                        }
//                                        val reporter = SamsungHealthReporter(
//                                                flutterPluginBinding.applicationContext,
//                                                connectionListener = connectionListener,
//                                                permissionListener = permissionListener
//                                        )
//                                        // as method!!!
//                                        //reporter.openConnection()
//                                        when (event) {
//                                            Event.ON_CONNECTION_OPEN -> {
//                                                reporter.openConnection()
//                                            }
//                                            Event.ON_CONNECTED -> {
//                                                val toReadArguments = arguments["toRead"] as? List<*>
//                                                val toWriteArguments = arguments["toWrite"] as? List<*>
//                                                mngr?.authorize(
//                                                        activity,
//                                                        toReadTypes = if (toReadArguments != null) parse(toReadArguments) else setOf(),
//                                                        toWriteTypes = if (toWriteArguments != null) parse(toWriteArguments) else setOf()
//                                                )
//                                            }
//                                            Event.ON_CONNECTION_FAILED -> TODO()
//                                            Event.ON_DISCONNECTED -> TODO()
//                                            Event.ON_PERMISSION_ACQUIRED -> {
//                                                //method calls i.e
//                                                val invokeMethod = arguments["invokeMethod"] as? String
//
//                                            }
//                                            Event.ON_PERMISSION_EXCEPTION -> TODO()
//                                            Event.ON_OBSERVER_CHANGE -> TODO()
//                                            Event.ON_OBSERVER_EXCEPTION -> TODO()
//                                        }
//                                    } catch (exception: SamsungHealthInitializationException) {
//                                        events?.error(
//                                                "SamsungHealthReporter",
//                                                "Can not be initialized",
//                                                exception
//                                        )
//                                    }
//                                } else {
//                                    events?.error(
//                                            "Bad arguments",
//                                            "Event method was unknown: $eventMethod",
//                                            null
//                                    )
//                                }
//                            } else {
//                                events?.error(
//                                        "Bad arguments",
//                                        "Event method was null",
//                                        null
//                                )
//                            }
//                        } else {
//                            events?.error(
//                                    "Bad arguments",
//                                    "Arguments were NULL",
//                                    null
//                            )
//                        }
//                    }
//
//                    override fun onCancel(arguments: Any?) {}
//                }
//        )
//    }
//
//    private fun parse(arguments: List<*>): Set<HealthType>{
//        val set = mutableSetOf<HealthType>()
//        for (element in arguments) {
//            val string = element as? String
//            if (string != null) {
//                try {
//                    val type = HealthType.initWith(string)
//                    set.add(type)
//                } catch (exception: Exception) {
//                    continue
//                }
//            }
//        }
//        return set
//    }
//}