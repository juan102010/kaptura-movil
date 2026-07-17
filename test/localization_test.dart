import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_kaptura/core/constants/locale_constants.dart';
import 'package:flutter_kaptura/app/localization/locale_controller.dart';
import 'package:flutter_kaptura/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_kaptura/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('only English and Spanish are supported', () {
    expect(LocaleConstants.supportedLocales, const [
      Locale('en'),
      Locale('es'),
    ]);
    expect(
      LocaleConstants.supportedOrEnglish(const Locale('fr')),
      const Locale('en'),
    );
    expect(
      LocaleConstants.supportedOrEnglish(const Locale('es', 'CO')),
      const Locale('es'),
    );
  });

  for (final testCase in [
    (locale: const Locale('en'), settings: 'Settings', language: 'Language'),
    (locale: const Locale('es'), settings: 'Ajustes', language: 'Idioma'),
  ]) {
    testWidgets('loads ${testCase.locale.languageCode} translations', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: testCase.locale,
          supportedLocales: LocaleConstants.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) {
              final translations = AppLocalizations.of(context);
              return Text('${translations.settings}|${translations.language}');
            },
          ),
        ),
      );

      expect(
        find.text('${testCase.settings}|${testCase.language}'),
        findsOneWidget,
      );
    });
  }

  testWidgets('changes and persists the language from Settings', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'app_locale': 'en'});

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, child) {
            final locale = ref.watch(localeControllerProvider);
            return MaterialApp(
              locale: locale,
              supportedLocales: LocaleConstants.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: const SettingsPage(),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);
    await tester.tap(find.text('Spanish'));
    await tester.pumpAndSettle();

    expect(find.text('Idioma'), findsOneWidget);
    expect(find.text('Ajustes'), findsNWidgets(2));
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('app_locale'), 'es');
  });
}
