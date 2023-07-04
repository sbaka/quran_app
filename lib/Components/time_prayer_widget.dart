import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../Modals/PrayerTimingsModal.dart';

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

  Future<String> fetchUserAddress() async {
    // Request permission to access the user's location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Handle denied permission permanently
      print('Location permission denied forever');
      return '';
    } else if (permission == LocationPermission.denied) {
      // Request permission if it was previously denied
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        // Handle denied permission
        print('Location permission denied');
        return '';
      }
    }

    // Request the user's current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Retrieve the address using the user's coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Extract the address components from the first placemark
    Placemark placemark = placemarks.first;
    String? subThoroughfare = placemark.subThoroughfare;
    String? thoroughfare = placemark.thoroughfare;
    String? locality = placemark.locality;
    String? postalCode = placemark.postalCode;
    String? country = placemark.country;

    // Build the full address string
    String fullAddress = '';
    if (subThoroughfare != null) {
      fullAddress += '$subThoroughfare ';
    }
    if (thoroughfare != null) {
      fullAddress += '$thoroughfare, ';
    }
    if (locality != null) {
      fullAddress += '$locality, ';
    }
    if (postalCode != null) {
      fullAddress += '$postalCode, ';
    }
    if (country != null) {
      fullAddress += country;
    }

    // Use the full address for API fetching or further processing
    print('Full Address: $fullAddress');
    return fullAddress; // Return the full address
  }

  Future<PrayerTimingsModal> _getTodayInfo() async {
    String fullAddress = await fetchUserAddress(); // Retrieve the user's address

    final apiURL = 'http://api.aladhan.com/v1/timingsByAddress?address=$fullAddress&method=2';
    print(apiURL);

    final response = await http.get(Uri.parse(apiURL));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('data')) {
        final data = jsonResponse['data'];

        if (data.containsKey('timings')) {
          final timings = data['timings'];

          // Access individual timings
          String fajr = timings['Fajr'];
          String dhuhr = timings['Dhuhr'];
          String asr = timings['Asr'];
          String maghrib = timings['Maghrib'];
          String isha = timings['Isha'];

          // Create PrayerTimingsModal instance
          PrayerTimingsModal prayerTimingsModal = PrayerTimingsModal(
            fajr: fajr,
            dhuhr: dhuhr,
            asr: asr,
            maghrib: maghrib,
            isha: isha,
          );

          print(prayerTimingsModal.fajr);

          return prayerTimingsModal;
        }
      }
    }

    throw Exception('Failed to fetch prayer timings');
  }

  @override
  void initState() {
    super.initState();
    _today = HijriCalendar.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(image: AssetImage("assets/Images/QuranOpacitylow.png"), alignment: Alignment.bottomRight),
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
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${_today.toFormat("dd MMMM yyyy").toString()}'",
                  style: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
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
                  DateFormat('HH:mm').format(DateTime.now()),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 35),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          child: FutureBuilder<PrayerTimingsModal>(
            future: _getTodayInfo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final timings = snapshot.data!;

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
                      ],
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text(
                  'Failed to fetch prayer timings',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        )
      ]),
    );
  }
}
