import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:quran_app/Modals/PrayerTimingsModal.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class TimePrayerProvider extends ChangeNotifier {
  PrayerTimingsModal _times = PrayerTimingsModal(
    fajr: '',
    dhuhr: '',
    asr: '',
    maghrib: '',
    isha: '',
  );

  bool isLoading = false;

  PrayerTimingsModal get times => _times;

  getMyData() async {
    isLoading = true;
    _times = await fetchTodayInfo();
    isLoading = false;
    notifyListeners();
  }

  Future<String> fetchUserCoordinates() async {
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

    // Return the coordinates as a string
    return '${position.latitude},${position.longitude}';
  }

  Future<PrayerTimingsModal> fetchTodayInfo() async {
    isLoading = true;

    String fullAddress =
        await fetchUserCoordinates(); // Retrieve the user's address
    List<String> addressComponents = fullAddress.split(',');

    double latitude = double.parse(addressComponents[0]);
    double longitude = double.parse(addressComponents[1]);

    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    final timezone = tz.getLocation(currentTimeZone);

    Coordinates coordinates = Coordinates(latitude, longitude);
    DateTime date = tz.TZDateTime.from(DateTime.now(), timezone);

    CalculationParameters params = CalculationMethod.MuslimWorldLeague();

    PrayerTimes prayerTimes = PrayerTimes(coordinates, date, params);

    DateTime fajrTime = prayerTimes.fajr!;
    DateTime dhuhrTime = prayerTimes.dhuhr!;
    DateTime asrTime = prayerTimes.asr!;
    DateTime maghribTime = prayerTimes.maghrib!;
    DateTime ishaTime = prayerTimes.isha!;

    int fajrHour = tz.TZDateTime.from(fajrTime, timezone).hour;
    int fajrMinute = tz.TZDateTime.from(fajrTime, timezone).minute;

    int dhuhrHour = tz.TZDateTime.from(dhuhrTime, timezone).hour;
    int dhuhrMinute = tz.TZDateTime.from(dhuhrTime, timezone).minute;

    int asrHour = tz.TZDateTime.from(asrTime, timezone).hour;
    int asrMinute = tz.TZDateTime.from(asrTime, timezone).minute;

    int maghribHour = tz.TZDateTime.from(maghribTime, timezone).hour;
    int maghribMinute = tz.TZDateTime.from(maghribTime, timezone).minute;

    int ishaHour = tz.TZDateTime.from(ishaTime, timezone).hour;
    int ishaMinute = tz.TZDateTime.from(ishaTime, timezone).minute;

    PrayerTimingsModal prayerTimingsModal = PrayerTimingsModal(
      fajr: '$fajrHour:$fajrMinute',
      dhuhr: '$dhuhrHour:$dhuhrMinute',
      asr: '$asrHour:$asrMinute',
      maghrib: '$maghribHour:$maghribMinute',
      isha: '$ishaHour:$ishaMinute',
    );

    isLoading = false;
    return prayerTimingsModal;
  }

  String getNextPrayerTime(PrayerTimingsModal timings) {
    final currentDateTime = DateTime.now();
    final prayerTimes = [
      {'name': 'Fajr', 'time': timings.fajr},
      {'name': 'Dhuhr', 'time': timings.dhuhr},
      {'name': 'Asr', 'time': timings.asr},
      {'name': 'Maghrib', 'time': timings.maghrib},
      {'name': 'Isha', 'time': timings.isha},
    ];

    for (final prayer in prayerTimes) {
      final prayerHour = int.parse(prayer['time']!.split(':')[0]);
      final prayerMinute = int.parse(prayer['time']!.split(':')[1]);

      final prayerDateTime = DateTime(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day,
        prayerHour,
        prayerMinute,
      );

      if (prayerDateTime.isAfter(currentDateTime)) {
        final formattedPrayerTime = DateFormat('HH:mm').format(prayerDateTime);
        return '${prayer['name']}: $formattedPrayerTime';
      }
    }

    return 'No upcoming prayer';
  }

  /*
  Future<PrayerTimingsModal> fetchTodayInfo() async {
    isLoading = true;

    String fullAddress =
        await fetchUserAddress(); // Retrieve the user's address

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

          return prayerTimingsModal;
        }
      }
    }

    throw Exception('Failed to fetch prayer timings');
  }
*/
}
