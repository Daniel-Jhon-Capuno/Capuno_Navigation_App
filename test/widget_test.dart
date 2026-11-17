import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:capuno_act6_app/main.dart';

void main() {
  testWidgets('Full Social Media & Auth flow test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const StudentApp());

    // 1. Log in using the default admin account -> MainScreen opens.
    expect(find.text('Welcome Back!'), findsOneWidget);
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
    expect(find.text('Welcome, Student!'), findsOneWidget);

    // 2. Open Social Media -> Sample posts appear.
    await tester.tap(find.text('Social Media').last);
    await tester.pumpAndSettle();
    expect(find.text('Enjoying the sunny weather!'), findsOneWidget);
    expect(find.text('Just finished a great book!'), findsOneWidget);

    // 3. Submit a post with empty fields -> Validation message appears.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pump();
    expect(
      find.text('Complete both fields before submitting!'),
      findsOneWidget,
    );
    ScaffoldMessenger.of(
      tester.element(find.byType(Scaffold).first),
    ).clearSnackBars();
    await tester.pumpAndSettle();

    // 4. Submit a post with an invalid URL -> URL validation message appears.
    await tester.enterText(
      find.widgetWithText(TextField, 'Caption'),
      'My first Flutter social media post!',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Image URL'),
      'invalid-url',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pump();
    expect(
      find.text('Enter a valid HTTP or HTTPS image URL.'),
      findsOneWidget,
    );
    ScaffoldMessenger.of(
      tester.element(find.byType(Scaffold).first),
    ).clearSnackBars();
    await tester.pumpAndSettle();

    // 5. Submit a valid post -> New post appears at top with logged-in username.
    await tester.enterText(
      find.widgetWithText(TextField, 'Image URL'),
      'https://picsum.photos/id/20/600/400',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();
    expect(find.text('My first Flutter social media post!'), findsOneWidget);
    expect(find.text('admin'), findsOneWidget);

    // 6. Tap Like twice -> Changes to Liked, then back to Like.
    await tester.tap(find.text('Like').first);
    await tester.pump();
    expect(find.text('Liked'), findsOneWidget);

    await tester.tap(find.text('Liked').first);
    await tester.pump();
    expect(find.text('Liked'), findsNothing);

    // Like it again for state persistence checks.
    await tester.tap(find.text('Like').first);
    await tester.pump();
    expect(find.text('Liked'), findsOneWidget);

    // 7. Add a nonempty comment -> Comment appears and count increases.
    await tester.enterText(
      find.widgetWithText(TextField, 'Add a comment...').first,
      'Great post!',
    );
    await tester.tap(find.byIcon(Icons.send).first);
    await tester.pump();
    expect(find.text('Great post!'), findsOneWidget);
    expect(find.text('1 Comments'), findsOneWidget);

    // 8. Submit a blank comment -> No comment is added.
    await tester.enterText(
      find.widgetWithText(TextField, 'Add a comment...').first,
      '   ',
    );
    await tester.tap(find.byIcon(Icons.send).first);
    await tester.pump();
    expect(find.text('1 Comments'), findsOneWidget);

    // 9. Switch to Home and return -> Posts, likes, and comments remain.
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Social Media').last);
    await tester.pumpAndSettle();
    expect(find.text('My first Flutter social media post!'), findsOneWidget);
    expect(find.text('Liked'), findsOneWidget);
    expect(find.text('Great post!'), findsOneWidget);
  });
}
