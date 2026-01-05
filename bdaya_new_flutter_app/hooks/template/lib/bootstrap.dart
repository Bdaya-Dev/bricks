import 'dart:async';

import 'common.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optional, business based,: Lock device orientation to portrait mode
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]);

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    bdayaOnRecordHandlerFactory(
        showSequenceNumber: false, showTime: false, showError: true),
  );
  setPathUrlStrategy();
  getIt.allowReassignment = true;

  configureDependencies();

  runApp(SharedValue.wrapApp(await builder()));
}
