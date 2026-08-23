import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() => runApp(const MarketLensApp());

class MarketLensApp extends StatefulWidget {
  const MarketLensApp({super.key});
  @override State<MarketLensApp> createState() => _MarketLensAppState();
}

class _MarketLensAppState extends State<MarketLensApp> {
  ThemeMode mode = ThemeMode.dark;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'AI MarketLens', debugShowCheckedModeBanner: false, themeMode: mode,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffe36b3d), brightness: Brightness.light), textTheme: GoogleFonts.dmSansTextTheme(), useMaterial3: true),
    darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffe36b3d), brightness: Brightness.dark), scaffoldBackgroundColor: const Color(0xff111315), textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme), useMaterial3: true),
    home: HomeScreen(onToggleTheme: () => setState(() => mode = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark)),
  );
}
