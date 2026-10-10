package com.kvs.samsung_health_reporter

import com.kvs.samsunghealthreporter.SamsungHealthException
import com.kvs.samsunghealthreporter.model.Ordering
import com.kvs.samsunghealthreporter.model.SourceFilter
import com.kvs.samsunghealthreporter.model.TimeGroup
import com.kvs.samsunghealthreporter.model.TimeRange
import com.kvs.samsunghealthreporter.model.payload.BloodGlucose
import com.kvs.samsunghealthreporter.model.payload.BloodOxygen
import com.kvs.samsunghealthreporter.model.payload.BloodPressure
import com.kvs.samsunghealthreporter.model.payload.BodyComposition
import com.kvs.samsunghealthreporter.model.payload.BodyTemperature
import com.kvs.samsunghealthreporter.model.payload.EnergyScore
import com.kvs.samsunghealthreporter.model.payload.Exercise
import com.kvs.samsunghealthreporter.model.payload.FloorsClimbed
import com.kvs.samsunghealthreporter.model.payload.HeartRate
import com.kvs.samsunghealthreporter.model.payload.IrregularHeartRhythmNotification
import com.kvs.samsunghealthreporter.model.payload.Nutrition
import com.kvs.samsunghealthreporter.model.payload.Sample
import com.kvs.samsunghealthreporter.model.payload.SkinTemperature
import com.kvs.samsunghealthreporter.model.payload.Sleep
import com.kvs.samsunghealthreporter.model.payload.SleepApnea
import com.kvs.samsunghealthreporter.model.payload.WaterIntake
import com.kvs.samsunghealthreporter.model.payload.WritableSample
import com.kvs.samsunghealthreporter.model.type.Aggregation
import com.kvs.samsunghealthreporter.model.type.HealthType
import com.kvs.samsunghealthreporter.model.type.TimeGroupUnit

// Readers of the arguments Dart sends; a missing or mistyped argument throws SamsungHealthException.InvalidValue

private fun missing(key: String): Nothing = throw SamsungHealthException.InvalidValue("Missing argument: $key")

internal fun Map<String, Any?>.string(key: String): String = this[key] as? String ?: missing(key)

internal fun Map<String, Any?>.optionalString(key: String): String? = this[key] as? String

// Dart ints arrive as Integer or Long, depending on their size
internal fun Map<String, Any?>.long(key: String): Long = (this[key] as? Number)?.toLong() ?: missing(key)

internal fun Map<String, Any?>.optionalLong(key: String): Long? = (this[key] as? Number)?.toLong()

internal fun Map<String, Any?>.optionalInt(key: String): Int? = (this[key] as? Number)?.toInt()

internal fun Map<String, Any?>.strings(key: String): List<String> =
    (this[key] as? List<*>)?.map { it as? String ?: missing(key) } ?: missing(key)

@Suppress("UNCHECKED_CAST")
internal fun Map<String, Any?>.map(key: String): Map<String, Any?> =
    (this[key] as? Map<*, *>)?.takeIf { map -> map.keys.all { it is String } } as? Map<String, Any?> ?: missing(key)

@Suppress("UNCHECKED_CAST")
internal fun Map<String, Any?>.maps(key: String): List<Map<String, Any?>> =
    (this[key] as? List<*>)?.map { element ->
        (element as? Map<*, *>)?.takeIf { map -> map.keys.all { it is String } } as? Map<String, Any?> ?: missing(key)
    } ?: missing(key)

internal fun Map<String, Any?>.healthType(key: String = "type"): HealthType = HealthType.make(string(key))

/** Optional type lists, e.g. `read` and `write` of the permission calls */
internal fun Map<String, Any?>.healthTypes(key: String): Set<HealthType> =
    if (this[key] == null) emptySet() else strings(key).mapTo(mutableSetOf()) { HealthType.make(it) }

internal fun Map<String, Any?>.timeRange(): TimeRange = TimeRange(long("start"), long("end"))

internal fun Map<String, Any?>.ordering(default: Ordering): Ordering =
    optionalString("ordering")?.let { name ->
        Ordering.entries.firstOrNull { it.name == name }
            ?: throw SamsungHealthException.InvalidValue("Invalid ordering: $name")
    } ?: default

/** `source` is `app` (with `appId`), `localDevice` or `samsungHealth`; none reads every source */
internal fun Map<String, Any?>.sourceFilter(): SourceFilter? =
    when (val source = optionalString("source")) {
        null -> null
        "app" -> SourceFilter.App(string("appId"))
        "localDevice" -> SourceFilter.LocalDevice
        "samsungHealth" -> SourceFilter.SamsungHealth
        else -> throw SamsungHealthException.InvalidValue("Invalid source: $source")
    }

internal fun Map<String, Any?>.aggregation(): Aggregation = Aggregation.make(string("aggregation"))

internal fun Map<String, Any?>.timeGroup(): TimeGroup? =
    optionalString("groupUnit")?.let { name ->
        val unit =
            TimeGroupUnit.entries.firstOrNull { it.name == name }
                ?: throw SamsungHealthException.InvalidValue("Invalid groupUnit: $name")
        TimeGroup(unit, optionalInt("groupMultiplier") ?: 1)
    }

/** A sample's map, as Dart's `map` sends it: its `type` names the payload */
internal val Map<String, Any?>.sample: Sample
    get() =
        when (healthType()) {
            HealthType.HEART_RATE -> HeartRate.make(this)

            HealthType.BLOOD_OXYGEN -> BloodOxygen.make(this)

            HealthType.BLOOD_PRESSURE -> BloodPressure.make(this)

            HealthType.BLOOD_GLUCOSE -> BloodGlucose.make(this)

            HealthType.BODY_COMPOSITION -> BodyComposition.make(this)

            HealthType.BODY_TEMPERATURE -> BodyTemperature.make(this)

            HealthType.SKIN_TEMPERATURE -> SkinTemperature.make(this)

            HealthType.EXERCISE -> Exercise.make(this)

            HealthType.FLOORS_CLIMBED -> FloorsClimbed.make(this)

            HealthType.SLEEP -> Sleep.make(this)

            HealthType.NUTRITION -> Nutrition.make(this)

            HealthType.WATER_INTAKE -> WaterIntake.make(this)

            HealthType.ENERGY_SCORE -> EnergyScore.make(this)

            HealthType.IRREGULAR_HEART_RHYTHM_NOTIFICATION -> IrregularHeartRhythmNotification.make(this)

            HealthType.SLEEP_APNEA -> SleepApnea.make(this)

            HealthType.STEPS,
            HealthType.STEPS_GOAL,
            HealthType.ACTIVITY_SUMMARY,
            HealthType.ACTIVE_CALORIES_BURNED_GOAL,
            HealthType.ACTIVE_TIME_GOAL,
            HealthType.EXERCISE_LOCATION,
            HealthType.SLEEP_GOAL,
            HealthType.NUTRITION_GOAL,
            HealthType.WATER_INTAKE_GOAL,
            HealthType.USER_PROFILE,
            -> throw SamsungHealthException.InvalidType("${healthType().identifier} has no samples")
        }

internal val Map<String, Any?>.writableSample: WritableSample
    get() =
        sample as? WritableSample
            ?: throw SamsungHealthException.InvalidType("${healthType().identifier} is not writable")
