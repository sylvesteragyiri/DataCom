import 'package:datacom/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App shell shows the three root tabs', (tester) async {
    await EasyLocalization.ensureInitialized();
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ru', 'RU')],
        path: 'assets/lang',
        fallbackLocale: const Locale('en', 'US'),
        child: const ProviderScope(child: DataComApp()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Services'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
  });
}
