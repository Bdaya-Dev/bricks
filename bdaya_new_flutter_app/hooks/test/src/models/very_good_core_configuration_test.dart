import 'package:test/test.dart';
import 'package:bdaya_new_flutter_app/bdaya_new_flutter_app_hooks.dart';

void main() {
  group('$BdayaNewFlutterAppConfiguration', () {
    group('defaults', () {
      test('project_name to "my_app"', () {
        final configuration = BdayaNewFlutterAppConfiguration();
        expect(configuration.projectName, 'my_app');
      });

      test('organization_name to "com.example"', () {
        final configuration = BdayaNewFlutterAppConfiguration();
        expect(configuration.organizationName, 'com.example');
      });

      test('description to "A Bdaya Flutter App"', () {
        final configuration = BdayaNewFlutterAppConfiguration();
        expect(configuration.description, 'A Bdaya Flutter App');
      });

      test('windowsApplicationId to "com.example.my-app"', () {
        final configuration = BdayaNewFlutterAppConfiguration();
        expect(configuration.windowsApplicationId.value, 'com.example.my-app');
      });

      test('iOsApplicationId to "com.example.my-app"', () {
        final configuration = BdayaNewFlutterAppConfiguration();
        expect(configuration.iOsApplicationId.value, 'com.example.my-app');
      });

      test('macOsApplicationId to "com.example.my-app"', () {
        final configuration = BdayaNewFlutterAppConfiguration();
        expect(configuration.macOsApplicationId.value, 'com.example.my-app');
      });

      test('androidApplicationId to "com.example.my_app"', () {
        final configuration = BdayaNewFlutterAppConfiguration();
        expect(configuration.androidApplicationId.value, 'com.example.my_app');
      });
    });

    group('throws', () {
      group('a $InvalidAndroidApplicationIdFormat when Android ID', () {
        test('has special characters', () {
          expect(
            () => BdayaNewFlutterAppConfiguration(
              androidApplicationId: AndroidApplicationId('com.example.my_app!'),
            ),
            throwsA(isA<InvalidAndroidApplicationIdFormat>()),
          );
        });

        test('parts start with numeric character', () {
          expect(
            () => BdayaNewFlutterAppConfiguration(
              androidApplicationId:
                  AndroidApplicationId('1com.1example.1my_app'),
            ),
            throwsA(isA<InvalidAndroidApplicationIdFormat>()),
          );
        });

        test('has a single part', () {
          expect(
            () => BdayaNewFlutterAppConfiguration(
              androidApplicationId: AndroidApplicationId('com'),
            ),
            throwsA(isA<InvalidAndroidApplicationIdFormat>()),
          );
        });
      });
    });

    group('fromHookVars', () {
      test('decodes as expected', () {
        final vars = {
          'project_name': 'bdaya flutter app',
          'org_name': 'com.bdaya',
          'application_id': 'com.bdaya.bdaya_app',
          'description': 'A Bdaya Flutter App',
        };

        final configuration =
            BdayaNewFlutterAppConfiguration.fromHookVars(vars);
        expect(
          configuration,
          equals(
            BdayaNewFlutterAppConfiguration(
              projectName: 'bdaya flutter app',
              organizationName: 'com.bdaya',
              description: 'A Bdaya Flutter App',
              windowsApplicationId: WindowsApplicationId('com.bdaya.bdaya_app'),
              iOsApplicationId: AppleApplicationId('com.bdaya.bdaya_app'),
              macOsApplicationId: AppleApplicationId('com.bdaya.bdaya_app'),
              androidApplicationId: AndroidApplicationId('com.bdaya.bdaya_app'),
              androidNamespace: AndroidNamespace('com.bdaya.bdaya_app'),
            ),
          ),
        );
      });

      test('defaults id when empty', () {
        final vars = {
          'project_name': 'bdaya flutter app',
          'org_name': 'com.bdaya',
          'application_id': '',
          'description': 'A Bdaya Flutter App',
        };

        final configuration =
            BdayaNewFlutterAppConfiguration.fromHookVars(vars);
        expect(
          configuration,
          equals(
            BdayaNewFlutterAppConfiguration(
              projectName: 'bdaya flutter app',
              organizationName: 'com.bdaya',
              description: 'A Bdaya Flutter App',
              windowsApplicationId: WindowsApplicationId('com.bdaya.bdaya-app'),
              iOsApplicationId: AppleApplicationId('com.bdaya.bdaya-app'),
              macOsApplicationId: AppleApplicationId('com.bdaya.bdaya-app'),
              androidApplicationId: AndroidApplicationId('com.bdaya.bdaya_app'),
              androidNamespace: AndroidNamespace('com.bdaya.bdaya_app'),
            ),
          ),
        );
      });

      group('throws $ArgumentError', () {
        test('when "project_name" is not a String?', () {
          final vars = <String, dynamic>{'project_name': 42};

          expect(
            () => BdayaNewFlutterAppConfiguration.fromHookVars(vars),
            throwsA(
              isA<ArgumentError>().having(
                (error) => error.message,
                'message',
                '''Expected a value for key "project_name" to be of type String?, got 42.''',
              ),
            ),
          );
        });

        test('when "org_name" is not a String?', () {
          final vars = <String, dynamic>{'org_name': 42};

          expect(
            () => BdayaNewFlutterAppConfiguration.fromHookVars(vars),
            throwsA(
              isA<ArgumentError>().having(
                (error) => error.message,
                'message',
                '''Expected a value for key "org_name" to be of type String?, got 42.''',
              ),
            ),
          );
        });

        test('when "application_id" is not a String?', () {
          final vars = <String, dynamic>{'application_id': 42};

          expect(
            () => BdayaNewFlutterAppConfiguration.fromHookVars(vars),
            throwsA(
              isA<ArgumentError>().having(
                (error) => error.message,
                'message',
                '''Expected a value for key "application_id" to be of type String?, got 42.''',
              ),
            ),
          );
        });

        test('when "description" is not a String?', () {
          final vars = <String, dynamic>{'description': 42};

          expect(
            () => BdayaNewFlutterAppConfiguration.fromHookVars(vars),
            throwsA(
              isA<ArgumentError>().having(
                (error) => error.message,
                'message',
                '''Expected a value for key "description" to be of type String?, got 42.''',
              ),
            ),
          );
        });
      });
    });
  });
}
