import 'package:flutter/material.dart';
import 'package:quran_app/Components/souratList_widget.dart';
import 'package:quran_app/Pages/SearchPage.dart';

import '../Components/lastRead_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: const Column(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: LastRead(),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: SouraWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
