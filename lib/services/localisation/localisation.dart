import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Localizer {
  final Locale locale;
  Localizer(this.locale);
  static Localizer? of(BuildContext context) {
    return Localizations.of<Localizer>(context, Localizer);
  }

  late Map<String, String> _localizedStrings;
  Future<bool> load() async {
    final jsonString = await rootBundle.loadString('assets/jsons/${locale.languageCode}.json');
    _localizedStrings = flattenTranslations(jsonDecode(jsonString));
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  dynamic flattenTranslations(Map<String, dynamic> json, [String prefix = '']) {
    final Map<String, String> translations = {};
    json.forEach((String key, dynamic value) {
      if (value is Map) {
        translations.addAll(flattenTranslations(value as Map<String, dynamic>, '$prefix$key.'));
      } else {
        translations['$prefix$key'] = value.toString();
      }
    });
    return translations;
  }

  static const LocalizationsDelegate<Localizer> delegate = _AppLocalizationDelegate();
}

class _AppLocalizationDelegate extends LocalizationsDelegate<Localizer> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<Localizer> load(Locale locale) async {
    final localizations = Localizer(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localizer> old) {
    return false;
  }
}
