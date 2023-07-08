import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Modals/VerseModal.dart';

class VersesProvider extends ChangeNotifier {
  List<VerseModal> _verses = [];

  bool isLoading = false;

  List<VerseModal> get verses => _verses;

  Future<void> getMyData(int id) async {
    isLoading = true;
    final verses = await fetchVerses(id);
    _verses = verses;
    print(_verses[0].content);
    isLoading = false;
    notifyListeners();
  }

  Future<List<VerseModal>> fetchVerses(int id) async {
    final url = Uri.parse('https://al-quran1.p.rapidapi.com/$id');

    final headers = {
      'X-RapidAPI-Key': '25a0c6ee81msh64c3a6ce890c94dp158a6bjsn3fbb12e5af7d',
      'X-RapidAPI-Host': 'al-quran1.p.rapidapi.com',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final versesData = jsonData['verses'];

        List<VerseModal> verses = [];
        versesData.forEach((key, value) {
          VerseModal verse = VerseModal(
            content: value['content'],
            translationEng: value['translation_eng'],
          );
          verses.add(verse);
        });
        return verses;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return []; // Return an empty list if there's an error
  }
}
