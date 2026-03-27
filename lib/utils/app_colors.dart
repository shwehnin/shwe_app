import 'package:flutter/material.dart';

/// AppColors — single source of truth for every color used in the app.
///
/// Usage:  AppColors.success  /  AppColors.cardColor(isDark)
class AppColors {
  AppColors._();

  // ── Brand ─────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF3B2A7A);
  static const Color primaryDark = Color(0xFF002323);
  static const Color lightTint = Color(0xFFE8EDF8);
  static const Color secondary = Color(0xFF7C62CC);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF0EA5E9);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color indigo = Color(0xFF6366F1);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color orange = Color(0xFFF97316);
  static const Color lime = Color(0xFF84CC16);
  static const Color gold = Color(0xFFE8C547);
  static const Color darkGold = Color(0xFFB8860B);

  // ── Scratch gold gradient ─────────────────────────────────────────────────
  static const Color scratchGold1 = Color(0xFFFFD700);
  static const Color scratchGold2 = Color(0xFFFFF9C4);
  static const Color scratchGold3 = Color(0xFFFFAB00);
  static const Color lightText = Color(0xFFD4BAFF);
  static const Color cardBg = Color(0xFF1E1542);
  static const Color surface = Color(0xFF150F2E);

  // ── Dark surfaces ─────────────────────────────────────────────────────────
  static const Color darkBg = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkCard = Color(0xFF1A1A1A);
  static const Color darkCard2 = Color(0xFF1C2333);
  static const Color darkCard3 = Color(0xFF1E1E1E);
  static const Color darkCard4 = Color(0xFF1A2130);
  static const Color darkCard5 = Color(0xFF1E1E2A);
  static const Color darkCardDeep = Color(0xFF0D0D0D);
  static const Color deepNavy = Color(0xFF1A1A2E);

  // ── Light surfaces ────────────────────────────────────────────────────────
  static const Color lightBg = Color(0xFF0D0A1A);
  static const Color lightBg2 = Color(0xFFF5F5F5);
  static const Color lightBg3 = Color(0xFFF8F8F8);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMid = Color(0xFF374151);
  static const Color textMuted = Color(0xFF8E8E93);
  static const Color nearBlack = Color(0xFF111111);

  // ── Calendar tints ────────────────────────────────────────────────────────
  static const Color calRedDark = Color(0xFF2D1515);
  static const Color calRedLight = Color(0xFFFFF0F0);
  static const Color calAmberDark = Color(0xFF2A2200);
  static const Color calAmberLight = Color(0xFFFFFBEB);

  // ── Chat ─────────────────────────────────────────────────────────────────
  static const Color chatBubble = Color(0xFFE5E5EA);

  // ── AdMob ────────────────────────────────────────────────────────────────
  static const Color adDarkBg = Color(0xFF141414);
  static const Color adDarkCard = Color(0xFF232323);
  static const Color adLightCard = Color(0xFFF4F4F4);
  static const Color adSubDark = Color(0xFF888888);
  static const Color adSubLight = Color(0xFF999999);
  static const Color adTextDark = Color(0xFF333333);

  // ── Misc ─────────────────────────────────────────────────────────────────
  static const Color transparent = Color(0x00000000);

  // ── Helpers ──────────────────────────────────────────────────────────────
  static Color cardColor(bool isDark) => isDark ? darkSurface : Colors.white;
  static Color cardColor2(bool isDark) => isDark ? darkCard : Colors.white;
  static Color scaffoldColor(bool isDark) => isDark ? darkBg : lightBg;

  static Color red = Colors.red;
}
