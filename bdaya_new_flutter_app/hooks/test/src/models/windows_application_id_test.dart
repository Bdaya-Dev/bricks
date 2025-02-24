import 'package:test/test.dart';
import 'package:bdaya_new_flutter_app/bdaya_new_flutter_app_hooks.dart';

void main() {
  group('$WindowsApplicationId', () {
    group('fallback', () {
      test(
        'concatenates organization name with project name in param case',
        () {
          const organizationName = 'com.example.hello-world';
          const projectName = 'my app';
          final windowsApplicationId = WindowsApplicationId.fallback(
            organizationName: organizationName,
            projectName: projectName,
          );
          expect(windowsApplicationId.value, 'com.example.hello-world.my-app');
        },
      );

      test(
        'ignores empty parts',
        () {
          const organizationName = 'com.example.hello_world';
          const projectName = 'my app';
          final windowsApplicationId = WindowsApplicationId.fallback(
            organizationName: organizationName,
            projectName: projectName,
          );
          expect(windowsApplicationId.value, 'com.example.hello-world.my-app');
        },
      );
    });
  });
}
