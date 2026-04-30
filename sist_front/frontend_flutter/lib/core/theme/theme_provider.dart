import 'package:flutter/material.dart';

// Variável global centralizada para gerenciar o tema atual de forma simples e livre de problemas de importação.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
