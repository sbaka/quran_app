import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

Future _getTodayInfo() async {
  final apiURL =
      'http://api.aladhan.com/v1/calendarByAddress/2017/4?address=Sultanahmet Mosque, Istanbul, Turkey&method=2';

  final response = await http.get(Uri.parse(apiURL));
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    print(jsonResponse);
  } else
    print("toza");
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _getTodayInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage("assets/Images/Quran.png"),
                alignment: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFDF98FA),
                Color(0xFF9055FF),
              ],
            ),
          ),
          width: 327,
          height: 257,
          child: Column(children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("3 Dhu al-Hijjah 1444",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Text(
                      DateFormat('hh:mm').format(DateTime.now()),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 35),
                    );
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fajr',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Dohr',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Asr',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Maghrib',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Isha',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
