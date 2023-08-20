import 'package:flutter/material.dart';
import 'package:quran_app/Pages/home.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Pages/quran_reading_page.dart';
import 'package:quran_app/Providers/TimePrayerProvider.dart';
import 'package:quran_app/Providers/last_Read_Provider.dart';
import 'package:quran_app/Providers/sourat_Provider.dart';
import 'package:quran_app/Providers/verses_Provide.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Hive/lastReadAdapter.dart';
import 'Providers/QiblahCompass_Provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(LastReadAdapter()); // Register the adapter

  await Hive.openBox<String>('lastReadBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimePrayerProvider()),
        ChangeNotifierProvider(create: (_) => SouratProvider()),
        ChangeNotifierProvider(create: (_) => VersesProvider()),
        ChangeNotifierProvider(create: (_) => LastReadProvider()),
        ChangeNotifierProvider(create: (_) => QiblahCompassProvider()),
      ],
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
