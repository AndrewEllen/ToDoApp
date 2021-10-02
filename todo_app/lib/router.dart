import 'package:flutter/material.dart';

class FadeRouter extends PageRouteBuilder {
  final Widget screen;

  FadeRouter({required this.screen, required String routeName})
      : super(
    settings: RouteSettings(name: routeName),
    pageBuilder: (
        BuildContext context,
        Animation<double> firstAnimation,
        Animation<double> secondAnimation,
        ) =>
    screen,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> firstAnimation,
        Animation<double> secondAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: firstAnimation,
          child: child,
        ),
    transitionDuration: Duration(milliseconds: 200),
  );
}