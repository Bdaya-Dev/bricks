import '../../common.dart';

import 'controller.dart';

class PublicShellView extends StatelessWidget {
  const PublicShellView({
    super.key,
    required this.controller,
    required this.child,
  });

  static Widget hooked({
    required Widget child,
    BdayaGetItHookMode hookMode = BdayaGetItHookMode.lazySingleton,
    String? instanceName,
    Object? param1,
    Object? param2,
    List<Object?>? keys,
  }) {
    return HookBuilder(
      builder: (context) => PublicShellView(
        controller: useBdayaViewController(
          hookMode: hookMode,
          instanceName: instanceName,
          keys: keys,
          param1: param1,
          param2: param2,
        ),
        child: child,
      ),
    );
  }

  final PublicShellController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
