import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: TextTheme(
        headlineLarge: _headlineStyle,
        bodySmall: _bodySmallStyle,
        bodyMedium: _bodyMediumStyle,
      ),
      iconTheme: _iconTheme,
      dividerTheme: _dividerTheme,
    );
  }

  // Colors used across the app
  static const Color backgroundColor = Colors.black;
  static const Color primaryColor = Colors.greenAccent;
  static const Color errorColor = Colors.redAccent;
  static const Color warningColor = Colors.orange;
  static const Color secondaryTextColor = Colors.grey;
  static const Color cardBackgroundColor = Colors.white10;
  static const Color cardTextColor = Colors.white;
  static const Color dividerColor = Colors.white10;

  static Color get timelineLineColor => Colors.grey;
  static Color get timelineIndicatorColor => Colors.grey;
  static Color get pastTimelineLineColor => Colors.redAccent.withOpacity(0.5);
  static Color get pastTimelineIndicatorColor => Colors.redAccent;
  static Color get statusAllowedColor => Colors.greenAccent;
  static Color get statusNotAllowedColor => Colors.redAccent;
  static Color get polyLineColor => Colors.green;

  // Text styles used across the app
  static final TextStyle _headlineStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: cardTextColor,
  );

  static final TextStyle _bodySmallStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: cardTextColor,
  );

  static final TextStyle _bodyMediumStyle = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  );

  static final IconThemeData _iconTheme = IconThemeData(
    color: Colors.grey,
    size: 24,
  );

  static final DividerThemeData _dividerTheme = DividerThemeData(
    color: dividerColor,
    thickness: 1,
    space: 0,
  );

  // Additional Text Styles
  static TextStyle get timeTextStyle => _headlineStyle.copyWith(fontSize: 16);
  static TextStyle get bodyTextStyle => _bodySmallStyle.copyWith(fontSize: 14);
  static TextStyle get linkTextStyle =>
      _bodySmallStyle.copyWith(color: primaryColor);
  static TextStyle get errorTextStyle =>
      _bodySmallStyle.copyWith(color: errorColor);
  static TextStyle get warningTextStyle =>
      _bodySmallStyle.copyWith(color: warningColor);
}
