import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: LignFinancialApp()));

    // Verify that the home screen shows 'Lign Financial Home'.
    expect(find.text('Lign Financial Home'), findsOneWidget);
  });
}
