import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_booking_app/main.dart';

void main() {
  testWidgets('Customer home screen renders key sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GourmetHavenApp());

    expect(find.text('Gourmet Haven'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Categories'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Categories'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Featured Dishes'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Featured Dishes'), findsOneWidget);
  });
}
