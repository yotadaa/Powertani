import 'package:flutter/material.dart';
import 'package:powertani/env.dart';

class StdText extends StatelessWidget {
  final String text;
  final bool softWrap;
  final FontStyle fontStyle;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String font;

  // Text widget parameters
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final StrutStyle? strutStyle;

  const StdText({
    Key? key,
    required this.text,
    this.softWrap = true,
    this.fontStyle = FontStyle.normal,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w300,
    this.color = Colors.black,
    this.font = Fonts.primaryFont,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.strutStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: softWrap,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      strutStyle: strutStyle,
      style: TextStyle(
        fontFamily: font,
        fontStyle: fontStyle,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
