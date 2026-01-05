import 'package:equatable/equatable.dart';
import 'package:bdaya_new_flutter_app/bdaya_new_flutter_app_hooks.dart';

/// The variables specified by this hook.
///
/// The variables can be found in the Brick's `brick.yaml` file. They are
/// initially included in the `HookContext.vars` map.
///
/// See also:
///
/// * [brick.yaml documentation](https://docs.brickhub.dev/brick-structure#brickyaml)
enum _BdayaNewFlutterAppConfigurationVariables {
  /// {@template bdaya_new_flutter_app_configuration_variables.project_name}
  /// The project name.
  ///
  /// Defaults to `my_app`.
  /// {@endtemplate}
  projectName._('project_name'),

  /// {@template bdaya_new_flutter_app_configuration_variables.organization_name}
  /// The organization name.
  ///
  /// Defaults to `com.example`.
  /// {@endtemplate}
  organizationName._('org_name'),

  /// {@template bdaya_new_flutter_app_configuration_variables.application_id}
  /// The application id on Android, Bundle ID on iOS and company name on
  /// Windows. If omitted value will be formed by org_name + . + project_name.
  ///
  /// Has no default specified within the `brick.yaml`.
  /// {@endtemplate}
  applicationId._('application_id'),

  /// {@template bdaya_new_flutter_app_configuration_variables.description}
  /// A short project description.
  ///
  /// Defaults to `A Bdaya App`.
  /// {@endtemplate}
  description._('description');

  const _BdayaNewFlutterAppConfigurationVariables._(this.key);

  /// The key used in the `HookContext.vars` [Map].
  ///
  /// This should match the variable key in the `brick.yaml`.
  final String key;
}

/// {@template bdaya_new_flutter_app_configuration}
/// Configuration for the `bdaya_new_flutter_app` brick.
/// {@endtemplate}
class BdayaNewFlutterAppConfiguration extends Equatable {
  /// {@macro bdaya_new_flutter_app_configuration}
  BdayaNewFlutterAppConfiguration({
    String? projectName,
    String? organizationName,
    String? description,
    WindowsApplicationId? windowsApplicationId,
    AppleApplicationId? iOsApplicationId,
    AppleApplicationId? macOsApplicationId,
    AndroidApplicationId? androidApplicationId,
    AndroidNamespace? androidNamespace,
  })  : projectName = projectName ?? 'my_app',
        organizationName = organizationName ?? 'com.example',
        description = description ?? 'A Bdaya App' {
    this.windowsApplicationId = windowsApplicationId ??
        WindowsApplicationId.fallback(
          organizationName: this.organizationName,
          projectName: this.projectName,
        );
    this.iOsApplicationId = iOsApplicationId ??
        AppleApplicationId.fallback(
          organizationName: this.organizationName,
          projectName: this.projectName,
        );
    this.macOsApplicationId = macOsApplicationId ??
        AppleApplicationId.fallback(
          organizationName: this.organizationName,
          projectName: this.projectName,
        );
    this.androidApplicationId = androidApplicationId ??
        AndroidApplicationId.fallback(
          organizationName: this.organizationName,
          projectName: this.projectName,
        );
    if (!this.androidApplicationId.isValid) {
      throw InvalidAndroidApplicationIdFormat(this.androidApplicationId);
    }

    this.androidNamespace = androidNamespace ??
        AndroidNamespace.fromApplicationId(this.androidApplicationId);
  }

  /// Deserializes a [BdayaNewFlutterAppConfiguration] from a `Map<String, dynamic>`
  /// used to represent the configuration in the `HookContext.vars` map.
  factory BdayaNewFlutterAppConfiguration.fromHookVars(
      Map<String, dynamic> vars) {
    final projectName =
        vars[_BdayaNewFlutterAppConfigurationVariables.projectName.key];
    if (projectName is! String?) {
      throw ArgumentError.value(
        vars,
        'vars',
        '''Expected a value for key "${_BdayaNewFlutterAppConfigurationVariables.projectName.key}" to be of type String?, got $projectName.''',
      );
    }

    final organizationName =
        vars[_BdayaNewFlutterAppConfigurationVariables.organizationName.key];
    if (organizationName is! String?) {
      throw ArgumentError.value(
        vars,
        'vars',
        '''Expected a value for key "${_BdayaNewFlutterAppConfigurationVariables.organizationName.key}" to be of type String?, got $organizationName.''',
      );
    }

    final applicationId =
        vars[_BdayaNewFlutterAppConfigurationVariables.applicationId.key];
    if (applicationId is! String?) {
      throw ArgumentError.value(
        vars,
        'vars',
        '''Expected a value for key "${_BdayaNewFlutterAppConfigurationVariables.applicationId.key}" to be of type String?, got $applicationId.''',
      );
    }

    final description =
        vars[_BdayaNewFlutterAppConfigurationVariables.description.key];
    if (description is! String?) {
      throw ArgumentError.value(
        vars,
        'vars',
        '''Expected a value for key "${_BdayaNewFlutterAppConfigurationVariables.description.key}" to be of type String?, got $description.''',
      );
    }

    return BdayaNewFlutterAppConfiguration(
      projectName: projectName,
      organizationName: organizationName,
      iOsApplicationId: applicationId == null || applicationId.isEmpty
          ? null
          : AppleApplicationId(applicationId),
      macOsApplicationId: applicationId == null || applicationId.isEmpty
          ? null
          : AppleApplicationId(applicationId),
      windowsApplicationId: applicationId == null || applicationId.isEmpty
          ? null
          : WindowsApplicationId(applicationId),
      androidApplicationId: applicationId == null || applicationId.isEmpty
          ? null
          : AndroidApplicationId(applicationId),
      description: description,
    );
  }

  /// {@macro bdaya_new_flutter_app_configuration_variables.project_name}
  final String projectName;

  /// {@macro bdaya_new_flutter_app_configuration_variables.organization_name}
  final String organizationName;

  /// {@macro bdaya_new_flutter_app_configuration_variables.description}
  final String description;

  /// {@macro windows_application_id}
  late final WindowsApplicationId windowsApplicationId;

  /// {@macro apple_application_id}
  late final AppleApplicationId iOsApplicationId;

  /// {@macro apple_application_id}
  late final AppleApplicationId macOsApplicationId;

  /// {@macro android_namespace}
  late final AndroidNamespace androidNamespace;

  /// {@macro android_application_id}
  late final AndroidApplicationId androidApplicationId;

  @override
  List<Object?> get props => [
        projectName,
        organizationName,
        description,
        windowsApplicationId,
        iOsApplicationId,
        macOsApplicationId,
        androidNamespace,
        androidApplicationId,
      ];
}
