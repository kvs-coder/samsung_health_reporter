# Contributing

When contributing to this repository, please first discuss the change you wish to make via issue,
email, or any other method with the owners of this repository before making a change.

Please note we have a code of conduct, please follow it in all your interactions with the project.

## Pull Request Process

1. Follow [AGENTS.md](AGENTS.md): tests first, the plugin mirrors SamsungHealthReporter's API and JSON.
2. Run the quality gates: `flutter analyze`, `flutter test --coverage`, the example build, the Kotlin unit tests and ktlint.
3. Write Conventional Commits; release-please derives the version and the changelog, so don't bump versions by hand.
4. Update the README.md with details of changes to the interface.

## Dart

We use https://dart.dev/guides/language/effective-dart to provide a good quality and easy readable code.

## Kotlin

ktlint 1.8.0 with the official Kotlin coding conventions (`android/.editorconfig`).
