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
    return Container(
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
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Consumer<TimePrayerProvider>(
              builder: (context, dataProvider, _) {
                if (dataProvider.isLoading) {
                  return const CircularProgressIndicator();
                  // ignore: unnecessary_null_comparison
                } else if (dataProvider.times != null) {
                  final timings = dataProvider.times;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Fajr',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Image.asset(
                                'assets/Images/fajr.png',
                                width: 60,
                                height: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                timings.fajr,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Dhuhr',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Image.asset(
                                'assets/Images/dhuhr.png',
                                width: 60,
                                height: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                timings.dhuhr,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Asr',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Image.asset(
                                'assets/Images/asr.png',
                                width: 60,
                                height: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                timings.asr,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Maghrib',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Image.asset(
                                'assets/Images/maghreb.png',
                                width: 60,
                                height: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                timings.maghrib,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Isha',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Image.asset(
                                'assets/Images/isha.png',
                                width: 60,
                                height: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                timings.isha,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          // Repeat the above code for other prayer times
                        ],
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
    );
  }
}
