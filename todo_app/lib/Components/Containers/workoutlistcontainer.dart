import 'package:flutter/material.dart';
import '../../constants.dart';

class WorkoutListContainer extends StatelessWidget {
  WorkoutListContainer ({required this.workout, required this.margin});
  late String workout;
  late double margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: margin),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppbarColour,
        //border: Border.all(width:0.5, color: Colors.black),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(1, 1, 1, 0.75),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 0),
          )
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(top: 15, left: 10, bottom: 10,right:10),
        child: Text(
          workout,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
