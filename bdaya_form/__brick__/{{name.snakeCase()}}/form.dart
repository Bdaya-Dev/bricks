import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_forms_annotations/reactive_forms_annotations.dart';

part 'form.gform.dart';

@ReactiveFormAnnotation()
class {{name.pascalCase()}}Model {

  const {{name.pascalCase()}}Model({
    @FormControlAnnotation() this.name,
  });  

  final String? name;
}