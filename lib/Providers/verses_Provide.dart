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
      // Load the JSON asset for verses
      String jsonString =
          await rootBundle.loadString('assets/data/surah/surah_$id.json');
      final jsonData = json.decode(jsonString);

      final versesData = jsonData['verse'];

      // Load the translation JSON asset
      String translationJsonString = await rootBundle
          .loadString('assets/data/translation/en/en_translation_$id.json');
      final translationJsonData = json.decode(translationJsonString);
      final translationData = translationJsonData['verse'];

      List<VerseModal> verses = [];
      versesData.forEach((key, value) {
        String translation =
            translationData[key] ?? ''; // Get the translation if available
        VerseModal verse = VerseModal(
          content: value,
          translationEng: translation,
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
