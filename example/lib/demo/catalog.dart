import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samsung_health_reporter/model/payload/blood_glucose.dart';
import 'package:samsung_health_reporter/model/payload/blood_oxygen.dart';
import 'package:samsung_health_reporter/model/payload/blood_pressure.dart';
import 'package:samsung_health_reporter/model/payload/body_composition.dart';
import 'package:samsung_health_reporter/model/payload/body_temperature.dart';
import 'package:samsung_health_reporter/model/payload/exercise.dart';
import 'package:samsung_health_reporter/model/payload/floors_climbed.dart';
import 'package:samsung_health_reporter/model/payload/heart_rate.dart';
import 'package:samsung_health_reporter/model/payload/nutrition.dart';
import 'package:samsung_health_reporter/model/payload/sample.dart';
import 'package:samsung_health_reporter/model/payload/sleep.dart';
import 'package:samsung_health_reporter/model/payload/water_intake.dart';
import 'package:samsung_health_reporter/model/source_filter.dart';
import 'package:samsung_health_reporter/model/time_group.dart';
import 'package:samsung_health_reporter/model/time_range.dart';
import 'package:samsung_health_reporter/model/type/aggregation.dart';
import 'package:samsung_health_reporter/model/type/exercise_type.dart';
import 'package:samsung_health_reporter/model/type/glucose_measurement_type.dart';
import 'package:samsung_health_reporter/model/type/health_type.dart';
import 'package:samsung_health_reporter/model/type/meal_status.dart';
import 'package:samsung_health_reporter/model/type/meal_type.dart';
import 'package:samsung_health_reporter/model/type/ordering.dart';
import 'package:samsung_health_reporter/model/type/sleep_stage_type.dart';
import 'package:samsung_health_reporter/model/type/time_group_unit.dart';
import 'package:samsung_health_reporter/samsung_health_reporter.dart';

import 'demo_row.dart';

/// Every public method of [SamsungHealthReporter], grouped like the library:
/// manager, reader, aggregates, writer and observer.
class Catalog {
  Catalog();

  /// Samples the writer rows inserted, by type
  final _inserted = <HealthType, WritableSample>{};

  static int get _now => DateTime.now().millisecondsSinceEpoch;

  static TimeRange get _today {
    final now = DateTime.now();
    return TimeRange.fromDates(
      DateTime(now.year, now.month, now.day),
      DateTime(now.year, now.month, now.day + 1),
    );
  }

  static TimeRange get _lastWeek {
    final now = DateTime.now();
    return TimeRange.fromDates(
      DateTime(now.year, now.month, now.day - 6),
      DateTime(now.year, now.month, now.day + 1),
    );
  }

  static final _readable = HealthType.values.where((e) => e.isReadable);
  static final _writable = HealthType.values.where((e) => e.isWritable);
  static final _observable = HealthType.values.where((e) => e.isObservable);

  /// Every type that has a read permission: readable types, aggregate-only
  /// types, exercise locations and the user profile
  static const _permissionTypes = HealthType.values;

  static String _json(Object? value) =>
      const JsonEncoder.withIndent('  ').convert(value);

  static String _samples(List<Sample> samples) =>
      '${samples.length} samples\n${_json(samples.take(3).map((e) => e.map).toList())}';

  late final List<DemoSection> sections = [
    DemoSection(
      'Manager',
      [
        DemoRow(
          'isAvailable',
          'Whether Samsung Health is installed',
          run: () async => '${await SamsungHealthReporter.isAvailable()}',
        ),
        DemoRow(
          'requestPermissions',
          'Read every type; write permissions need Samsung partner approval',
          run: () async {
            final granted = await SamsungHealthReporter.requestPermissions(
              read: _permissionTypes,
            );
            return '${granted.length} of ${_permissionTypes.length} granted';
          },
        ),
        DemoRow(
          'requestPermissions to write',
          'Write every writable type (fails with NotAuthorized without an access code)',
          run: () async {
            final granted = await SamsungHealthReporter.requestPermissions(
              write: _writable.toList(),
            );
            return '${granted.length} of ${_writable.length} granted';
          },
        ),
        DemoRow(
          'grantedPermissions',
          'Granted read permissions',
          run: () async {
            final granted = await SamsungHealthReporter.grantedPermissions(
              read: _permissionTypes,
            );
            return granted.map((e) => e.type.identifier).join('\n');
          },
        ),
        DemoRow(
          'isAuthorized',
          'Whether every read permission is granted',
          run: () async =>
              '${await SamsungHealthReporter.isAuthorized(read: _permissionTypes)}',
        ),
        DemoRow(
          'resolve',
          'Fix the last Resolvable error, e.g. update Samsung Health',
          run: () async => '${await SamsungHealthReporter.resolve()}',
        ),
        DemoRow(
          'localDevice',
          'This phone as a Samsung Health device',
          run: () async =>
              _json((await SamsungHealthReporter.localDevice()).map),
        ),
        DemoRow(
          'devices',
          'Own devices: phone, watch, ring, accessories',
          run: () async => _json(
            (await SamsungHealthReporter.devices()).map((e) => e.map).toList(),
          ),
        ),
        DemoRow(
          'device',
          'Look up this phone by its id',
          run: () async {
            final phone = await SamsungHealthReporter.localDevice();
            return _json((await SamsungHealthReporter.device(phone.id))?.map);
          },
        ),
      ],
      icon: Icons.admin_panel_settings_rounded,
      footer: 'Reading works in developer mode; writing needs partner approval',
    ),
    DemoSection(
        'Reader',
        [
          for (final type in _readable)
            DemoRow(
              'read ${type.identifier}',
              'The last 7 days',
              run: () async =>
                  _samples(await SamsungHealthReporter.read(type, _lastWeek)),
            ),
          DemoRow(
            'read with a source',
            "Today's heart rate measured by Samsung Health, oldest first",
            run: () async => _samples(
              await SamsungHealthReporter.read(
                HealthType.heartRate,
                _today,
                limit: 10,
                source: SourceFilter.samsungHealth,
                ordering: Ordering.ascending,
              ),
            ),
          ),
          DemoRow(
            'readPage',
            'Heart rate of the last 7 days, two pages of 5',
            run: () async {
              final first = await SamsungHealthReporter.readPage(
                HealthType.heartRate,
                _lastWeek,
                pageSize: 5,
              );
              final token = first.nextPageToken;
              if (token == null) return '1 page: ${first.items.length} samples';
              final second = await SamsungHealthReporter.readPage(
                HealthType.heartRate,
                _lastWeek,
                pageSize: 5,
                pageToken: token,
              );
              return '2 pages: ${first.items.length} + ${second.items.length} samples';
            },
          ),
          DemoRow(
            'userProfile',
            'Nickname, gender, birth date, height, weight',
            run: () async =>
                _json((await SamsungHealthReporter.userProfile())?.map),
          ),
        ],
        icon: Icons.menu_book_rounded),
    DemoSection(
        'Aggregates',
        [
          DemoRow(
            'aggregate STEPS_TOTAL by hour',
            'Steps per hour today',
            run: () async {
              final hours = await SamsungHealthReporter.aggregate(
                Aggregation.stepsTotal,
                _today,
                group: TimeGroup(unit: TimeGroupUnit.hourly),
              );
              return hours
                  .where((e) => e.value != null)
                  .map(
                    (e) =>
                        '${DateTime.fromMillisecondsSinceEpoch(e.startTimestamp).hour}h: ${e.value} ${e.unit}',
                  )
                  .join('\n');
            },
          ),
          for (final aggregation in Aggregation.values)
            DemoRow(
              'aggregate ${aggregation.value}',
              'The last 7 days, by day',
              run: () async {
                final days = await SamsungHealthReporter.aggregate(
                  aggregation,
                  _lastWeek,
                  group: TimeGroup(unit: TimeGroupUnit.daily),
                );
                return days
                    .map((e) => '${e.value ?? '-'} ${e.unit}')
                    .join('\n');
              },
            ),
        ],
        icon: Icons.functions_rounded),
    DemoSection(
      'Writer',
      [
        DemoRow(
          'insert',
          'One sample of every writable type',
          run: () async {
            final inserted = await SamsungHealthReporter.insert(
              _writable.map((type) => _sample(type, _now)).toList(),
            );
            for (final sample in inserted) {
              _inserted[sample.healthType] = sample;
            }
            return '${inserted.length} samples inserted';
          },
        ),
        for (final type in _writable)
          DemoRow(
            'insert ${type.identifier}',
            'One sample',
            run: () async {
              final inserted = await SamsungHealthReporter.insert([
                _sample(type, _now),
              ]);
              _inserted[type] = inserted.single;
              return _json(inserted.single.map);
            },
          ),
        DemoRow(
          'update',
          'The inserted heart rate to 99 bpm',
          run: () async {
            final heartRate = _inserted[HealthType.heartRate];
            if (heartRate is! HeartRate) return 'Insert a heart rate first';
            final updated = HeartRate(
              startTimestamp: heartRate.startTimestamp,
              endTimestamp: heartRate.endTimestamp,
              clientDataId: heartRate.clientDataId,
              harmonized: const HeartRateHarmonized(heartRate: 99),
            );
            await SamsungHealthReporter.update([updated]);
            _inserted[HealthType.heartRate] = updated;
            return 'Updated';
          },
        ),
        DemoRow(
          'deleteByClientDataIds',
          'The inserted water intake',
          run: () async {
            final id = _inserted.remove(HealthType.waterIntake)?.clientDataId;
            if (id == null) return 'Insert a water intake first';
            return '${await SamsungHealthReporter.deleteByClientDataIds(HealthType.waterIntake, [
                  id
                ])}';
          },
        ),
        DemoRow(
          'deleteByUids',
          "Today's heart rate this app wrote, read back for its uid",
          run: () async {
            final mine = await SamsungHealthReporter.read(
              HealthType.heartRate,
              _today,
              source: SourceFilter.app(
                'com.kvs.samsung_health_reporter_example',
              ),
            );
            final uids = mine.map((e) => e.uid).whereType<String>().toList();
            if (uids.isEmpty) return 'Nothing to delete';
            await SamsungHealthReporter.deleteByUids(
              HealthType.heartRate,
              uids,
            );
            return '${uids.length} deleted';
          },
        ),
        DemoRow(
          'delete',
          'Every sample the writer rows inserted',
          run: () async {
            final samples = _inserted.values.toList();
            for (final sample in samples) {
              await SamsungHealthReporter.delete(sample);
            }
            _inserted.clear();
            return '${samples.length} deleted';
          },
        ),
      ],
      icon: Icons.edit_note_rounded,
      footer: 'Samples carry a random client data id, so they can be '
          'updated and deleted without reading them back',
    ),
    DemoSection(
        'Observer',
        [
          for (final type in _observable)
            DemoRow(
              'changes ${type.identifier}',
              'Changes of the last 24 hours',
              run: () async {
                final changes = await SamsungHealthReporter.changes(
                  type,
                  _now - const Duration(days: 1).inMilliseconds,
                );
                return '${changes.upserted.length} upserted, '
                    '${changes.deletedUids.length} deleted';
              },
            ),
          DemoRow(
            'observe',
            'Heart rate changes, polled every 10 s',
            listen: (report) => SamsungHealthReporter.observe(
              HealthType.heartRate,
              _now,
              interval: const Duration(seconds: 10),
              onUpdate: (changes) => report(
                '${changes.upserted.length} upserted, ${changes.deletedUids.length} deleted',
              ),
              onError: (error) => report('$error'),
            ),
          ),
        ],
        icon: Icons.visibility_rounded),
  ];

  /// One plausible sample of a writable [type] ending at [now]
  static WritableSample _sample(HealthType type, int now) {
    final start = now - const Duration(minutes: 30).inMilliseconds;
    switch (type) {
      case HealthType.heartRate:
        return HeartRate(
          startTimestamp: now - 60000,
          endTimestamp: now,
          harmonized: const HeartRateHarmonized(
            heartRate: 72,
            min: 65,
            max: 80,
          ),
        );
      case HealthType.bloodOxygen:
        return BloodOxygen(
          startTimestamp: now - 60000,
          endTimestamp: now,
          harmonized: const BloodOxygenHarmonized(oxygenSaturation: 98),
        );
      case HealthType.bloodPressure:
        return BloodPressure(
          startTimestamp: now,
          harmonized: const BloodPressureHarmonized(
            systolic: 120,
            diastolic: 80,
            mean: 93,
          ),
        );
      case HealthType.bloodGlucose:
        // Samsung Health rejects a blood glucose without an end time
        return BloodGlucose(
          startTimestamp: now - 60000,
          endTimestamp: now,
          harmonized: const BloodGlucoseHarmonized(
            glucoseLevel: 5.4,
            mealStatus: MealStatus.fasting,
            measurementType: GlucoseMeasurementType.wholeBlood,
          ),
        );
      case HealthType.bodyComposition:
        return BodyComposition(
          startTimestamp: now,
          harmonized: const BodyCompositionHarmonized(weight: 70, height: 175),
        );
      case HealthType.bodyTemperature:
        return BodyTemperature(
          startTimestamp: now,
          harmonized: const BodyTemperatureHarmonized(temperature: 36.6),
        );
      case HealthType.exercise:
        return Exercise(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: ExerciseHarmonized(
            exerciseType: ExerciseType.running,
            sessions: [
              ExerciseSession(
                exerciseType: ExerciseType.running,
                startTimestamp: start,
                endTimestamp: now,
                durationMillis: now - start,
                calories: 300,
                distance: 5000,
              ),
            ],
          ),
        );
      case HealthType.floorsClimbed:
        return FloorsClimbed(
          startTimestamp: now - 60000,
          endTimestamp: now,
          harmonized: const FloorsClimbedHarmonized(floor: 3),
        );
      case HealthType.sleep:
        final night = now - const Duration(hours: 8).inMilliseconds;
        return Sleep(
          startTimestamp: night,
          endTimestamp: now,
          harmonized: SleepHarmonized(
            durationMillis: now - night,
            sessions: [
              SleepSession(
                startTimestamp: night,
                endTimestamp: now,
                durationMillis: now - night,
                stages: [
                  SleepStage(
                    startTimestamp: night,
                    endTimestamp: now,
                    stage: SleepStageType.light,
                  ),
                ],
              ),
            ],
          ),
        );
      case HealthType.nutrition:
        return Nutrition(
          startTimestamp: now,
          harmonized: const NutritionHarmonized(
            title: 'Apple',
            mealType: MealType.morningSnack,
            calories: 95,
          ),
        );
      case HealthType.waterIntake:
        return WaterIntake(
          startTimestamp: now,
          harmonized: const WaterIntakeHarmonized(amount: 250),
        );
      case HealthType.steps:
      case HealthType.stepsGoal:
      case HealthType.activitySummary:
      case HealthType.activeCaloriesBurnedGoal:
      case HealthType.activeTimeGoal:
      case HealthType.skinTemperature:
      case HealthType.exerciseLocation:
      case HealthType.sleepGoal:
      case HealthType.nutritionGoal:
      case HealthType.waterIntakeGoal:
      case HealthType.energyScore:
      case HealthType.userProfile:
      case HealthType.irregularHeartRhythmNotification:
      case HealthType.sleepApnea:
        throw ArgumentError('${type.identifier} is not writable');
    }
  }
}
