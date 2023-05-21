import 'package:bdaya_flutter_common/bdaya_flutter_common.dart';
import 'package:flutter/widgets.dart';

import 'form.dart';

class SelectPersonFormParameters {

}

@injectable
class SelectPersonController extends BdayaCombinedController {    
  final SelectPersonFormParameters parameters;

  SelectPersonController(@factoryParam this.parameters);
  
  final initialModelRx = SharedValue<SelectPersonModel?>(value: null);
  final formRx = SharedValue<SelectPersonModelForm?>(value: null);
  

  @override
  void beforeRender(BuildContext context) {
    super.beforeRender(context);
    //initialize initialModelRx from the passed parameters here
    //initialModelRx.$ = ... 
  }
}
