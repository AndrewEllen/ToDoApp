import "package:flutter/material.dart";
import '../../constants.dart';
import 'sidebar_textbuilder.dart';

class SideBarMenu extends StatelessWidget {
  SideBarMenu({required this.containerTitle, required this.sideBarText});
  final String containerTitle;
  final List sideBarText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: defaultBackgroundColour,
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              containerTitle,
              style: sideBarMenuTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: double.infinity,
            margin: sideBarMenuMargin,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    itemCount: sideBarText.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return TextBuilder(
                        containerTitle: containerTitle,
                        settingsText: '${sideBarText[index].settingsText}',
                        containerRouteName: '${sideBarText[index].textLink}',
                        containerroutewidget: sideBarText[index].routerWidget ,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
