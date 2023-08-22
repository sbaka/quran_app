import 'package:flutter/material.dart';
import 'package:quran_app/Pages/SearchPage.dart';
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
      drawer: const Drawer(child: Text("")),
      appBar: AppBar(
        title: const Text(
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPage(),
              );
            },
            child: const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.search,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xff030c23),
      bottomNavigationBar: NavigationBar(
        height: 80,
        backgroundColor: const Color(0xFF121931),
        selectedIndex: selectedPage,
        onDestinationSelected: (newDestination) {
          setState(
            () {
              selectedPage = newDestination;
            },
          );
        },
        indicatorColor: Colors.transparent,
        destinations: [
          Center(
            child: NavigationDestination(
              icon: Icon(
                Icons.home,
                size: 32,
                color: selectedPage == 0
                    ? const Color(0xFFA44AFF)
                    : const Color(0xffA19CC5),
              ),
              label: '',
            ),
          ),
          Center(
            child: NavigationDestination(
              icon: Icon(
                Icons.light,
                color: selectedPage == 1
                    ? const Color(0xFFA44AFF)
                    : const Color(0xffA19CC5),
                size: 32,
              ),
              label: '',
            ),
          ),
          Center(
            child: NavigationDestination(
              icon: Icon(
                Icons.home,
                size: 32,
                color: selectedPage == 2
                    ? const Color(0xFFA44AFF)
                    : const Color(0xffA19CC5),
              ),
              label: '',
            ),
          ),
          Center(
            child: NavigationDestination(
              icon: Icon(
                Icons.bookmark_border,
                size: 32,
                color: selectedPage == 3
                    ? const Color(0xFFA44AFF)
                    : const Color(0xffA19CC5),
              ),
              label: '',
            ),
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
