import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import '../Modals/VerseModal.dart';

class VersesProvider extends ChangeNotifier {
  List<VerseModal> _verses = [];

  bool isLoading = false;

  List<VerseModal> get verses => _verses;

  Future<void> getData(int id) async {
    isLoading = true;
    try {
      _verses = await fetchVerses(id);
      print(_verses[0].content);
    } catch (error) {
      print('Error: $error');
      _verses = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<VerseModal>> fetchVerses(int id) async {
    try {
      // Load the JSON asset
      String jsonString =
          await rootBundle.loadString('assets/data/surah/surah_$id.json');
      final jsonData = json.decode(jsonString);

      final versesData = jsonData['verse'];

      List<VerseModal> verses = [];
      versesData.forEach((key, value) {
        VerseModal verse = VerseModal(
          content: value,
          translationEng: '', // You can set translation here if available
        );
        verses.add(verse);
      });

      return verses;
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }
}
