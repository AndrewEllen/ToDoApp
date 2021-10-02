import 'package:flutter/material.dart';
import 'package:workout_app/Components/Clips/HomeSelectionBox.dart';
import 'package:workout_app/constants.dart';
import '../../router.dart';

class HomeSelectionBox extends StatelessWidget {
  HomeSelectionBox({
    required this.containertext,
    required this.containerroutename,
    required this.containerimageloc,
    required this.tintcolour,
    required this.containerroutewidget,
    required this.clip,
  });

  final String containertext, containerroutename, containerimageloc;
  final bool clip;
  final Widget containerroutewidget;
  final Color tintcolour;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: clip ? HomeSelectionBoxShadowClip() : null,
      child: CustomPaint(
        painter: clip ? HomeSelectionBoxPainter() : null,
        child: ClipPath(
          clipper: clip ? HomeSelectionBoxClip() : null,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  FadeRouter(
                    routeName: containerroutename,
                    screen: containerroutewidget,
                  ));
            },
            child: Container(
                decoration: boxSelectionDecoration,
                height: boxSelectionHeight,
               child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter:
                                ColorFilter.mode(tintcolour, BlendMode.screen),
                            image: ExactAssetImage(containerimageloc),
                          ),
                        ),
                      ),
                    ),
                    Center(
                        child: Text(
                      "", //containertext,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 37,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            blurRadius: 1,
                            color: Colors.black,
                            offset: Offset(1, 5),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }
}
