import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_kaptura/app/app.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    dotenv.testLoad(
      fileInput:
          'USER_API_BASE=https://example.com\nAPI_BASE=https://example.com',
    );

    await tester.pumpWidget(const ProviderScope(child: AppRoot()));
    await tester.pump();

    expect(find.byType(AppRoot), findsOneWidget);
  });
}
