import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:predictive_app/services/localisation/localisation.dart';
import 'package:predictive_app/services/route/route_service.dart';
import 'package:predictive_app/theme/app_theme.dart';

class PredictiveAppContainer extends StatefulWidget {
  const PredictiveAppContainer({Key? key}) : super(key: key);
  @override
  State<PredictiveAppContainer> createState() => _PredictiveAppContainerState();
}

class _PredictiveAppContainerState extends State<PredictiveAppContainer> {
  Locale? _locale;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('en', ''), Locale('fr', ''), Locale('zh', '')],
      localizationsDelegates: _getLocalizationsDelegates(),
      localeResolutionCallback: (locale, supportedLocales) => _getLocale(locale, supportedLocales),
      theme: AppTheme.bookingTheme,
      routerConfig: router,
    );
  }

  List<LocalizationsDelegate> _getLocalizationsDelegates() {
    return [
      Localizer.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ];
  }

  Locale _getLocale(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) {
      return supportedLocales.first;
    }
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }
}
