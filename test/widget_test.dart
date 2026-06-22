import 'package:flutter_test/flutter_test.dart';
import 'package:louco_assignment/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LoucoApp());
    await tester.pump();
    expect(find.byType(LoucoApp), findsOneWidget);
  });
}
