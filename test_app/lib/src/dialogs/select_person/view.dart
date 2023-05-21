import 'package:bdaya_flutter_common/bdaya_flutter_common.dart';
import 'controller.dart';
import 'package:flutter/material.dart';

import 'form.dart';

class SelectPersonView extends StatelessWidget {
  const SelectPersonView({
    super.key,
    required this.controller,
  });

  static Widget hooked({
    BdayaGetItHookMode hookMode = BdayaGetItHookMode.factory,
    String? instanceName,
    Object? param1,
    Object? param2,
    List<Object?>? keys,
  }) => HookBuilder(
      builder: (context) => SelectPersonView(
        controller: useBdayaViewController(
          hookMode: hookMode,
          instanceName: instanceName,
          keys: keys,
          param1: param1,
          param2: param2,
        ),
      ),
    );
  

  //TODO: Replace T with the expected modal result
  static Future<T?> showModal<T>(
    BuildContext context, {
    SelectPersonFormParameters? params,
  }) async {
    return await showDialog<T>(
      context: context,
      builder: (context) => Dialog(
        //TODO: assign dialog properties
        child: hooked(
          param1: params,
        ),
      ),
    );
  }
  
  final SelectPersonController controller;

  @override
  Widget build(BuildContext context) {    
    //see also BdayaMultiLoadableAreaWrapper, and BdayaLoadableAreaWrapper.custom
    return SelectPersonModelFormBuilder(
      model: controller.initialModelRx.of(context),
      initState: (context, formModel) => controller.formRx.$ = formModel,            
      builder: (context, form, _) {        
        return Column(
          children: [
            //Add form controls ...
          ],
        );
      },
    );
  }
}
