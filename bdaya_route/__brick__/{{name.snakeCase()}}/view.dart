import 'package:bdaya_flutter_common/bdaya_flutter_common.dart';
import 'controller.dart';
import 'package:flutter/material.dart';

class {{name.pascalCase()}}View extends StatelessWidget {
  const {{name.pascalCase()}}View({
    super.key,
    required this.controller,
  });

  static Widget hooked({
    BdayaGetItHookMode hookMode = BdayaGetItHookMode.lazySingleton,
    String? instanceName,
    Object? param1,
    Object? param2,
    List<Object?>? keys,
  }) => HookBuilder(
      builder: (context) => {{name.pascalCase()}}View(
        controller: useBdayaViewController(
          hookMode: hookMode,
          instanceName: instanceName,
          keys: keys,
          param1: param1,
          param2: param2,
        ),
      ),
    );
  

  final {{name.pascalCase()}}Controller controller;

  @override
  Widget build(BuildContext context) {
    final id = controller.idRx.of(context);
    if (id == null) {
      return const SizedBox.shrink();
    }
    //see also BdayaMultiLoadableAreaWrapper, and BdayaLoadableAreaWrapper.custom
    return BdayaLoadableAreaWrapper(
      area: controller.defaultArea,
      builder: (context) {
        //start using details after loading is done
        final details = controller.detailsRx.of(context);
        if (details == null) {
          return const SizedBox.shrink();
        }
        //show details here
        return const Placeholder();
      },
      // //show errors
      // displayErrors: true,
      // //customize error builder
      // errorBuilder: (context, displayName, error, st) {

      // },
      // //customize loading builder
      // isLoadingBuilder: (context, displayName) {

      // },
    );
  }
}
