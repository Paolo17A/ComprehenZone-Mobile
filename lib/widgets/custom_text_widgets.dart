import 'package:comprehenzone_mobile/utils/color_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text interText(String label,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow}) {
  return Text(
    label,
    textAlign: textAlign,
    overflow: overflow,
    style: GoogleFonts.inter(
        fontSize: fontSize, fontWeight: fontWeight, color: color),
  );
}

Text helveticaText(String label,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow}) {
  return Text(
    label,
    textAlign: textAlign,
    overflow: overflow,
    style: GoogleFonts.arimo(
        fontSize: fontSize, fontWeight: fontWeight, color: color),
  );
}

Text impactText(String label,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow}) {
  return Text(
    label,
    textAlign: textAlign,
    overflow: overflow,
    style: GoogleFonts.oswald(
        fontSize: fontSize, fontWeight: fontWeight, color: color),
  );
}

Text blackHelveticaBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? overflow,
    TextDecoration? textDecoration}) {
  return helveticaText(label,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      textAlign: textAlign,
      overflow: overflow);
}

Text blackImpactBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? overflow,
    TextDecoration? textDecoration}) {
  return impactText(label,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      textAlign: textAlign,
      overflow: overflow);
}

Text whiteImpactBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? overflow,
    TextDecoration? textDecoration}) {
  return impactText(label,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      textAlign: textAlign,
      overflow: overflow);
}

Text lightGreenImpactBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? overflow,
    TextDecoration? textDecoration}) {
  return impactText(label,
      color: CustomColors.lightGreen,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      textAlign: textAlign,
      overflow: overflow);
}

Text cyanHelveticaBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? overflow,
    TextDecoration? textDecoration}) {
  return helveticaText(label,
      color: CustomColors.paleCyan,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      textAlign: textAlign,
      overflow: overflow);
}

Text whiteInterRegular(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      style: GoogleFonts.inter(
          fontSize: fontSize,
          color: Colors.white,
          decoration: textDecoration,
          decorationColor: Colors.white));
}

Text whiteInterBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      style: GoogleFonts.inter(
          fontSize: fontSize,
          color: Colors.white,
          decoration: textDecoration,
          fontWeight: FontWeight.bold));
}

Text blackInterBold(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? overflow,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      overflow: overflow,
      style: GoogleFonts.inter(
          fontSize: fontSize,
          color: Colors.black,
          decoration: textDecoration,
          fontWeight: FontWeight.bold));
}

Text blackInterRegular(String label,
    {double? fontSize,
    TextAlign textAlign = TextAlign.center,
    TextOverflow? overflow,
    TextDecoration? textDecoration}) {
  return Text(label,
      textAlign: textAlign,
      overflow: overflow,
      style: GoogleFonts.inter(
          fontSize: fontSize, color: Colors.black, decoration: textDecoration));
}
