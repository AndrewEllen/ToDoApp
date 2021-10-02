import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({required this.appbaraccentcolour, required this.appbarcolour, required this.appbartitle});

  final Color appbaraccentcolour, appbarcolour;
  final String appbartitle;
  final Size preferredSize = Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        backgroundColor: appbarcolour,
        leading: null,
        title: Center(
          child: Container(
            margin: EdgeInsets.only(right:40),
            child: Text(
                appbartitle,
              style: TextStyle(
                color: appbaraccentcolour,
                fontWeight: FontWeight.w400,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black,
                    offset: Offset(0,2),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
