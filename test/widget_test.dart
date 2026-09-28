import 'package:datacom/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App shell shows the three root tabs', (tester) async {
    final semantics = tester.ensureSemantics();
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

    // The bottom nav is icon-only (floating pill, no visible labels), so
    // its tabs are found via accessibility semantics, not find.text.
    expect(find.bySemanticsLabel('Home'), findsOneWidget);
    expect(find.bySemanticsLabel('Services'), findsOneWidget);
    expect(find.bySemanticsLabel('Settings'), findsOneWidget);
    semantics.dispose();
  });
}
