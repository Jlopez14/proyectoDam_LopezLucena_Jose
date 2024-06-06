import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyectofinaljoselopez/main.dart';

void main() {
  testWidgets('Inicio de sesión correcto', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Encuentra los campos de texto y el botón
    final emailField = find.byKey(Key('emailField'));
    final passwordField = find.byKey(Key('passwordField'));
    final loginButton = find.byKey(Key('loginButton'));

    // Asegúrate de que los widgets están presentes en el árbol de widgets
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    // Ingresa texto en los campos
    await tester.enterText(emailField, 'john.doe@example.com');
    await tester.enterText(passwordField, 'password123');

    // Presiona el botón de inicio de sesión
    await tester.tap(loginButton);

    // Espera a que el widget se reconstruya
    await tester.pumpAndSettle();

    // Verifica que el inicio de sesión fue exitoso
    // Aquí puedes verificar que la navegación ha ocurrido, por ejemplo:
    expect(find.text('Inicio'), findsOneWidget);  // Asegúrate de que esto se ajuste a tu implementación
  });

  testWidgets('Error de inicio de sesión', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Encuentra los campos de texto y el botón
    final emailField = find.byKey(Key('emailField'));
    final passwordField = find.byKey(Key('passwordField'));
    final loginButton = find.byKey(Key('loginButton'));

    // Asegúrate de que los widgets están presentes en el árbol de widgets
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    // Ingresa texto en los campos
    await tester.enterText(emailField, 'john.doe@example.com');
    await tester.enterText(passwordField, 'wrongpassword');

    // Presiona el botón de inicio de sesión
    await tester.tap(loginButton);

    // Espera a que el widget se reconstruya
    await tester.pumpAndSettle();

    // Verifica que se muestra un mensaje de error
    expect(find.byKey(Key('errorMessage')), findsOneWidget);
    expect(find.text('Correo electrónico o contraseña incorrectos'), findsOneWidget);
  });
}
