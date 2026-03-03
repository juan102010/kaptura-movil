import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_kaptura/app/app.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AppRoot()));
    await tester.pump();

    // Verifica que la app arranca (login page o root)
    expect(find.byType(AppRoot), findsOneWidget);
  });
}
