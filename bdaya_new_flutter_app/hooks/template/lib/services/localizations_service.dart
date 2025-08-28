import '../common.dart';

@lazySingleton
class LocalizationsService {
  AppLocalizations? _l10n;

  AppLocalizations get l10n {
    assert(_l10n != null,
        'LocalizationsService not initialized. Call setCurrentL10n() first.');
    return _l10n!;
  }

  final _logger = Logger('LocalizationsService');

  void setCurrentL10n(AppLocalizations l10n) {
    _l10n = l10n;
    final localeName = l10n.localeName;
    _logger.info('Current localization set to: $localeName');
  }
}
