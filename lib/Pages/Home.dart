import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quran_app/Modals/PrayerTimingsModal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

Future<PrayerTimingsModal> _getTodayInfo() async {
  String fullAddress = await fetchUserAddress(); // Retrieve the user's address

  final apiURL =
      'http://api.aladhan.com/v1/timingsByAddress?address=$fullAddress&method=2';
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
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
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
    fullAddress += subThoroughfare + ' ';
  }
  if (thoroughfare != null) {
    fullAddress += thoroughfare + ', ';
  }
  if (locality != null) {
    fullAddress += locality + ', ';
  }
  if (postalCode != null) {
    fullAddress += postalCode + ', ';
  }
  if (country != null) {
    fullAddress += country;
  }

  // Use the full address for API fetching or further processing
  print('Full Address: $fullAddress');
  return fullAddress; // Return the full address
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _getTodayInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage("assets/Images/Quran.png"),
                alignment: Alignment.bottomRight),
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
          width: 327,
          height: 257,
          child: Column(children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("3 Dhu al-Hijjah 1444",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
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
                      DateFormat('hh:mm').format(DateTime.now()),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 35),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 10, right: 10),
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
                                Text(
                                  'Fajr',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  timings.fajr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Dohr',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  timings.dhuhr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Asr',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  timings.asr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Maghrib',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  timings.maghrib,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Isha',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  timings.isha,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Failed to fetch prayer timings',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
