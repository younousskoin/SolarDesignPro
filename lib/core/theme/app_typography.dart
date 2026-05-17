import 'package:flutter/material.dart';

class AppTypography {
  static const String _font = "Manrope";

  // ---------------------------------------------------------
  // TITRES (H1 → H6)
  // ---------------------------------------------------------
  static const TextStyle h1 = TextStyle(
    fontFamily: _font,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _font,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle h5 = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle h6 = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // ---------------------------------------------------------
  // CORPS DE TEXTE
  // ---------------------------------------------------------
  static const TextStyle body = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static const TextStyle bodyLight = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.black54,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  // ---------------------------------------------------------
  // LABELS / FORM FIELDS
  // ---------------------------------------------------------
  static const TextStyle label = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  static const TextStyle labelBold = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  // ---------------------------------------------------------
  // BOUTONS
  // ---------------------------------------------------------
  static const TextStyle button = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // ---------------------------------------------------------
  // CAPTIONS / PETITS TEXTES
  // ---------------------------------------------------------
  static const TextStyle caption = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.black54,
  );

  static const TextStyle captionBold = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
}
