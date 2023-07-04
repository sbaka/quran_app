import 'package:flutter/material.dart';
import 'package:quran_app/Pages/home.dart';

void main() => runApp(
      MaterialApp(
        initialRoute: "/",
        routes: {
          '/': (context) => const Home(),
        },
      ),
    );
