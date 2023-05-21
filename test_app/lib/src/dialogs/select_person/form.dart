import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_forms_annotations/reactive_forms_annotations.dart';

part 'form.gform.dart';

@ReactiveFormAnnotation()
class SelectPersonModel {
  const SelectPersonModel({
    @FormControlAnnotation() this.name,
  });

  final String? name;
}
