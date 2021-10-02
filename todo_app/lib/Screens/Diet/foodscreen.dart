import 'package:flutter/material.dart';
import 'package:workout_app/Components/Navbar/Navbar.dart';
import '../../constants.dart';

class FoodListScreen extends StatefulWidget {
  FoodListScreen(
      {required this.appbartitle});
  final String appbartitle;

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultBackgroundColour,
        appBar: CustomAppBar(
          appbaraccentcolour: DietAccentColour,
          appbarcolour: AppbarColour,
          appbartitle: widget.appbartitle,
        ),
      ),
    );
  }
}
