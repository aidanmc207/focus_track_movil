import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:focus_track_movil/main.dart';

Future<void> completarMetas(WidgetTester tester, int veces) async {
  for (var i = 0; i < veces; i++) {
    await tester.tap(find.text('Completar Meta'));
    await tester.pump();
  }
}

void main() {
  testWidgets('Incrementa, decrementa y actualiza el nivel', (tester) async {
    await tester.pumpWidget(const FocusTrackApp());

    expect(find.text('0 / 5'), findsOneWidget);
    expect(find.text('Inicial'), findsOneWidget);

    await completarMetas(tester, 3);
    expect(find.text('3 / 5'), findsOneWidget);
    expect(find.text('En Progreso'), findsOneWidget);

    await completarMetas(tester, 2);
    expect(find.text('¡Objetivo Alcanzado!'), findsOneWidget);

    await completarMetas(tester, 1);
    expect(find.text('¡Sobresaliente (+1)!'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('5 / 5'), findsOneWidget);
  });

  testWidgets('El decremento no baja de cero', (tester) async {
    await tester.pumpWidget(const FocusTrackApp());

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('0 / 5'), findsOneWidget);
  });

  testWidgets('El reinicio pide confirmación y restablece a cero', (
    tester,
  ) async {
    await tester.pumpWidget(const FocusTrackApp());
    await completarMetas(tester, 2);

    await tester.tap(find.byIcon(Icons.restart_alt));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('2 / 5'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.restart_alt));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reiniciar'));
    await tester.pump();
    expect(find.text('0 / 5'), findsOneWidget);
    expect(find.text('Metas restablecidas exitosamente.'), findsOneWidget);
  });

  testWidgets('No permite superar el límite diario de 10 metas', (
    tester,
  ) async {
    await tester.pumpWidget(const FocusTrackApp());

    await completarMetas(tester, 10);
    expect(find.text('10 / 5'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);

    await completarMetas(tester, 1);
    expect(find.text('10 / 5'), findsOneWidget);
    expect(
      find.text(
        'Ha alcanzado el límite máximo diario de metas (10/10). '
        '¡Excelente jornada!',
      ),
      findsOneWidget,
    );
  });

  testWidgets('No hay desbordamientos en un teléfono pequeño', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const FocusTrackApp());
    await completarMetas(tester, 10);

    expect(tester.takeException(), isNull);
  });

  testWidgets('El selector de prioridad actualiza el panel informativo', (
    tester,
  ) async {
    await tester.pumpWidget(const FocusTrackApp());

    expect(find.textContaining('Prioridad Media.'), findsOneWidget);

    await tester.tap(find.text('Alta'));
    await tester.pump();
    expect(find.textContaining('Prioridad Alta.'), findsOneWidget);

    final borde =
        tester.widget<Card>(find.byType(Card).last).shape!
            as RoundedRectangleBorder;
    expect(borde.side.color, Prioridad.alta.color);

    await tester.tap(find.text('Baja'));
    await tester.pump();
    expect(find.textContaining('Prioridad Baja.'), findsOneWidget);
  });
}
