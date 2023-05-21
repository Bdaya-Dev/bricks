import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_forms_annotations/reactive_forms_annotations.dart';

part 'form.gform.dart';

@ReactiveFormAnnotation()
class EditBookModel {

  const EditBookModel({
    @FormControlAnnotation() this.name,
  });  

  final String? name;
}