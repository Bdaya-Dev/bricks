import 'package:bdaya_flutter_common/bdaya_flutter_common.dart';
import 'package:flutter/widgets.dart';
import 'form.dart';

class EditBookFormParameters {

}

@injectable
class EditBookController extends BdayaCombinedController {    
  final EditBookFormParameters parameters;

  EditBookController(@factoryParam this.parameters);
  
  final initialModelRx = SharedValue<EditBookModel?>(value: null);
  final formRx = SharedValue<EditBookModelForm?>(value: null);
  

  @override
  void beforeRender(BuildContext context) {
    super.beforeRender(context);
    //initialize initialModelRx from the passed parameters here
    //initialModelRx.$ = ... 
  }
}
