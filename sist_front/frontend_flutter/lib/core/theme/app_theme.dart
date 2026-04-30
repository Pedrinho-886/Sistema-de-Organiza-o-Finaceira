import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Paleta Sage Light (Original - Default)
  static const Color lightBackground = Colors.white; // Fundo limpo e branco
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(0xFF3B4953);    // Navy original
  static const Color lightSecondary = Color(0xFF5A7863);  // Sage escuro
  static const Color lightAccent = Color(0xFF90AB8B);     // Sage claro

  // --- COMPATIBILIDADE ---
  static const Color background = lightBackground;
  static const Color primary = lightPrimary;
  static const Color secondary = lightSecondary;
  static const Color accent = lightAccent;

  // Definição de Texto com Google Fonts (Outfit)
  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return GoogleFonts.outfitTextTheme(base).copyWith(
      displayLarge: GoogleFonts.outfit(color: textColor, fontWeight: FontWeight.bold, fontSize: 32),
      titleLarge: GoogleFonts.outfit(color: textColor, fontWeight: FontWeight.bold, fontSize: 24),
      bodyLarge: GoogleFonts.outfit(color: textColor, fontSize: 16),
      bodyMedium: GoogleFonts.outfit(color: textColor, fontSize: 14),
      titleMedium: GoogleFonts.outfit(color: textColor, fontSize: 16), // Usado nos TextFields
    );
  }

  // --- Tema Único (Claro/Sage) ---
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAF9), // Cinza bem sutil pro fundo
      primaryColor: lightPrimary,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        surface: lightSurface,
        background: lightBackground,
        error: Colors.redAccent,
        onSurface: Color(0xFF3B4953),
      ),
      textTheme: _buildTextTheme(ThemeData.light().textTheme, lightPrimary),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: lightPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightSecondary, 
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: lightSecondary.withOpacity(0.3),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightSecondary,
          textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: lightSecondary, width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF5A7863)), 
        hintStyle: const TextStyle(color: Colors.black38),
        prefixIconColor: const Color(0xFF5A7863), 
        suffixIconColor: const Color(0xFF5A7863),
      ),
    );
  }
}
