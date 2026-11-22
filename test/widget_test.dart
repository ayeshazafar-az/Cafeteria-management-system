import 'package:flutter_test/flutter_test.dart';
import 'package:cafeteria_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CafeteriaApp());
    expect(find.text('Campus Cafeteria'), findsOneWidget);
  });
}
