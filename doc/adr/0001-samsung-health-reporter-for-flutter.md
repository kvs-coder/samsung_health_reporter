# 1. A Flutter plugin of its own for Samsung Health

Date: 10.10.2026

## Status

Accepted. Ships with 1.0.0.

## Context

Flutter apps on Android need Samsung Health, which the Kotlin library [SamsungHealthReporter](https://github.com/kvs-coder/SamsungHealthReporter) 1.0.0 wraps over the Samsung Health Data SDK. Adding it to [health_kit_reporter](https://github.com/kvs-coder/health_kit_reporter) was built and weighed: it would have broken every import of that package (4.0.0), forced a second native toolchain and Samsung's setup on its iOS users, and named an Android provider after HealthKit. A merged, platform-neutral layer was dropped too: every further provider shrinks the shared types, and the shared ones still differ in units, identity and change delivery. This package existed on pub.dev as `0.0.1+1` (2020, the old Samsung Health SDK, never finished).

## Decision

- `samsung_health_reporter` is rebuilt in its own repository as an Android-only plugin, `SamsungHealthReporter`, mirroring the library 1:1: its methods, types, JSON (epoch milliseconds, enums by Kotlin name) and errors (`PlatformException` coded with the method name, the library's message, the error kind as `details`).
- The Kotlin dispatcher talks to the library through the `SamsungHealth` interface, since the library's services need the SDK on the classpath, which unit tests can't have.
- `observe` opens one event channel per subscription, like health_kit_reporter's live queries.
- The plugin depends on SamsungHealthReporter from JitPack; the app adds the SDK AAR, Gson and parcelize, since Samsung's license forbids redistributing the SDK.
- On any other platform `isAvailable` returns false and every other method throws an `UnsupportedError`.
- The repository mirrors health_kit_reporter's conventions: static API tested through mocked channels, BLoC example on plain streams, release-please and pub.dev publishing through OIDC.

## Consequences

- Apps that support Apple Health and Samsung Health depend on both packages and map the data they need themselves.
- The rewrite breaks the 2020 API (`0.0.1+1`): the first release is 1.0.0.
- Writes and publishing an app need Samsung partner approval; reading works in Samsung Health's developer mode.
