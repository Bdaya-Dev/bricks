import '../common.dart';

@lazySingleton
class AppConfigService {
  final BdayaAppThemeServiceBase themeService;
  AppConfigService(this.themeService);

  final logger = Logger('app-config-service');

  Future<void> init(
      BuildContext context, Locale l, Brightness brightness) async {
    logger.fine('Initializing App configs service...');
    // ensure locale is initialized!
    if (themeService.locale.$ == null) {
      await themeService.setLocale(const Locale('ar'));
      await Future.delayed(const Duration(milliseconds: 300));
      if (context.mounted) {
        getIt<LocalizationsService>().setCurrentL10n(context.l10n);
      }
      logger.fine(
          'Locale initialization ensured, locale initial value: ${themeService.locale.$}.');
    }
    // ensure theme mode is initialized!
    if (themeService.themeMode.$ == null) {
      // final sysThemeMode = brightness == Brightness.dark
      //     ? ThemeMode.dark
      //     : brightness == Brightness.light
      //         ? ThemeMode.light
      //         : ThemeMode.system;
      themeService.setThemeMode(ThemeMode.light);
      logger.fine(
          'Theme mode initialization ensured, theme mode initial value: ${themeService.themeMode.$}.');
    }

    // await Future.wait([
    //   showOnboarding.load(),
    //   chooseLanguage.load(),
    // ]);
    // logger.fine(
    //     'App Configs Service Initialization Done, show_onboarding: ${showOnboarding.$}, show_choose_lang: ${chooseLanguage.$}.'); // TODO replace value with dollar sign
  }

  // final showOnboarding = SharedValue(
  //   key: 'show_onboarding',
  //   value: true,
  //   autosave: true,
  // );

  // final chooseLanguage = SharedValue(
  //   key: 'choose_language',
  //   value: true,
  //   autosave: true,
  // );
}
