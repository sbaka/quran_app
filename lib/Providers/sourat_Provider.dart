import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:quran_app/Modals/SouratModal.dart';

class SouratProvider extends ChangeNotifier {
  List<SouratModal> _sourat = [
    SouratModal(id: 0, nameArabic: "", nameEng: '', type: "", totalVerses: 0),
    // Add more objects as needed
  ];

  bool isLoading = false;

  List<SouratModal> get sourat => _sourat;

  Future<List<SouratModal>> readSurahList() async {
    List<SouratModal> surahs = [];
    // Load the JSON file from the assets
    String jsonString = await rootBundle.loadString('assets/data/surah.json');

    // Parse the JSON string into a Map or List
    var jsonData = json.decode(jsonString);
    for (var surah in jsonData) {
      // Assuming each section represents a Surah
      surahs.add(
        SouratModal(
          id: int.parse(surah['index']),
          nameEng: surah['title'],
          nameArabic: surah['titleAr'],
          type: surah['type'],
          totalVerses: surah['count'],
        ),
      );
    }

    return surahs;
  }
}
