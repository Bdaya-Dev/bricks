import 'dart:io';
import 'package:bdaya_new_flutter_app/src/consts.dart';
import 'package:path/path.dart' as p;
import 'package:mason/mason.dart';
import 'package:bdaya_new_flutter_app/bdaya_new_flutter_app_hooks.dart';
import 'package:yaml_edit/yaml_edit.dart';

/// Main hook entry point for creating a new Flutter app
Future<void> run(HookContext context) async {
  final logger = context.logger;
  final configuration =
      BdayaNewFlutterAppConfiguration.fromHookVars(context.vars);
  final projectDir = Directory(configuration.projectName.snakeCase);
  final templateDirectory = _getTemplateDirectory();

  logger.info('Creating Flutter app: ${configuration.projectName}');

  try {
    await _ensureVeryGoodCli(logger);
    await _cleanupInitialFiles(projectDir, logger);
    await _createFlutterApp(configuration, projectDir.path, logger);
    await _setupProject(configuration, projectDir, templateDirectory, logger);
    await _bootstrap(projectDir.path, configuration.projectName, logger);

    logger.success('''
✅ Project created successfully!
   Run "cd ${configuration.projectName.snakeCase}" to enter the directory.
   Run "code ." to open in VSCode.
''');
  } catch (e, stackTrace) {
    logger.err('Project creation failed: $e');
    logger.detail(stackTrace.toString());
    rethrow;
  }
}

/// Gets the template directory path
Directory _getTemplateDirectory() {
  final scriptPath = Platform.script.toFilePath();
  final templatePath = scriptPath.split('/build/hooks')[0] + '/template/';
  return Directory(templatePath);
}

/// Ensures very_good_cli is installed
Future<void> _ensureVeryGoodCli(Logger logger) async {
  if (!await _isVeryGoodInstalled(logger)) {
    await _installVeryGoodCli(logger);
  }
}

/// Checks if very_good_cli is installed
Future<bool> _isVeryGoodInstalled(Logger logger) async {
  final progress = logger.progress('Checking very_good_cli installation');

  try {
    final result = await Process.run('very_good', ['--version']);

    if (result.exitCode == 0) {
      progress.complete('very_good_cli is already installed');
      logger.info('Version: ${result.stdout.trim()}');
      return true;
    }

    progress.update('very_good_cli not found');
    return false;
  } catch (e) {
    progress.update('very_good_cli not accessible');
    return false;
  } finally {
    progress.cancel();
  }
}

/// Installs very_good_cli globally
Future<void> _installVeryGoodCli(Logger logger) async {
  final progress = logger.progress('Installing very_good_cli');

  try {
    final result = await Process.run(
        'dart', ['pub', 'global', 'activate', 'very_good_cli']);

    if (result.exitCode == 0) {
      progress.complete('Successfully installed very_good_cli');
    } else {
      throw ProcessException(
        'dart',
        ['pub', 'global', 'activate', 'very_good_cli'],
        'Installation failed: ${result.stderr}',
        result.exitCode,
      );
    }
  } catch (e) {
    progress.fail('Error installing very_good_cli: $e');
    rethrow;
  }
}

/// Cleans up initial files that shouldn't be in the project
Future<void> _cleanupInitialFiles(Directory projectDir, Logger logger) async {
  await _removeFileIfExists(p.join(projectDir.path, 'blank.md'), logger);
}

/// Sets up the project with configuration and templates
Future<void> _setupProject(
  BdayaNewFlutterAppConfiguration configuration,
  Directory projectDir,
  Directory templateDirectory,
  Logger logger,
) async {
  await _updatePubspec(configuration, projectDir.path, logger);
  await _updateAnalysisOptions(configuration, projectDir.path, logger);
  await _addDependencies(configuration, projectDir.path, logger);
  await _cleanupUnwantedFiles(projectDir.path, logger);
  await _setupTemplateFiles(projectDir.path, templateDirectory.path, logger);
  await _updateTestFiles(configuration, projectDir.path);
}

Future<void> _updateAnalysisOptions(
    BdayaNewFlutterAppConfiguration configuration,
    String projectPath,
    Logger logger) async {
  final progress = logger.progress(
      'Updating analysis_options.yaml for ${configuration.projectName}');
  final analysisOptionsFile =
      File(p.join(projectPath, 'analysis_options.yaml'));

  try {
    if (!await analysisOptionsFile.exists()) {
      throw FileSystemException('analysis_options.yaml not found', projectPath);
    }

    final content = await analysisOptionsFile.readAsString();
    final editor = YamlEditor(content);

    editor.update(['include'], r'package:flutter_lints/flutter.yaml');
    editor.remove(['analyzer']);
    editor.remove(['linter']);
    await analysisOptionsFile.writeAsString(editor.toString());
    progress.complete('Updated analysis_options.yaml');
  } catch (e) {
    progress.fail('Failed to update analysis_options.yaml: $e');
    rethrow;
  }
}

/// Adds both regular and dev dependencies
Future<void> _addDependencies(
  BdayaNewFlutterAppConfiguration configuration,
  String projectPath,
  Logger logger,
) async {
  await _addPackages(configuration, projectPath, logger, kDep, isDev: false);
  await _addPackages(configuration, projectPath, logger, kDevDep, isDev: true);
}

/// Sets up template files and directories
Future<void> _setupTemplateFiles(
  String projectPath,
  String templatePath,
  Logger logger,
) async {
  await _replaceAppView(projectPath, templatePath);
  await _copyTemplateAssets(projectPath, templatePath);
  await _copyProjectFiles(projectPath, templatePath, logger, kFiles, kDirs);
  await _setupLocalizationStructure(projectPath, templatePath, logger);
}

/// Copies template assets like l10n configuration
Future<void> _copyTemplateAssets(
    String projectPath, String templatePath) async {
  final assetsToSync = [
    ('l10n.yaml', 'l10n.yaml'),
    ('l10n_errors.txt', 'l10n_errors.txt'),
  ];

  for (final (source, dest) in assetsToSync) {
    final sourceFile = File(p.join(templatePath, source));
    final destFile = File(p.join(projectPath, dest));

    // Only copy if source exists
    if (await sourceFile.exists()) {
      await _copyFile(sourceFile.path, destFile.path);
    }
  }
}

/// Sets up the localization directory structure
Future<void> _setupLocalizationStructure(
    String projectPath, String templatePath, Logger logger) async {
  final l10nDir = Directory(p.join(projectPath, 'lib', 'l10n'));

  // Ensure l10n directory exists
  if (!await l10nDir.exists()) {
    await l10nDir.create(recursive: true);
    logger.info('Created lib/l10n directory');
  }

  // Copy any .arb files from template if they exist
  final templateL10nDir = Directory(p.join(templatePath, 'lib', 'l10n'));
  if (await templateL10nDir.exists()) {
    await for (final entity in templateL10nDir.list()) {
      if (entity is File && entity.path.endsWith('.arb')) {
        final filename = p.basename(entity.path);
        await _copyFile(
          entity.path,
          p.join(l10nDir.path, filename),
        );
      }
    }
  } else {
    // Create a basic app_en.arb file if template doesn't have one
    await _createBasicArbFile(l10nDir.path);
  }
}

/// Creates a basic ARB file for localization
Future<void> _createBasicArbFile(String l10nPath) async {
  final arbFile = File(p.join(l10nPath, 'app_en.arb'));
  const basicArbContent = '''
{
  "@@locale": "en",
  "appTitle": "Flutter App",
  "@appTitle": {
    "description": "The title of the application"
  }
}
''';

  await arbFile.writeAsString(basicArbContent);
}

/// Removes unwanted folders and files
Future<void> _cleanupUnwantedFiles(String projectPath, Logger logger) async {
  // Only remove the counter folder, keep lib/l10n for now
  final foldersToRemove = ['lib/counter', 'lib/l10n', 'test/counter'];
  final filesToRemove = [
    p.join('lib', 'bootstrap.dart'),
  ];

  await _removeFolders(projectPath, logger, foldersToRemove);

  for (final file in filesToRemove) {
    await _removeFileIfExists(p.join(projectPath, file), logger);
  }
}

/// Updates test files to work with new structure
Future<void> _updateTestFiles(
  BdayaNewFlutterAppConfiguration configuration,
  String projectPath,
) async {
  await _replaceInFile(
    filePath: p.join(projectPath, 'test/app/view/app_test.dart'),
    removeLines: [
      "expect(find.byType(CounterPage), findsOneWidget);",
      "import 'package:${configuration.projectName.snakeCase}/counter/counter.dart';",
    ],
  );

  await _replaceInFile(
    filePath: p.join(projectPath, 'test/helpers/pump_app.dart'),
    replacements: {
      "import 'package:${configuration.projectName.snakeCase}/l10n/l10n.dart';":
          "import 'package:${configuration.projectName.snakeCase}/gen/l10n/app_localizations.dart';",
    },
  );
}

/// Creates Flutter app using very_good_cli
Future<void> _createFlutterApp(
  BdayaNewFlutterAppConfiguration configuration,
  String workingDirectory,
  Logger logger,
) async {
  final progress = logger
      .progress('Creating ${configuration.projectName} using very_good_cli');

  try {
    final result = await Process.run(
      'very_good',
      [
        'create',
        'flutter_app',
        '.',
        '--description',
        configuration.description,
        '--org-name',
        configuration.organizationName,
        '--application-id',
        configuration.androidApplicationId.value,
      ],
      workingDirectory: workingDirectory,
    );

    if (result.exitCode != 0) {
      throw ProcessException(
        'very_good',
        ['create', 'flutter_app'],
        'Flutter app creation failed:\n${result.stderr}',
        result.exitCode,
      );
    }

    progress.complete('Successfully created Flutter app');
    logger.detail(result.stdout);
  } catch (e) {
    progress.fail('Error creating Flutter app: $e');
    rethrow;
  }
}

/// Updates pubspec.yaml with required configuration
Future<void> _updatePubspec(
  BdayaNewFlutterAppConfiguration configuration,
  String projectPath,
  Logger logger,
) async {
  final progress =
      logger.progress('Updating pubspec.yaml for ${configuration.projectName}');
  final pubspecFile = File(p.join(projectPath, 'pubspec.yaml'));

  try {
    if (!await pubspecFile.exists()) {
      throw FileSystemException('pubspec.yaml not found', projectPath);
    }

    final pubspecContent = await pubspecFile.readAsString();
    final editor = YamlEditor(pubspecContent);

    _updatePubspecSections(editor);

    await pubspecFile.writeAsString(editor.toString());
    progress.complete('Updated pubspec.yaml');
  } catch (e) {
    progress.fail('Failed to update pubspec.yaml: $e');
    rethrow;
  }
}

/// Updates individual sections of pubspec.yaml
void _updatePubspecSections(YamlEditor editor) {
  // Helper to ensure section exists
  void ensureSection(String key) {
    try {
      editor.parseAt([key]);
    } catch (_) {
      editor.update([key], {});
    }
  }

  // Update environment
  ensureSection('environment');
  editor.update(['environment', 'sdk'], kSdk);
  editor.update(['environment', 'flutter'], kFlutter);

  // Update dependencies
  ensureSection('dependencies');
  editor.update(['dependencies', 'flutter'], {'sdk': 'flutter'});
  editor.update(['dependencies', 'flutter_localizations'], {'sdk': 'flutter'});
  editor.update(['dependencies', 'intl'], 'any');

  // Remove unwanted dependencies
  final depsToRemove = ['bloc', 'flutter_bloc'];
  for (final dep in depsToRemove) {
    try {
      editor.remove(['dependencies', dep]);
    } catch (_) {
      // Ignore if dependency doesn't exist
    }
  }

  // Update dev dependencies
  ensureSection('dev_dependencies');
  editor.update(['dev_dependencies', 'flutter_test'], {'sdk': 'flutter'});
  editor.update(['dev_dependencies', 'integration_test'], {'sdk': 'flutter'});

  // Remove unwanted dev dependencies
  final devDepsToRemove = ['bloc_test', 'very_good_analysis', 'mocktail'];
  for (final dep in devDepsToRemove) {
    try {
      editor.remove(['dev_dependencies', dep]);
    } catch (_) {
      // Ignore if dependency doesn't exist
    }
  }
}

/// Adds packages to pubspec.yaml
Future<void> _addPackages(
  BdayaNewFlutterAppConfiguration configuration,
  String projectPath,
  Logger logger,
  List<String> packages, {
  required bool isDev,
}) async {
  if (packages.isEmpty) return;

  final progress = logger.progress(
      'Adding ${isDev ? 'dev ' : ''}dependencies: ${packages.join(', ')}');

  try {
    final result = await Process.run(
      'dart',
      [
        'pub',
        'add',
        if (isDev) '--dev',
        ...packages,
      ],
      workingDirectory: projectPath,
    );

    if (result.exitCode == 0) {
      progress
          .complete('Successfully added ${isDev ? 'dev ' : ''}dependencies');
    } else {
      throw ProcessException(
        'dart',
        ['pub', 'add'],
        'Failed to add packages: ${result.stderr}',
        result.exitCode,
      );
    }
  } catch (e) {
    progress.fail('Error adding packages: $e');
    rethrow;
  }
}

/// Replaces app view with template version
Future<void> _replaceAppView(String projectPath, String templatePath) async {
  final source = File(p.join(templatePath, 'lib', 'app', 'view', 'app.dart'));
  final destination =
      File(p.join(projectPath, 'lib', 'app', 'view', 'app.dart'));

  if (!await source.exists()) {
    throw FileSystemException('Template app.dart not found', source.path);
  }

  try {
    await destination.parent.create(recursive: true);
    await source.copy(destination.path);
  } catch (e) {
    throw FileSystemException(
        'Failed to replace app view: $e', destination.path);
  }
}

/// Copies project files from template
Future<void> _copyProjectFiles(
  String projectPath,
  String templatePath,
  Logger logger,
  List<String> fileNames,
  List<String> dirNames,
) async {
  final progress = logger.progress('Copying template files');

  try {
    // Copy individual files
    for (final fileName in fileNames) {
      await _copyFile(
        p.join(templatePath, 'lib', fileName),
        p.join(projectPath, 'lib', fileName),
      );
    }

    // Copy directories
    for (final dirName in dirNames) {
      await _copyDirectory(
        Directory(p.join(templatePath, 'lib', dirName)),
        Directory(p.join(projectPath, 'lib', dirName)),
      );
    }

    progress.complete('Copied template files');
  } catch (e) {
    progress.fail('Failed to copy template files: $e');
    rethrow;
  }
}

/// Recursively copies a directory
Future<void> _copyDirectory(Directory source, Directory destination) async {
  if (!await source.exists()) {
    throw FileSystemException('Source directory not found', source.path);
  }

  await destination.create(recursive: true);

  await for (final entity in source.list(recursive: false)) {
    final newPath = p.join(destination.path, p.basename(entity.path));

    if (entity is Directory) {
      await _copyDirectory(entity, Directory(newPath));
    } else if (entity is File) {
      await _copyFile(entity.path, newPath);
    }
  }
}

/// Copies a single file
Future<void> _copyFile(String sourcePath, String destinationPath) async {
  final sourceFile = File(sourcePath);

  if (!await sourceFile.exists()) {
    throw FileSystemException('Source file not found', sourcePath);
  }

  try {
    final destinationFile = File(destinationPath);
    await destinationFile.parent.create(recursive: true);
    await sourceFile.copy(destinationPath);
  } catch (e) {
    throw FileSystemException('Failed to copy file: $e', destinationPath);
  }
}

/// Removes multiple folders
Future<void> _removeFolders(
    String projectPath, Logger logger, List<String> folders) async {
  for (final folder in folders) {
    await _deleteFolder(p.join(projectPath, folder), logger);
  }
}

/// Deletes a folder recursively
Future<void> _deleteFolder(String folderPath, Logger logger) async {
  final directory = Directory(folderPath);

  if (!await directory.exists()) {
    return; // Already doesn't exist
  }

  try {
    await directory.delete(recursive: true);
    logger.info('Deleted folder: $folderPath');
  } catch (e) {
    logger.err('Failed to delete folder $folderPath: $e');
    rethrow;
  }
}

/// Removes a file if it exists
Future<void> _removeFileIfExists(String filePath, Logger logger) async {
  final file = File(filePath);

  if (await file.exists()) {
    try {
      await file.delete();
      logger.info('Removed file: $filePath');
    } catch (e) {
      logger.err('Failed to remove file $filePath: $e');
      rethrow;
    }
  }
}

/// Replaces content in a file
Future<void> _replaceInFile({
  required String filePath,
  Map<String, String> replacements = const {},
  List<String> removeLines = const [],
}) async {
  final file = File(filePath);

  if (!await file.exists()) {
    throw FileSystemException('File not found for replacement', filePath);
  }

  try {
    String content = await file.readAsString();

    // Apply replacements
    for (final MapEntry(:key, :value) in replacements.entries) {
      content = content.replaceAll(key, value);
    }

    // Remove specific lines
    if (removeLines.isNotEmpty) {
      final lines = content.split('\n');
      final filteredLines = lines.where((line) {
        return !removeLines.any((pattern) => line.contains(pattern));
      }).toList();
      content = filteredLines.join('\n');
    }

    await file.writeAsString(content);
  } catch (e) {
    throw FileSystemException('Failed to update file: $e', filePath);
  }
}

/// Bootstraps the project by running necessary commands
Future<void> _bootstrap(
    String projectPath, String projectName, Logger logger) async {
  final commands = [
    _BootstrapCommand(
      executable: 'flutter',
      args: ['pub', 'get'],
      label: 'Getting dependencies',
    ),
    _BootstrapCommand(
      executable: 'flutter',
      args: ['gen-l10n'],
      label: 'Generating l10n',
    ),
    _BootstrapCommand(
      executable: 'dart',
      args: ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      label: 'Running build_runner',
    ),
  ];

  for (final command in commands) {
    final progress = logger.progress(command.label);

    try {
      final result = await Process.run(
        command.executable,
        command.args,
        workingDirectory: projectPath,
      );

      if (result.exitCode == 0) {
        progress.complete('${command.label} completed');
      } else {
        throw ProcessException(
          command.executable,
          command.args,
          '${command.label} failed: ${result.stderr}',
          result.exitCode,
        );
      }
    } catch (e) {
      progress.fail('${command.label} failed: $e');
      rethrow;
    }
  }
}

/// Helper class for bootstrap commands
class _BootstrapCommand {
  const _BootstrapCommand({
    required this.executable,
    required this.args,
    required this.label,
  });

  final String executable;
  final List<String> args;
  final String label;
}

/// Custom exception for process failures
class ProcessException implements Exception {
  const ProcessException(
      this.executable, this.arguments, this.message, this.exitCode);

  final String executable;
  final List<String> arguments;
  final String message;
  final int exitCode;

  @override
  String toString() =>
      'ProcessException: $executable ${arguments.join(' ')}\n$message (exit code: $exitCode)';
}
