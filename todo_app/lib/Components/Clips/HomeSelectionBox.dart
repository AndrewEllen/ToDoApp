import 'package:flutter/material.dart';

class HomeSelectionBoxClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    path.quadraticBezierTo(
        size.width / 3.8, size.height / 1.8, size.width / 1.93,
        size.height * 0.45);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.34, size.width, 0);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}


class HomeSelectionBoxShadowClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    Path path = Path();
    path.lineTo(0, size.height+20);

    path.quadraticBezierTo(
        size.width / 3.7, size.height / 1.78, size.width / 1.8,
        size.height * 0.45);
    path.quadraticBezierTo(size.width * 0.77, size.height * 0.29, size.width+12, 0);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {

    return true;
  }
}

class HomeSelectionBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = Color.fromRGBO(1, 1, 1, 1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal,1.6);

    Path path = Path();
    path.lineTo(0,size.height);

    path.quadraticBezierTo(size.width/3.8, size.height/1.8, size.width/1.93, size.height*0.45);
    path.quadraticBezierTo(size.width*0.7, size.height*0.34, size.width, 0);

    path.lineTo(size.width, 0);

    path.close();

    //canvas.drawShadow(path.shift(Offset(0,-3)), Colors.black, 6, true);
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
