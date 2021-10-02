import 'package:flutter/material.dart';

class HomeAppBarClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    
    Path path = Path();
    path.lineTo(0,size.height);

    path.quadraticBezierTo(size.width/2, size.height - 80, size.width, size.height);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {

    return true;
  }
}

class HomeAppBarShadowClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    Path path = Path();
    path.lineTo(0,size.height+10);

    path.quadraticBezierTo(size.width/2, size.height - 75, size.width+10, size.height+13);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {

    return true;
  }
}

class HomeAppBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = Color.fromRGBO(1, 1, 1, 1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal,1.6);

    Path path = Path();
    path.lineTo(0,size.height);

    path.quadraticBezierTo(size.width/2, size.height - 80, size.width, size.height);

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
