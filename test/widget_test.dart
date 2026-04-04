import 'package:flutter_test/flutter_test.dart';
import 'package:inficalc/main.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const InfiCalcApp());

    // Verify that splash screen text is present.
    expect(find.text('InfiCalc'), findsOneWidget);
  });
}
