import 'package:flutter/material.dart';
import 'package:quran_app/Pages/Home.dart';

void main() => runApp(MaterialApp(
      initialRoute: "/",
      routes: {
        '/': (context) => const Home(),
      },
    ));
