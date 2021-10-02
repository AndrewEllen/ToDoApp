import 'package:flutter/material.dart';
import 'package:workout_app/constants.dart';

class DietMealBox extends StatefulWidget {
  DietMealBox(
      {required this.boxheading, required this.headingcontent, required this.marginsize});
  late final boxheading;
  late final headingcontent;
  late final double marginsize;
  @override

  _DietMealBoxState createState() => _DietMealBoxState();
}

class _DietMealBoxState extends State<DietMealBox> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: widget.marginsize),
          width: double.infinity,
          height: 80,
          padding: EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 100,
            right: 100,
          ),
          color: AppbarColour,
          child: Center(
            child: Text(
              '${widget.boxheading}:\n${widget.headingcontent}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,

              ),
            ),
          ),
        ),
      ),
    );
  }
}
