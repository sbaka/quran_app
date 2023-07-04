import 'package:flutter/material.dart';

import '../Components/last_read.dart';
import '../Components/time_prayer_widget.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Row(
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.menu,
                    size: 24,
                    color: Color(0xffA19CC5),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Quran App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.search,
                    size: 24,
                    color: Color(0xffA19CC5),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const TimePrayerWidget(),
        const SizedBox(
          height: 15,
        ),
        const LastRead(),
      ],
    );
  }
}
