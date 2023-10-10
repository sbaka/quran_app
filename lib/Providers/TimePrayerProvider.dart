import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import 'package:quran_app/Modals/PrayerTimingsModal.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart';

class PrayerInfo {
  final PrayerTimingsModal prayerTimings;
  final PrayerTimes prayerTimesInstance;
  final Location timeZone;

  PrayerInfo(this.prayerTimings, this.prayerTimesInstance, this.timeZone);
}

class TimePrayerProvider extends ChangeNotifier {
  PrayerTimingsModal _times =
      PrayerTimingsModal(fajr: "", dhuhr: "", asr: "", maghrib: "", isha: "");
  String _nextPrayerTime = "";
  HijriCalendar _today = HijriCalendar.now();

  bool isLoading = false;

  PrayerTimingsModal get times => _times;
  String get nextPrayerTime => _nextPrayerTime;
  HijriCalendar get today => _today;

  getMyData() async {
    isLoading = true;

    PrayerInfo prayerInfo = await fetchTodayInfo(DateTime.now());
    _times = prayerInfo.prayerTimings;
    _nextPrayerTime = getNextPrayerTime(prayerInfo);
    _today = HijriCalendar.now();

    // Check if there's no upcoming prayer for the current day
    if (_nextPrayerTime.contains("fajrafter")) {
      isLoading = true;

      final tomorrow = DateTime.now().add(Duration(days: 1));

      PrayerInfo tomorrowprayerInfo = await fetchTodayInfo(tomorrow);
      _today = HijriCalendar.fromDate(tomorrow);

      _times = tomorrowprayerInfo.prayerTimings;
      _nextPrayerTime = getNextPrayerTime(tomorrowprayerInfo);

      isLoading = false;
      notifyListeners();
    }

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

  Future<PrayerInfo> fetchTodayInfo(DateTime date) async {
    isLoading = true;

    String fullAddress =
        await fetchUserCoordinates(); // Retrieve the user's address
    List<String> addressComponents = fullAddress.split(',');

    double latitude = double.parse(addressComponents[0]);
    double longitude = double.parse(addressComponents[1]);

    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    final timezone = tz.getLocation(currentTimeZone);

    Coordinates coordinates = Coordinates(latitude, longitude);
    DateTime formatedDate = tz.TZDateTime.from(date, timezone);

    CalculationParameters params = CalculationMethod.MuslimWorldLeague();

    PrayerTimes prayerTimes = PrayerTimes(coordinates, formatedDate, params);

    DateTime fajrTime = prayerTimes.fajr!;
    DateTime dhuhrTime = prayerTimes.dhuhr!;
    DateTime asrTime = prayerTimes.asr!;
    DateTime maghribTime = prayerTimes.maghrib!;
    DateTime ishaTime = prayerTimes.isha!;

    PrayerTimingsModal prayerTimingsModal = PrayerTimingsModal(
      fajr: DateFormat('HH:mm').format(tz.TZDateTime.from(fajrTime, timezone)),
      dhuhr:
          DateFormat('HH:mm').format(tz.TZDateTime.from(dhuhrTime, timezone)),
      asr: DateFormat('HH:mm').format(tz.TZDateTime.from(asrTime, timezone)),
      maghrib:
          DateFormat('HH:mm').format(tz.TZDateTime.from(maghribTime, timezone)),
      isha: DateFormat('HH:mm').format(tz.TZDateTime.from(ishaTime, timezone)),
    );
    isLoading = false;
    return PrayerInfo(prayerTimingsModal, prayerTimes, timezone);
  }

  String getNextPrayerTime(PrayerInfo prayerInfo) {
    final nextPrayerName = prayerInfo.prayerTimesInstance.nextPrayer();
    final nextPrayerTime =
        prayerInfo.prayerTimesInstance.timeForPrayer(nextPrayerName);
    final timezone = tz.getLocation(prayerInfo.timeZone.toString());
    if (nextPrayerTime != null) {
      final formattedPrayerTime = tz.TZDateTime.from(nextPrayerTime, timezone);
      final formattedTimeString =
          DateFormat('HH:mm').format(formattedPrayerTime);
      return '$nextPrayerName: $formattedTimeString';
    }

    return 'No upcoming prayer';
  }
}
