import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quran_app/Modals/SouratModal.dart';

class SouratProvider extends ChangeNotifier {
  List<SouratModal> _sourat = [
    SouratModal(id: 0, nameArabic: "", type: "", totalVerses: 0),
    // Add more objects as needed
  ];

  bool isLoading = false;

  List<SouratModal> get sourat => _sourat;

  getMyData() async {
    isLoading = true;
    final surahs = await fetchSurahInfo(1, 10);
    _sourat = surahs;
    isLoading = false;
    notifyListeners();
  }

  Future<List<SouratModal>> fetchSurahInfo(int start, int end) async {
    final options = {
      'headers': {
        'X-RapidAPI-Key': '25a0c6ee81msh64c3a6ce890c94dp158a6bjsn3fbb12e5af7d',
        'X-RapidAPI-Host': 'al-quran1.p.rapidapi.com',
      },
    };

    final List<SouratModal> surahs = [];

    for (int i = start; i <= end; i++) {
      final uri = Uri.https(
        'al-quran1.p.rapidapi.com',
        '/$i',
      );

      final response = await http.get(uri, headers: options['headers']);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        final id = jsonResponse['id'];
        final nameArabic = jsonResponse['surah_name_ar'];
        final type = jsonResponse['type'];
        final totalVerses = jsonResponse['total_verses'];

        final surah = SouratModal(
          id: id,
          nameArabic: nameArabic,
          type: type,
          totalVerses: totalVerses,
        );

        surahs.add(surah);
      } else {
        throw Exception('Failed to fetch Surah information');
      }
    }

    return surahs;
  }

  loadMoreData() async {
    if (!isLoading) {
      isLoading = true;
      final start = _sourat.length + 1;
      final end = start + 9;
      final surahs = await fetchSurahInfo(start, end);
      _sourat.addAll(surahs);
      isLoading = false;
      notifyListeners();
    }
  }
}
