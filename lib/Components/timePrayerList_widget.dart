import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/TimePrayerProvider.dart';

class TimePrayerList extends StatefulWidget {
  const TimePrayerList({super.key});

  @override
  State<TimePrayerList> createState() => _TimePrayerListState();
}

class _TimePrayerListState extends State<TimePrayerList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimePrayerProvider>(
      builder: (context, timePrayerProvider, _) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final prayerTime = timePrayerProvider
                  .times; // Access the times from the provider

              final prayerName = [
                'Fajr',
                'Dhuhr',
                'Asr',
                'Maghrib',
                'Isha',
              ][index];

              final prayerImage = [
                'assets/Images/fajr.png',
                'assets/Images/dhuhr.png',
                'assets/Images/asr.png',
                'assets/Images/maghreb.png',
                'assets/Images/isha.png',
              ][index];

              final prayerFormattedTime = [
                prayerTime.fajr,
                prayerTime.dhuhr,
                prayerTime.asr,
                prayerTime.maghrib,
                prayerTime.isha,
              ][index];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: ListTile(
                      leading: Image.asset(
                        prayerImage,
                        width: 50,
                        height: 50,
                        color: Colors.white, // Customize the color as needed
                      ),
                      title: Text(
                        prayerName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(prayerFormattedTime),
                    ),
                  ),
                  Divider(
                    thickness: 0.8,
                    indent: 15,
                    endIndent: 10,
                    color: const Color(0xff7B80AD).withOpacity(0.35),
                  ),
                ],
              );
            },
            childCount: 5, // Assuming you have 5 prayer times
          ),
        );
      },
    );
  }
}
