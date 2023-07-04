import 'package:flutter/material.dart';
import 'package:quran_app/Pages/home.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Providers/TimePrayerProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TimePrayerProvider())],
      child: MaterialApp(
        initialRoute: "/",
        routes: {
          '/': (context) => const Home(),
        },
      ),
    ),
  );
}
