import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quran_app/Modals/PrayerTimingsModal.dart';

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
}
