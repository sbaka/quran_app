import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:quran_app/Modals/SouratModal.dart';

class SouratProvider extends ChangeNotifier {
  late List<SouratModal> _sourat;
  bool isLoading = false;

  List<SouratModal> get sourat => _sourat;

  Future<void> getMyData() async {
    isLoading = true;
    try {
      _sourat = await readSurahList();
    } catch (e) {
      // Handle the error, e.g., log it or show an error message
      print('Error: $e');
      _sourat = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<SouratModal>> readSurahList() async {
    List<SouratModal> surahs = [];
    try {
      String jsonString = await rootBundle.loadString('assets/data/surah.json');
      var jsonData = json.decode(jsonString);
      for (var surah in jsonData) {
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
    } catch (e) {
      // Handle the error, e.g., log it or show an error message
      print('Error: $e');
    }
    return surahs;
  }
}
