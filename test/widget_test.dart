import 'package:flutter_test/flutter_test.dart';
import 'package:app2/main.dart';

void main() {
  testWidgets('ZenBreathe renders app correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ZenBreatheApp());
    expect(find.byType(ZenBreatheApp), findsOneWidget);
  });
}
