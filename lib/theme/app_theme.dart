import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color white = Color(0xFFFEFEFE);
  static const Color darkRed = Color(0xFF5E020E);
  static const Color mediumRed = Color(0xFF8E3027);
  static const Color darkGray = Color(0xFF424952);
  static const Color black = Color(0xFF000000);

  // Shades and Variations
  static const Color darkRedLight = Color(0xFF7A1A1C);
  static const Color mediumRedLight = Color(0xFFA84C3F);
  static const Color darkGrayLight = Color(0xFF5E6370);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color borderGray = Color(0xFFE0E0E0);

  // Accent Colors
  static const Color accentBlue = Color(0xFF1E88E5);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFFA726);
  static const Color errorRed = Color(0xFFE53935);

  // Overlay & Shadow
  static const Color shadowBlack = Color(0x26000000);
  static const Color overlayBlack = Color(0x4D000000);
}

/// Common breakpoints for responsive layout
class AppBreakpoints {
  static const double mobile = 600; // phones
  static const double tablet = 1024; // tablets
  // desktop: anything >= tablet
}

class AppTheme {
  // Responsive helper: choose value based on width
  static T _responsive<T>(BuildContext context, T mobile, T tablet, T desktop) {
    final w = MediaQuery.of(context).size.width;
    if (w < AppBreakpoints.mobile) return mobile;
    if (w < AppBreakpoints.tablet) return tablet;
    return desktop;
  }

  // Typography sizes (responsive)
  static TextTheme textThemeFromContext(BuildContext context) {
    final h1 = _responsive(context, 22.0, 28.0, 36.0);
    final h2 = _responsive(context, 20.0, 24.0, 30.0);
    final h3 = _responsive(context, 18.0, 20.0, 24.0);
    final body = _responsive(context, 14.0, 15.0, 16.0);
    final caption = _responsive(context, 12.0, 13.0, 14.0);
    final button = _responsive(context, 14.0, 15.0, 16.0);

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: h1,
        fontWeight: FontWeight.w800,
        color: AppColors.darkGray,
        height: 1.15,
      ),
      headlineLarge: TextStyle(
        fontSize: h2,
        fontWeight: FontWeight.w700,
        color: AppColors.darkGray,
        height: 1.18,
      ),
      headlineMedium: TextStyle(
        fontSize: h3,
        fontWeight: FontWeight.w700,
        color: AppColors.darkGray,
      ),
      bodyLarge: TextStyle(
        fontSize: body,
        fontWeight: FontWeight.w400,
        color: AppColors.darkGray,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: body - 1,
        fontWeight: FontWeight.w400,
        color: AppColors.darkGrayLight,
        height: 1.45,
      ),
      bodySmall: TextStyle(
        fontSize: caption,
        fontWeight: FontWeight.w500,
        color: AppColors.darkGrayLight,
      ),
      labelLarge: TextStyle(
        fontSize: button,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: 0.6,
      ),
    );
  }

  // Logo sizes
  static double logoSize(BuildContext context, {String variant = 'large'}) {
    final sizes = {
      'large': _responsive(context, 80.0, 120.0, 180.0),
      'medium': _responsive(context, 48.0, 72.0, 96.0),
      'small': _responsive(context, 28.0, 40.0, 56.0),
    };
    return sizes[variant] ?? sizes['large']!;
  }

  // Page padding
  static EdgeInsets pagePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: _responsive(context, 12.0, 24.0, 48.0),
      vertical: _responsive(context, 12.0, 16.0, 24.0),
    );
  }

  // Card (ads) sizes — returns recommended Size for ad/card components
  static Size adCardSize(BuildContext context, {String variant = 'regular'}) {
    final w = MediaQuery.of(context).size.width;
    if (w >= AppBreakpoints.tablet) {
      // desktop/tablet
      switch (variant) {
        case 'large':
          return const Size(420, 260);
        case 'wide':
          return const Size(720, 200);
        default:
          return const Size(320, 200);
      }
    }

    // mobile
    switch (variant) {
      case 'large':
        return const Size(320, 220);
      case 'wide':
        return const Size(300, 140);
      default:
        return const Size(280, 160);
    }
  }

  // Button sizes and styles
  static double buttonHeight(BuildContext context, {bool large = false}) {
    return _responsive(
      context,
      large ? 52.0 : 44.0,
      large ? 56.0 : 48.0,
      large ? 64.0 : 56.0,
    );
  }

  static ButtonStyle primaryButtonStyle(
    BuildContext context, {
    bool large = false,
  }) {
    return ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, buttonHeight(context, large: large)),
      backgroundColor: AppColors.darkRed,
      foregroundColor: AppColors.white,
      elevation: 4,
      shadowColor: AppColors.shadowBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      textStyle: textThemeFromContext(context).labelLarge,
      padding: EdgeInsets.symmetric(
        horizontal: _responsive(context, 12, 16, 20),
      ),
    );
  }

  static ButtonStyle ghostButtonStyle(
    BuildContext context, {
    bool large = false,
  }) {
    return OutlinedButton.styleFrom(
      minimumSize: Size(double.infinity, buttonHeight(context, large: large)),
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.darkRed,
      side: BorderSide(color: AppColors.darkRed, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      textStyle: textThemeFromContext(
        context,
      ).labelLarge!.copyWith(color: AppColors.darkRed),
      padding: EdgeInsets.symmetric(
        horizontal: _responsive(context, 12, 16, 20),
      ),
    );
  }

  // Light ThemeData (non-responsive core theme)
  static ThemeData themeData() {
    final base = ThemeData.light();
    final colorScheme = ColorScheme.light(
      primary: AppColors.darkRed,
      secondary: AppColors.accentBlue,
      surface: AppColors.white,
      error: AppColors.errorRed,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.darkGray,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: AppColors.darkRed,
      scaffoldBackgroundColor: AppColors.white,
      dividerColor: AppColors.borderGray,
      cardColor: AppColors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.darkGray,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.darkGray),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkRed),
      ),
    );
  }
}

/// Usage notes (examples):
/// - Use `AppTheme.textThemeFromContext(context)` to obtain responsive typography.
/// - Use `AppTheme.primaryButtonStyle(context)` for primary buttons.
/// - Use `AppTheme.pagePadding(context)` for consistent page padding.
/// - Use `AppTheme.adCardSize(context)` to size ad cards responsively.
