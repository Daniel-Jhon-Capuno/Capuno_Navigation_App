import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:capuno_act7_lab/main.dart';

void main() {
  testWidgets('Complete Activity 7 flow test (14 checkpoints)', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const StudentApp());

    // 1. Open the application -> Login appears first.
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Welcome Back!'), findsOneWidget);

    // 2. Submit empty login fields -> Validation messages appear.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();
    expect(find.text('Enter your username.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    // 3. Enter incorrect credentials -> Login is rejected.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'wronguser',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'wrongpass',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();
    expect(find.text('Invalid username or password.'), findsOneWidget);
    ScaffoldMessenger.of(
      tester.element(find.byType(Scaffold).first),
    ).clearSnackBars();
    await tester.pumpAndSettle();

    // 4. Enter admin / admin123 -> Dashboard opens.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'admin',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'admin123',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // 5. Read the dashboard greeting -> Displays Welcome, admin!
    expect(find.text('Welcome, admin!'), findsOneWidget);

    // 6. Open Calculator and calculate 10 + 5 -> Displays 15.0 (plus 20 and 5 checkpoint).
    await tester.tap(find.text('Calculator').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'First Number'),
      '20',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Second Number'),
      '5',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '+'));
    await tester.pump();
    expect(find.text('25.0'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, '−'));
    await tester.pump();
    expect(find.text('15.0'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, '×'));
    await tester.pump();
    expect(find.text('100.0'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, '÷'));
    await tester.pump();
    expect(find.text('4.0'), findsOneWidget);

    // Now test 10 + 5 = 15.0 specifically for Test #6
    await tester.enterText(
      find.widgetWithText(TextField, 'First Number'),
      '10',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Second Number'),
      '5',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '+'));
    await tester.pump();
    expect(find.text('15.0'), findsOneWidget);

    // 7. Switch tabs and return to Calculator -> Inputs and result remain.
    await tester.tap(find.text('Dashboard').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Calculator').last);
    await tester.pumpAndSettle();
    expect(find.text('15.0'), findsOneWidget);
    expect(find.text('10.0 + 5.0'), findsOneWidget);

    // 8. Create a social post -> Post displays the logged-in username.
    await tester.tap(find.text('Social').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Caption'),
      'Hello from admin!',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Image URL'),
      'https://picsum.photos/id/20/600/400',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();
    expect(find.text('Hello from admin!'), findsOneWidget);
    expect(find.text('admin'), findsOneWidget);

    // 9. Like a post and add a comment -> Both interactions update correctly.
    await tester.tap(find.text('Like').first);
    await tester.pump();
    expect(find.text('Liked'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Add a comment...').first,
      'Awesome update!',
    );
    await tester.tap(find.byIcon(Icons.send).first);
    await tester.pump();
    expect(find.text('Awesome update!'), findsOneWidget);
    expect(find.text('1 Comments'), findsOneWidget);

    // 10. Switch tabs and return to Social -> Posts, likes, and comments remain.
    await tester.tap(find.text('Dashboard').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Social').last);
    await tester.pumpAndSettle();
    expect(find.text('Hello from admin!'), findsOneWidget);
    expect(find.text('Liked'), findsOneWidget);
    expect(find.text('Awesome update!'), findsOneWidget);

    // 11. Open Profile -> Student information and username appear.
    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    expect(find.text('Daniel Jhon Capuno'), findsOneWidget);
    expect(find.text('Logged in as: admin'), findsOneWidget);
    expect(find.text('554505'), findsOneWidget);

    // 12. Tap Logout -> Login appears; Back does not reopen MainScreen.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back!'), findsOneWidget);

    // 13. Register a valid account and log in -> Dashboard displays the registered username.
    await tester.tap(find.text("Don't have an account? Register"));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'daniel',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'secret123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm Password'),
      'secret123',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();
    ScaffoldMessenger.of(
      tester.element(find.byType(Scaffold).first),
    ).clearSnackBars();
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'daniel',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'secret123',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, daniel!'), findsOneWidget);

    // 14. Create a post using the registered account -> Post displays the registered username.
    await tester.tap(find.text('Social').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Caption'),
      'My registered account post!',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Image URL'),
      'https://picsum.photos/id/24/600/400',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();
    expect(find.text('My registered account post!'), findsOneWidget);
    expect(find.text('daniel'), findsOneWidget);
  });
}
