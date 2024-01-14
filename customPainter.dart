import 'package:flutter/material.dart';

class Painter extends CustomPainter {
//  自訂畫筆
  final Paint _paint = Paint()
    ..color = Colors.red
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 4.0;

//繪製流程
  @override
  void paint(Canvas canvas, Size size) {
    Offset p1 = Offset((size.width / 2) - 10, (size.height / 2) - 40);
    Offset p2 = Offset((size.width / 2) + 10, (size.height / 2) - 40);
    Offset p3 = Offset(size.width / 2, (size.height / 2) - 50);
    Offset p4 = Offset(size.width / 2, (size.height / 2) - 30);

    canvas.drawLine(p1, p2, _paint);
    canvas.drawLine(p3, p4, _paint);
  }

//刷新佈局時重新繪製
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LeftfacePainter extends CustomPainter {
//  自訂畫筆
  final Paint _paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = true
    ..strokeWidth = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Path path = new Path()..moveTo(size.width/2, size.height/2);
    Path path1 = Path()..moveTo(size.width / 2 + 100, size.height / 2 - 135);

    //耳朵
    path1.quadraticBezierTo(size.width / 2 + 150, size.height / 2 - 170,
        size.width / 2 + 180, size.height / 2 - 100);
    path1.cubicTo(
        size.width / 2 + 200,
        size.height / 2 - 50,
        size.width / 2 + 160,
        size.height / 2 - 50,
        size.width / 2 + 100,
        size.height / 2 + 20);

    //鼻子
    Path path2 = Path()..moveTo(size.width / 2 - 150, size.height / 2 - 100);

    path2.cubicTo(
        size.width / 2 - 200,
        size.height / 2 - 50,
        size.width / 2 - 200,
        size.height / 2 - 50,
        size.width / 2 - 150,
        size.height / 2 - 30);

    canvas.drawPath(path1, _paint);
    canvas.drawPath(path2, _paint);
  }

//刷新佈局時重新繪製
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MiddlefacePainter extends CustomPainter {
//  自訂畫筆
  final Paint _paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = true
    ..strokeWidth = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    //鼻子右
    Path path1 = Path()..moveTo(size.width / 2 + 40, size.height / 2 - 150);

    path1.quadraticBezierTo(size.width / 2 + 35, size.height / 2 - 100,
        size.width / 2 + 50, size.height / 2 - 75);
    path1.quadraticBezierTo(size.width / 2 + 95, size.height / 2 - 10,
        size.width / 2 + 30, size.height / 2 - 10);

    //鼻子左
    Path path2 = Path()..moveTo(size.width / 2 - 40, size.height / 2 - 150);

    path2.quadraticBezierTo(size.width / 2 - 35, size.height / 2 - 100,
        size.width / 2 - 50, size.height / 2 - 75);
    path2.quadraticBezierTo(size.width / 2 - 95, size.height / 2 - 10,
        size.width / 2 - 30, size.height / 2 - 10);

    canvas.drawPath(path1, _paint);
    canvas.drawPath(path2, _paint);
  }

//刷新佈局時重新繪製
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RightfacePainter extends CustomPainter {
//  自訂畫筆
  final Paint _paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = true
    ..strokeWidth = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Path path = new Path()..moveTo(size.width/2, size.height/2);
    Path path1 = Path()..moveTo(size.width / 2 - 100, size.height / 2 - 135);

    //耳朵
    path1.quadraticBezierTo(size.width / 2 - 150, size.height / 2 - 170,
        size.width / 2 - 180, size.height / 2 - 100);
    path1.cubicTo(
        size.width / 2 - 200,
        size.height / 2 - 50,
        size.width / 2 - 160,
        size.height / 2 - 50,
        size.width / 2 - 100,
        size.height / 2 + 20);

    //鼻子
    Path path2 = Path()..moveTo(size.width / 2 + 150, size.height / 2 - 100);

    path2.cubicTo(
        size.width / 2 + 200,
        size.height / 2 - 50,
        size.width / 2 + 200,
        size.height / 2 - 50,
        size.width / 2 + 150,
        size.height / 2 - 30);

    canvas.drawPath(path1, _paint);
    canvas.drawPath(path2, _paint);
  }

//刷新佈局時重新繪製
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
