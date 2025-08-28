import 'dart:async';

import 'package:go_router/go_router.dart';

import 'common.dart';

final appShellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'appShell',
);
final dashboardShellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'dashboardShell',
);
final publicShellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'publicShell',
);

class AppRouteNames {
  static const initialRoute = '/';

  // static const kPublicHome = 'public_home';
  // static const kAuth = 'auth';
  // static const kSignIn = 'sign_in';
  // static const kSignUp = 'sign_up';
  // static const kSignUpVerification = 'sign_up_verification';
  // static const kForgetPassword = 'forget_password';
  // static const kResetPasswordVerification = 'reset_password_verification';
  // static const kNewPassword = 'new_password';
  static const kHome = 'home';
  // static const kDashboard = 'dashboard';
}

FutureOr<String?> mainRedirect(BuildContext context, GoRouterState state) {
  // TODO: implement mainRedirect
  return null;
}

List<RouteBase> appRoutesList() => [
      ShellRoute(
        navigatorKey: appShellNavigatorKey,
        builder: (context, state, child) => Scaffold(
          body: AppShellView.hooked(child: child),
        ),
        routes: [
          //
          GoRoute(
            path: '/',
            name: AppRouteNames.initialRoute,
            redirect: (context, state) {
              if (state.uri.path == '/') {
                return state.namedLocation(
                  AppRouteNames.kHome,
                  queryParameters: state.uri.queryParameters,
                );
              }
              return null;
            },
          ),
          //public pages
          // ShellRoute(
          //   navigatorKey: publicShellNavigatorKey,
          //   builder: (context, state, child) =>
          //       PublicShellView.hooked(child: child),
          //   routes: [
          //     GoRoute(
          //       path: '/language',
          //       name: AppRouteNames.kLanguage,
          //       builder: (context, state) => HookBuilder(
          //         builder: (context) => LanguageScreenView(
          //           controller: useBdayaViewController(),
          //         ),
          //       ),
          //     ),
          //     GoRoute(
          //       path: '/onboarding',
          //       name: AppRouteNames.kOnboarding,
          //       builder: (context, state) => HookBuilder(
          //         builder: (context) => OnBoardingScreenView(
          //           controller: useBdayaViewController(),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),

          // //auth page
          // GoRoute(
          //   path: '/auth',
          //   name: AppRouteNames.kAuth,
          //   redirect: (context, state) async {
          //     // TODO: implement auth redirect
          //     throw UnimplementedError();
          //   },
          //   builder: (context, state) => throw UnimplementedError(),
          // ),

          // // dashboard pages
          ShellRoute(
            navigatorKey: dashboardShellNavigatorKey,
            builder: (context, state, child) {
              return HookBuilder(
                builder: (context) => DashboardShellView(
                  controller: useBdayaViewController(),
                  child: child,
                ),
              );
            },
            routes: [
              //
            ],
          ),
        ],
      ),
    ];
