# Bdaya New Flutter App

Inspired from [very_good_core][very_good_core_link] 🦄.

Developed with 💙 by [Bdaya Development][bdaya_development_link].

[![License: MIT][license_badge]][license_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

A Bdaya New Flutter App created by [Bdaya Development][bdaya_development_link].

## What's Included ✨

Out of the box, Bdaya New Flutter App includes:

- ✅ [Cross Platform Support][flutter_cross_platform_link] - Built-in support for iOS, Android, Web, and Windows (MacOS/Linux coming soon!)
- ✅ [Build Flavors][flutter_flavors_link] - Multiple flavor support for development, staging, and production
- ✅ [Internationalization Support][internationalization_link] - Internationalization support using synthetic code generation to streamline the development process
- ✅ [Sound Null-Safety][null_safety_link] - No more null-dereference exceptions at runtime. Develop with a sound, static type system.
- ✅ [bdaya_flutter_common][bdaya_flutter_common] - A library to combine and standarize the common code we use in our projects into a single package.
- ✅ [get_it][get_it_link] - Integrated get_it architecture for scalable, testable code which offers a simple Service Locator for bdaya app services,and controllers.
- ✅ [bdaya_shared_value][bdaya_shared_value_link] - An opinionated fork of the original package [shared_value][shared_value_link] that is a wrapper over [InheritedModel][InheritedModel_link] , this module allows you to easily manage global state in flutter apps. At a high level, SharedValue puts your variables in an intelligent "container" that is flutter-aware. It can be viewed as a low-boilerplate generalization of the Provider state management solution.
- ✅ [Testing][testing_link] - Unit and Widget Tests with 100% line coverage (Integration Tests coming soon!)
- ✅ [Logging][logging_link] - Built-in, extensible logging to capture uncaught Flutter and Dart Exceptions

## Output 📦

```sh
├── .gitignore
├── .idea
│   └── runConfigurations
│       ├── development.xml
│       ├── production.xml
│       └── staging.xml
├── .vscode
│   ├── extensions.json
│   └── launch.json
├── LICENSE
├── README.md
├── analysis_options.yaml
├── android
├── coverage_badge.svg
├── ios
├── l10n.yaml
├── lib
│   ├── app
│   │   ├── app.dart
│   │   └── view
│   ├── bootstrap.dart
│   ├── counter
│   │   ├── counter.dart
│   │   ├── cubit
│   │   └── view
│   ├── l10n
│   │   ├── arb
│   │   └── l10n.dart
│   ├── main_development.dart
│   ├── main_production.dart
│   └── main_staging.dart
├── pubspec.lock
├── pubspec.yaml
├── test
│   ├── app
│   │   └── view
│   ├── counter
│   │   ├── cubit
│   │   └── view
│   └── helpers
│       ├── helpers.dart
│       └── pump_app.dart
├── web
└── windows
```

[bdaya_flutter_common]: https://pub.dev/packages/bdaya_flutter_common
[get_it_link]: https://pub.dev/packages/get_it
[bdaya_shared_value_link]: https://pub.dev/packages/bdaya_shared_value
[shared_value_link]: https://pub.dev/packages/shared_value
[InheritedModel_link]: https://api.flutter.dev/flutter/widgets/InheritedModel-class.html
[flutter_cross_platform_link]: https://flutter.dev/docs/development/tools/sdk/release-notes/supported-platforms
[flutter_flavors_link]: https://flutter.dev/docs/deployment/flavors
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logging_link]: https://api.flutter.dev/flutter/dart-developer/log.html
[null_safety_link]: https://flutter.dev/docs/null-safety
[testing_link]: https://flutter.dev/docs/testing
[bdaya_development_link]: https://bdaya-dev.com/
[very_good_core_link]: https://github.com/VeryGoodOpenSource/very_good_templates/tree/main/very_good_core
