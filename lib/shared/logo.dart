import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'H',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.body1,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Colors.orange[100],
        ),
        children: [
          TextSpan(
            text: 'per',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
          TextSpan(
            text: 'Garage',
            style: TextStyle(color: Colors.orange[100], fontSize: 30),
          ),
        ],
      ),
    );
  }
}
