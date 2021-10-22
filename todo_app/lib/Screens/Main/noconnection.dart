import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultBackgroundColour,
        body: Icon(
          Icons.signal_wifi_off_sharp,
        ),
      )
    );
  }
}
