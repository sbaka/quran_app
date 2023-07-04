import 'package:flutter/material.dart';
import 'package:quran_app/Pages/first_page.dart';
import 'package:quran_app/Pages/fourth_page.dart';
import 'package:quran_app/Pages/second_page.dart';
import 'package:quran_app/Pages/third_page.dart';

// to get location of user
// Modal for prayer Times
// https://pub.dev/packages/hijri to get the hijri date ( cause pi fiha probleme ta3 unicode )

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030c23),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPage,
        onDestinationSelected: (newDestination) {
          setState(
            () {
              selectedPage = newDestination;
            },
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.light),
            label: 'Mena',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Melhih',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            label: 'Eywa',
          ),
        ],
      ),
      body: [
        const FirstPage(),
        const SecondPage(),
        const ThirdPage(),
        const FourthPage(),
      ][selectedPage],
    );
  }
}
