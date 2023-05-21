import 'package:bdaya_flutter_common/bdaya_flutter_common.dart';
import 'controller.dart';
import 'package:flutter/material.dart';

class UsersView extends StatelessWidget {
  const UsersView({
    super.key,
    required this.controller,
  });

  static Widget hooked() {
    return HookBuilder(
      builder: (context) => UsersView(
        controller: useBdayaViewController(),
      ),
    );
  }

  final UsersController controller;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
