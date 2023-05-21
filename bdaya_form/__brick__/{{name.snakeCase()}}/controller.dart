import 'package:bdaya_flutter_common/bdaya_flutter_common.dart';
import 'package:flutter/widgets.dart';
import 'form.dart';

class {{name.pascalCase()}}FormParameters {

}

@injectable
class {{name.pascalCase()}}Controller extends BdayaCombinedController {    
  final {{name.pascalCase()}}FormParameters parameters;

  {{name.pascalCase()}}Controller(@factoryParam this.parameters);
  
  final initialModelRx = SharedValue<{{name.pascalCase()}}Model?>(value: null);
  final formRx = SharedValue<{{name.pascalCase()}}ModelForm?>(value: null);
  

  @override
  void beforeRender(BuildContext context) {
    super.beforeRender(context);
    //initialize initialModelRx from the passed parameters here
    //initialModelRx.$ = ... 
  }
}
