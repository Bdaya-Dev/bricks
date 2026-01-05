import '../../../../common.dart';

@lazySingleton
class CounterController extends BdayaCombinedController {
  CounterController(/*add getIt dependencies here*/);

  final counter = SharedValue<int>(value: 0);

  void increment() => counter.$++;

  void decrement() => counter.$--;
}
