import 'package:flutter/material.dart';
import 'package:quran_app/Components/timePrayerList_widget.dart';
import 'package:quran_app/Components/timePrayer_widget.dart';
import 'package:quran_app/Pages/SearchPage.dart';

class TimePrayerPage extends StatefulWidget {
  const TimePrayerPage({super.key});

  @override
  State<TimePrayerPage> createState() => _TimePrayerPageState();
}

class _TimePrayerPageState extends State<TimePrayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: Text("")),
      appBar: AppBar(
        title: const Text(
          'Time Prayer',
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
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          pinned: true,
          centerTitle: false,
          stretch: true,
          automaticallyImplyLeading: false,
          expandedHeight: 300.0,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [StretchMode.zoomBackground],
            background: TimePrayerWidget(),
          ),
        ),
        TimePrayerList()
      ]),
    );
  }
}
