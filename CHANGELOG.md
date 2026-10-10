# Changelog

## [1.0.0] - 10.10.2026


### BREAKING CHANGES

* the plugin is rebuilt from scratch on the Samsung Health Data SDK and supports Android 10+ only. Every Dart API, model and channel name changed; migrate to SamsungHealthReporter's static methods and models, add the Samsung Health Data SDK AAR to the app's libs and the JitPack repository to android/build.gradle.kts (see README.md).

### Features

* rebuild on the Samsung Health Data SDK ([2173e4b](https://github.com/kvs-coder/samsung_health_reporter/commit/2173e4b8120666ba9c57a50007938d286a4d9ae8))


### Fixes

* drop the build number so release-please proposes 1.0.0 ([f2c7f89](https://github.com/kvs-coder/samsung_health_reporter/commit/f2c7f890c1da1de376f74eaab491584e699f7703))

## [0.0.1] - 20.11.2020

* Package initial.
