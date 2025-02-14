import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const List<double> criancaDoExemplo = [
    0, // science exploration
    0, // self regulation
    0, // critical thinking
    1, // childHood literacy
    1, // love and kindnesse
    0.4 // soft skills
  ];
  static const List<double> criancaGOAT = [
    1, // science exploration
    1, // self regulation
    1, // critical thinking
    1, // childHood literacy
    1, // love and kindnesse
    1 // soft skills
  ];
  static const List<double> criancaResultadoInesperado = [
    1, // science exploration
    0, // self regulation
    0, // critical thinking
    0, // childHood literacy
    0, // love and kindnesse
    0 // soft skills
  ];

  static const List<double> criancaAmorosa = [
    0, // science exploration
    0, // self regulation
    0, // critical thinking
    0, // childHood literacy
    1, // love and kindnesse
    0 // soft skills
  ];
  static const List<double> criancaExemploReal = [
    0.0987, //science exploration
    0.0987, //self regulation
    0.0493, //critical thinking
    0.0123, //childHood literacy
    0.5555, //love and kindness
    0.1851 //soft skills
  ];
  static const criancaEscolhida = criancaDoExemplo;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(300, 300),
                painter: RegularHexagonPainter(strokeThickness: 15),
              ),
              CustomPaint(
                size: const Size(240, 240),
                painter: InnerHexagonPainter(
                    fillColor: const Color.fromARGB(255, 160, 189, 214),
                    childrenStats: criancaEscolhida,
                    paintingStyle: PaintingStyle.stroke),
              ),
              CustomPaint(
                size: const Size(235, 235),
                painter: InnerHexagonPainter(
                    fillColor: const Color.fromARGB(210, 206, 230, 250),
                    childrenStats: criancaEscolhida,
                    paintingStyle: PaintingStyle.fill),
              ),
              CustomPaint(
                size: const Size(200, 200),
                painter: RegularHexagonPainter(strokeThickness: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegularHexagonPainter extends CustomPainter {
  final double strokeThickness;

  RegularHexagonPainter({super.repaint, required this.strokeThickness});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeThickness
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    Path path = Path();

    double w = size.width;
    double centerX = 100;
    double centerY = 100;
    double radius = w / 2;

    for (int i = 0; i < 6; i++) {
      double angle = pi / 3 * i +
          pi / 6; // esse pi/6 é só pra rodar ele e ficar igual o do app;
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class InnerHexagonPainter extends CustomPainter {
  final Color fillColor;
  final List<double> childrenStats;
  final PaintingStyle paintingStyle;

  InnerHexagonPainter(
      {required this.paintingStyle,
      required this.childrenStats,
      super.repaint,
      required this.fillColor});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = fillColor
      ..style = paintingStyle
      ..strokeWidth = 5
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    Path path = Path();

    double w = size.width;
    double centerX = 100;
    double centerY = 100;
    double radius = w / 2;

    for (int i = 0; i < 6; i++) {
      double angle = pi / 3 * i + pi / 6;
      // precisa pra desse valor (0.01) minimo pra casos como 1,0,0,0,0,0,
      // se n o grafico seria so um ponto,mas isso afeta outros resultados,
      //TODO checar forma de mitigar isso, o que eles espera do resultado 1,0,0,0,0,0?

      double valueModifier = childrenStats[i];
      double x = centerX + radius * cos(angle) * valueModifier;
      double y = centerY + radius * sin(angle) * valueModifier;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// stats nunca pode ter só uma categoria, pq? Pq se n vira só um ponto, tem que ter valor minimo

// Pegar todas as stats da criança pro periodo e dps dividi-las em porcentagem

/*
Criança exemplo

  science exploration 8
  self regulation 8
  critical thinking 4
  childHood literacy 1
  love and kindness 45
  soft skills 15

  45 + 8 + 8 + 4 + 1 + 15 =  81

  science exploration 9,87%
  self regulation 9,87%
  critical thinking 4,93%
  childHood literacy 1,23%
  love and kindness 55,55%
  soft skills 18,51%

  science exploration 0.0987
  self regulation 0.0987
  critical thinking 0.0493
  childHood literacy 0.0123
  love and kindness 0.5555
  soft skills 0.1851

  //lembrar que o exemplo do grafico de barras n ta certo na screenshot do app
  //nem sempre esse grafico vai ser bom pra mostrar esses dados

*/
