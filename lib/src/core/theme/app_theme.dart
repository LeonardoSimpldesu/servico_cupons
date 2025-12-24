import 'package:flutter/material.dart';
import 'package:trying_flutter/src/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      scaffoldBackgroundColor: AppColors.background,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.foreground,
        
        secondary: AppColors.secondary,
        onSecondary: AppColors.white,
        
        surface: AppColors.background,
        onSurface: AppColors.foreground,

        error: Colors.red,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: AppColors.mutedForeground),
        hintStyle: const TextStyle(color: AppColors.mutedForeground),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.links, width: 2),
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
      ),

      dividerColor: AppColors.mutedForeground,
      dividerTheme: DividerThemeData(
        thickness: 0.5,
        color: AppColors.mutedForeground,
      ),
    );
  }
}