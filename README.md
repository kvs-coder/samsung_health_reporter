# samsung_health_reporter

A Flutter plugin for **Samsung Health on Android**, wrapping the Kotlin library [SamsungHealthReporter](https://github.com/kvs-coder/SamsungHealthReporter) (Samsung Health Data SDK).

- **Android only**: on any other platform `isAvailable` returns `false` and every other method throws an `UnsupportedError`. For Apple Health on iOS use [health_kit_reporter](https://pub.dev/packages/health_kit_reporter).
- Reads, aggregates, writes and observes Samsung Health data: a manager, a reader, a writer and an observer, like the library.
- The library's methods are wrapped in the Method and Event channels of a **FlutterPlugin**; every payload arrives as the library's JSON and is parsed into Dart models.

## Getting Started

```yaml
dependencies:
  samsung_health_reporter: ^0.0.1 # x-release-please-version
```

`SamsungHealthReporter` mirrors the Kotlin library [SamsungHealthReporter](https://github.com/kvs-coder/SamsungHealthReporter): a manager, a reader with aggregates, a writer and an observer over the [Samsung Health Data SDK](https://developer.samsung.com/health/data/overview.html). Timestamps are epoch milliseconds, as in the library; models live in `model/`.

## Requirements

Android 10 (API 29) or later, Samsung Health 6.30.2 or later on a phone (not an emulator), Samsung Health Data SDK 1.1.0 or later, Java 17.

## Setup

1. Download the **Samsung Health Data SDK** from the [Samsung Developer site](https://developer.samsung.com/health/data/overview.html#SDK-download). Samsung's license doesn't allow redistributing it, so the plugin can't ship it: put `samsung-health-data-api.aar` into `android/app/libs/` (and keep it out of public repositories).
2. Add the JitPack repository, which serves SamsungHealthReporter, to `android/build.gradle.kts`:

```kotlin
allprojects {
    repositories {
        google()
        mavenCentral()
        maven("https://jitpack.io")
    }
}
```

3. Add the SDK and what it needs at runtime to `android/app/build.gradle.kts`, and raise `minSdk` to 29:

```kotlin
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.plugin.parcelize")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    defaultConfig {
        minSdk = 29
    }
}

dependencies {
    implementation(fileTree("libs") { include("samsung-health-data-api*.aar") })
    implementation("com.google.code.gson:gson:2.13.2")
}
```

   Declare the parcelize plugin in `android/settings.gradle.kts` with your Kotlin version: `id("org.jetbrains.kotlin.plugin.parcelize") version "2.4.0" apply false`.

4. To test, turn on [developer mode](https://developer.samsung.com/health/data/guide/developer-mode.html) in Samsung Health (**⋮** › **Settings** › **About Samsung Health**, tap the version about 10 times, turn on **Developer Mode for Data Read**). Reading works in developer mode; **writing, and distributing your app, need Samsung partner approval**. Until then every write permission request fails with `NotAuthorized`, so request read and write permissions separately.

## Usage

```dart
import 'package:samsung_health_reporter/samsung_health_reporter.dart';
import 'package:samsung_health_reporter/model/aggregate.dart';
import 'package:samsung_health_reporter/model/time_group.dart';
import 'package:samsung_health_reporter/model/time_range.dart';
import 'package:samsung_health_reporter/model/payload/heart_rate.dart';
import 'package:samsung_health_reporter/model/type/aggregation.dart';
import 'package:samsung_health_reporter/model/type/health_type.dart';
import 'package:samsung_health_reporter/model/type/time_group_unit.dart';

if (!await SamsungHealthReporter.isAvailable()) return; // not installed, or not Android

try {
  final granted = await SamsungHealthReporter.requestPermissions(
      read: [HealthType.heartRate, HealthType.steps, HealthType.sleep]);

  final now = DateTime.now();
  final lastWeek = TimeRange.fromDates(now.subtract(const Duration(days: 7)), now);

  final heartRates = await SamsungHealthReporter.read(HealthType.heartRate, lastWeek);
  for (final sample in heartRates.whereType<HeartRate>()) {
    print('${sample.harmonized.heartRate} bpm');
  }

  // Steps and the activity summary are only available as aggregates
  final List<Aggregate> stepsPerDay = await SamsungHealthReporter.aggregate(
      Aggregation.stepsTotal, lastWeek,
      group: const TimeGroup(TimeGroupUnit.daily));
} on PlatformException catch (error) {
  if (error.details == 'Resolvable') {
    await SamsungHealthReporter.resolve(); // install, update or set up Samsung Health
  }
}
```

| Area | Methods |
| :--- | :--- |
| Manager | `isAvailable`, `requestPermissions`, `grantedPermissions`, `isAuthorized`, `resolve`, `localDevice`, `devices`, `device` |
| Reader | `read`, `readPage`, `userProfile`, `aggregate` |
| Writer | `insert`, `update`, `delete`, `deleteByUids`, `deleteByClientDataIds` |
| Observer | `changes`, `observe` |

Writing, with a client data id to update or delete the sample later without reading it back:

```dart
final now = DateTime.now().millisecondsSinceEpoch;
final inserted = await SamsungHealthReporter.insert([
  HeartRate(
      startTimestamp: now - 60000,
      endTimestamp: now,
      harmonized: const HeartRateHarmonized(heartRate: 72)),
]);
await SamsungHealthReporter.delete(inserted.first);
```

Observing: `changes` reads the changes since a time you persist (`ChangeSet.until`); `observe` polls them while subscribed, on an event channel of its own:

```dart
final subscription = SamsungHealthReporter.observe(
    HealthType.heartRate, DateTime.now().millisecondsSinceEpoch,
    interval: const Duration(seconds: 30),
    onUpdate: (changeSet) => print(changeSet.upserted),
    onError: (error) => print(error));
// later
await subscription.cancel();
```

Errors are `PlatformException`s whose `code` is the method name, `message` the library's message and `details` the error kind: `NotAuthorized`, `InvalidType`, `InvalidValue`, `Resolvable` (pass it to `resolve`) or `Platform` (with the SDK error code when known, e.g. `Platform(2003)`).


## Example

`example/` lists every method of the plugin, grouped by area, with search and section filters. Tap a row to run it; its result, live updates or error appear below it. Put the Samsung Health Data SDK AAR into `example/android/app/libs/` and run it on a phone with Samsung Health (in developer mode for reading):

```shell
cd example && flutter run
```

`example/integration_test/catalog_test.dart` runs every row on a connected phone; grant the read permissions once from the app's `requestPermissions` row first.

## Releasing

Releases are automated by [release-please](https://github.com/googleapis/release-please): Conventional Commits on `master` keep a release PR open, and merging it tags `vX.Y.Z` and publishes to pub.dev through GitHub's OIDC token.

## License
Under <a href=https://github.com/kvs-coder/samsung_health_reporter/blob/master/LICENSE>MIT License</a>

## Sponsorship
If you think that my repo helped you to solve the issues you struggle with, please don't be shy and sponsor :-)
