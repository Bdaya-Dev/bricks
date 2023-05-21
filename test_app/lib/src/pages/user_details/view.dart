import 'package:bdaya_flutter_common/bdaya_flutter_common.dart';
import 'controller.dart';
import 'package:flutter/material.dart';

class UserDetailsView extends StatelessWidget {
  const UserDetailsView({
    super.key,
    required this.controller,
  });

  static Widget hooked() {
    return HookBuilder(
      builder: (context) => UserDetailsView(
        controller: useBdayaViewController(
          hookMode: BdayaGetItHookMode.factory
        ),
      ),
    );
  }

  final UserDetailsController controller;

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
