import 'package:flutter_test/flutter_test.dart';
import 'package:capuno_navigation_app/main.dart';

void main() {
  testWidgets('StudentApp renders LoginScreen smoke test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentApp());
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });
}
