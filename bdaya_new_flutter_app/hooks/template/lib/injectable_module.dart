import 'package:go_router/go_router.dart';

import 'common.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  GoRouter getRouter() => GoRouter(
        routes: appRoutesList(),
        initialLocation: AppRouteNames.initialRoute,
        redirect: mainRedirect,
      );
}
