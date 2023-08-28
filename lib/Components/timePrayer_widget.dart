import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Providers/TimePrayerProvider.dart';

class TimePrayerWidget extends StatefulWidget {
  const TimePrayerWidget({
    super.key,
  });

  @override
  State<TimePrayerWidget> createState() => _TimePrayerWidgetState();
}

class _TimePrayerWidgetState extends State<TimePrayerWidget> {
  //Variables :
  late HijriCalendar _today;

  @override
  void initState() {
    super.initState();
    _today = HijriCalendar.now();
    final dataProvider =
        Provider.of<TimePrayerProvider>(context, listen: false);
    dataProvider.getMyData();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> prayerImageMap = {
      'fajr': 'assets/Images/fajr.png',
      'dhuhr': 'assets/Images/dhuhr.png',
      'asr': 'assets/Images/asr.png',
      'maghrib': 'assets/Images/maghreb.png',
      'isha': 'assets/Images/isha.png',
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/Images/QuranOpacitylow.png"),
            alignment: Alignment.bottomRight,
          ),
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
        width: 350,
        height: 280,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${_today.toFormat("dd MMMM yyyy").toString()}'",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Text(
                      DateFormat('HH:mm').format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 35,
                      ),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: Consumer<TimePrayerProvider>(
                builder: (context, dataProvider, _) {
                  if (dataProvider.isLoading) {
                    return const CircularProgressIndicator();
                  } else if (dataProvider.nextPrayerTime != null) {
                    final nextPrayerTime = dataProvider.nextPrayerTime;
                    final nextPrayerName =
                        nextPrayerTime.split(":")[0]; // Extract prayer name
                    final imagePath = prayerImageMap[nextPrayerName];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                nextPrayerTime.split(":")[0],
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 5),
                              Image.asset(
                                imagePath!,
                                width: 100,
                                height: 100,
                                color: Colors.white,
                              ),
                              SizedBox(height: 5),
                              Text(
                                nextPrayerTime.split(":")[1] +
                                    " : " +
                                    nextPrayerTime.split(":")[2],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text(
                      'Failed to fetch prayer timings',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
