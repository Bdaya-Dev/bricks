import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

// l10n
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
