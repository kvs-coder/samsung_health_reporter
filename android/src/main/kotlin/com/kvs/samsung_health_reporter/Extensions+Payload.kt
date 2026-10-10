package com.kvs.samsung_health_reporter

import com.kvs.samsunghealthreporter.SamsungHealthException
import com.kvs.samsunghealthreporter.model.Page
import com.kvs.samsunghealthreporter.model.Payload
import com.kvs.samsunghealthreporter.model.Permission
import com.kvs.samsunghealthreporter.model.payload.Sample
import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonPrimitive

// Replies to Dart: the library's JSON, lists as JSON arrays of it

/** **String** JSON array of the payloads' JSON */
internal val List<Payload>.json: String
    get() = joinToString(",", "[", "]") { it.json }

/** **String** `{"items":[...],"nextPageToken":"..."}`; the token is omitted on the last page */
internal val Page<Sample>.json: String
    get() =
        buildString {
            append("{\"items\":").append(items.json)
            nextPageToken?.let { append(",\"nextPageToken\":").append(JsonPrimitive(it)) }
            append("}")
        }

/** **String** JSON array of the permissions, e.g. `[{"type":"HEART_RATE","access":"READ"}]` */
internal val Set<Permission>.json: String
    get() = Json.encodeToString(ListSerializer(Permission.serializer()), toList())

/**
 * **String** the error's kind for `PlatformException.details`: `NotAuthorized`, `InvalidType`, `InvalidValue`,
 * `Resolvable` or `Platform` (with the SDK error code when known, e.g. `Platform(2003)`)
 */
internal val Throwable.details: String
    get() =
        when (this) {
            is SamsungHealthException.NotAuthorized -> "NotAuthorized"
            is SamsungHealthException.InvalidType -> "InvalidType"
            is SamsungHealthException.InvalidValue -> "InvalidValue"
            is SamsungHealthException.Resolvable -> "Resolvable"
            is SamsungHealthException.Platform -> errorCode?.let { "Platform($it)" } ?: "Platform"
            else -> javaClass.simpleName
        }

internal val Throwable.description: String
    get() = message ?: toString()
