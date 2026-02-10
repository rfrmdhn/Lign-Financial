import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/app/app.dart';

void main() {
  testWidgets('App smoke test - Login Screen Renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: LignFinancialApp()));
    await tester.pumpAndSettle(); // Wait for navigation

    // Verify that the login screen shows up (since we are unauthenticated)
    expect(find.text('Login'), findsWidgets); // Button and/or Title
    expect(find.text('Corporate Banking & Spend Management'), findsOneWidget);
  });
}
