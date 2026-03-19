import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_booking_app/main.dart';

void main() {
  testWidgets('App loads login screen by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GourmetHavenApp());
    await tester.pumpAndSettle();

    expect(find.text('Restaurant Manager'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Register'), findsOneWidget);
  });
}
