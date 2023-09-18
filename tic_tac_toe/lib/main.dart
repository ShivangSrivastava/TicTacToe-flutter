import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe Game',
      theme: ThemeData(
        fontFamily: GoogleFonts.pressStart2p().fontFamily,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const SplashPage(),
    );
  }
}
