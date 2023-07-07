import 'package:flutter/material.dart';
import 'package:quran_app/Pages/home.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Pages/quran_reading_page.dart';
import 'package:quran_app/Providers/TimePrayerProvider.dart';
import 'package:quran_app/Providers/sourat_Provider..dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TimePrayerProvider()), ChangeNotifierProvider(create: (_) => SouratProvider())],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          scaffoldBackgroundColor: const Color(0xff030c23),
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFA44AFF),
            background: Color(0xff030c23),
          ),
        ),
        initialRoute: "/",
        routes: {
          '/': (context) => const Home(),
          QuranReadingPage.route: (context) => const QuranReadingPage(),
        },
      ),
    ),
  );
}
