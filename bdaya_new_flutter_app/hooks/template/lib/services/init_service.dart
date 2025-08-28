import '../common.dart';
import 'package:async/async.dart';

@lazySingleton
class InitService {
  var initMemo = AsyncMemoizer<void>();

  InitService();

  Future<void> _reset() async {
    initMemo = AsyncMemoizer<void>();
  }

  Future<void> init(BuildContext context, {bool retrying = false}) async {
    if (retrying) {
      await _reset();
    }
    await initMemo.runOnce(() async {
      await getIt<BdayaAppThemeServiceBase>().init();
      await Future.delayed(const Duration(milliseconds: 300));
      await Future.wait([
        //parallel init

        //delay for 3 seconds to get a chance to display animations,logo,etc...
        Future.delayed(const Duration(seconds: 3)),
        //actual init sequence`
        if (context.mounted) _sequentialInit(context),
      ]);
    });
  }

  Future<void> _sequentialInit(BuildContext context) async {
    final l = Localizations.localeOf(context);
    final brightness = MediaQuery.of(context).platformBrightness;
    final l10n = context.l10n;
    final localizationsService = getIt<LocalizationsService>();
    localizationsService.setCurrentL10n(l10n);

    try {
      if (context.mounted) {
        await getIt<AppConfigService>().init(context, l, brightness);
      }
      // TODO: initialize other services
    } catch (e, st) {
      Logger("init-service").severe(
        l10n.unknown_error,
        e,
        st,
      );
      rethrow;
    }
  }
}
