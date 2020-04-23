import 'dart:math';
import 'package:flutter/material.dart';
import 'customClipper.dart';
import '../theme/light_color.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: -pi / 3.5,
        child: ClipPath(
          clipper: ClipPainter(),
          child: Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [LightColor.lightOrange, LightColor.darkOrange],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
