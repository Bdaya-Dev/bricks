import '../../../../common.dart';

import 'controller.dart';

class CounterView extends StatelessWidget {
  const CounterView({
    super.key,
    required this.controller,
  });

  static Widget hooked({
    BdayaGetItHookMode hookMode = BdayaGetItHookMode.lazySingleton,
    String? instanceName,
    Object? param1,
    Object? param2,
    List<Object?>? keys,
  }) {
    return HookBuilder(
      builder: (context) => CounterView(
        controller: useBdayaViewController(
          hookMode: hookMode,
          instanceName: instanceName,
          keys: keys,
          param1: param1,
          param2: param2,
        ),
      ),
    );
  }

  final CounterController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        final counter = controller.counter.of(context);
        return Center(
          child: Text('value: $counter'),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: controller.increment,
            child: Icon(Icons.add),
          ),
          Builder(builder: (context) {
            final counter = controller.counter.of(context);
            return FloatingActionButton(
              onPressed: counter == 0 ? null : controller.decrement,
              child: Icon(Icons.remove),
            );
          }),
        ],
      ),
    );
  }
}
