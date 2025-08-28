import 'package:go_router/go_router.dart';
import '../../common.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = getIt<BdayaAppThemeServiceBase>();
    final locale = themeService.locale.of(context);
    final themeMode = themeService.themeMode.of(context);

    return MaterialApp.router(
      builder: (context, child) => SplashScreen(child: child),
      // onGenerateTitle: (context) => context.l10n.appTitle, // TODO add title to l10n
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: getIt<GoRouter>(),
      locale: locale,
      // theme: AppColorScheme.lightThemeData(fontFamily),
      themeMode: themeMode,
      // darkTheme: AppColorScheme.darkThemeData(fontFamily),
      // debugShowCheckedModeBanner: false,
    );
  }
}
