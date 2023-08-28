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

              const prayerNames = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
              final nextPrayerIndex = prayerNames
                  .indexOf(timePrayerProvider.nextPrayerTime.split(":")[0]);

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
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: index == nextPrayerIndex
                                ? Colors.white
                                : Color.fromARGB(255, 30, 42, 82),
                            width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      leading: Image.asset(
                        prayerImage,
                        width: 50,
                        height: 50,
                        color: Colors.white, // Customize the color as needed
                      ),
                      title: Row(
                        children: [
                          Text(
                            prayerName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(prayerFormattedTime),
                        ],
                      ),
                    ),
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
