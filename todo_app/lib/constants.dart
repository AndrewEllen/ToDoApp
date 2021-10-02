import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//Supabase
final supabase = Supabase.instance.client;

//Screens
const Color defaultBackgroundColour = Color.fromRGBO(38, 38, 38, 1.0);
const Color WorkoutsAccentColour = Color.fromRGBO(236, 38, 38, 1.0);
const Color DietAccentColour = Color.fromRGBO(27, 123, 0, 1.0);
const Color OtherAccentColour = Color.fromRGBO(50, 119, 250, 1.0);
const Color defaultLoginBackgroundColour = Color(0XFF181818);

//HomeScreen

const double boxSelectionHeight = double.infinity;

const Color workoutsTintColour = Color.fromRGBO(255, 1, 1, 0.25);
const Color dietTintColour = Color.fromRGBO(32, 142, 26, 0.25);

const boxSelectionDecoration = BoxDecoration(
  color: Colors.white70,
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
  boxShadow: [
    BoxShadow(
      color: Color.fromRGBO(1, 1, 1, 0.75),
      spreadRadius: 2,
      blurRadius: 5,
      offset: Offset(0, 8),
    )
  ],
);

//AppBar
const Color AppbarColour = Color.fromRGBO(50, 50, 50, 1.0);
const Color HomeAppbarColour = Color.fromRGBO(33, 33, 33, 1.0);

//SideBar
const Color SideBarColour = Color.fromRGBO(50, 50, 50, 1.0);

// SideBar Menu
const TextStyle sideBarMenuTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);
const EdgeInsets sideBarMenuMargin = EdgeInsets.only(
  top: 3,
  left: 10,
  right: 10,
  bottom: 30,
);

// TextBuilder

const TextStyle textBuilderTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w300,
  color: Colors.white,
  decoration: TextDecoration.underline,
  decorationColor: Colors.white,
);
const EdgeInsets textBuilderContainerMargin = EdgeInsets.only(
  top: 2.5,
  bottom: 2.5,
);
const double textBuilderHeight = 30;
const double textBuilderWidth = double.infinity;
