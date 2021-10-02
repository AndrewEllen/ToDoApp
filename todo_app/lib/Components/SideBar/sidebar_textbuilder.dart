import "package:flutter/material.dart";
import '../../constants.dart';
import '../../router.dart';

class TextBuilder extends StatelessWidget {
  TextBuilder(
      {required this.containerTitle, required this.settingsText, required this.containerRouteName, required this.containerroutewidget});
  final String containerTitle, settingsText, containerRouteName;
  final Widget containerroutewidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: textBuilderContainerMargin,
            alignment: Alignment.centerLeft,
            width: textBuilderWidth,
            height: textBuilderHeight,
            child: new GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    FadeRouter(
                      routeName: containerRouteName,
                      screen: containerroutewidget,
                    )
                );
              },
              child: Text(
                settingsText,
                style: textBuilderTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
