import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
// to get location of user
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
// Modal for prayer Times
import 'package:quran_app/Modals/PrayerTimingsModal.dart';
// https://pub.dev/packages/hijri to get the hijri date ( cause pi fiha probleme ta3 unicode )
import 'package:hijri/hijri_calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

//Variables :
late HijriCalendar _today;

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
    _today = HijriCalendar.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff030c23),
        body: Column(
          children: [
            SafeArea(
              child: Container(
                child: Row(
                  children: [
                    Container(
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Container(
                          width: 24,
                          height: 24,
                          child: Icon(
                            Icons.menu,
                            size: 24,
                            color: Color(0xffA19CC5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
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
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Container(
                        width: 24,
                        height: 24,
                        child: Icon(
                          Icons.search,
                          size: 24,
                          color: Color(0xffA19CC5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TimePrayerWidget(),
            SizedBox(
              height: 15,
            ),
            LastRead(),
            SouraWidget(),
            SouraWidget(),
            SouraWidget(),
            SouraWidget(),
          ],
        ));
  }
}

class SouraWidget extends StatelessWidget {
  const SouraWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF7B80AD),
            width: 1.0,
          ),
        ),
      ),
      width: 370,
      height: 62,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/Images/Star.png',
                    width: 60,
                    height: 60,
                  ),
                  Text(
                    '1',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Al-Fatiah',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Meccan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Color(0xFFA19CC5),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.circle,
                        color: Color(0xFFBBC4CE),
                        size: 4,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '7 verses',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          color: Color(0xFFA19CC5),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'الفاتحة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA44AFF),
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LastRead extends StatelessWidget {
  const LastRead({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      width: 350,
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 5, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.menu_book,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Last Read',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 5, 0, 0),
            child: Text(
              'Al-Fatiah',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 5, 0, 0),
            child: Text(
              'Ayah No: 1',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimePrayerWidget extends StatelessWidget {
  const TimePrayerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage("assets/Images/QuranOpacitylow.png"),
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
      width: 350,
      height: 280,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("${_today.toFormat("dd MMMM yyyy").toString()}'",
                  style: const TextStyle(
                      fontFamily: 'Poppins',
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
                  DateFormat('HH:mm').format(DateTime.now()),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 35),
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
                            Text(
                              'Fajr',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Image.asset(
                              'assets/Images/fajr.png',
                              width: 60,
                              height: 60,
                              color: Colors.white,
                            ),
                            SizedBox(height: 5),
                            Text(
                              timings.fajr,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Dhuhr',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Image.asset(
                              'assets/Images/dhuhr.png',
                              width: 60,
                              height: 60,
                              color: Colors.white,
                            ),
                            SizedBox(height: 5),
                            Text(
                              timings.dhuhr,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Asr',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Image.asset(
                              'assets/Images/asr.png',
                              width: 60,
                              height: 60,
                              color: Colors.white,
                            ),
                            SizedBox(height: 5),
                            Text(
                              timings.asr,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Maghrib',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Image.asset(
                              'assets/Images/maghreb.png',
                              width: 60,
                              height: 60,
                              color: Colors.white,
                            ),
                            SizedBox(height: 5),
                            Text(
                              timings.maghrib,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Isha',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Image.asset(
                              'assets/Images/isha.png',
                              width: 60,
                              height: 60,
                              color: Colors.white,
                            ),
                            SizedBox(height: 5),
                            Text(
                              timings.isha,
                              style: TextStyle(
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
    );
  }
}
