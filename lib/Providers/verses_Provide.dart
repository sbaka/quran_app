import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import '../Modals/VerseModal.dart';

class VersesProvider extends ChangeNotifier {
  List<VerseModal> _verses = [];

  bool isLoading = false;

  List<VerseModal> get verses => _verses;

  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> playAudio(String audioUrl) async {
    await _audioPlayer.play(AssetSource(audioUrl));
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> stopAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> getData(int id) async {
    isLoading = true;
    try {
      _verses = await fetchVerses(id);
      print(_verses[0].audioData);
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
      print(jsonData['index']);

      // Load the translation JSON asset
      String translationJsonString = await rootBundle
          .loadString('assets/data/translation/en/en_translation_$id.json');
      final translationJsonData = json.decode(translationJsonString);
      final translationData = translationJsonData['verse'];

      // Extract index value from jsonData
      String index = jsonData['index'];

      // Load audio index JSON asset using the extracted index value
      String audioIndexJsonString =
          await rootBundle.loadString('assets/data/audio/$index/index.json');
      final audioIndexData = json.decode(audioIndexJsonString);

      List<VerseModal> verses = [];
      versesData.forEach((key, value) {
        String translation =
            translationData[key] ?? ''; // Get the translation if available
        String audioFile = audioIndexData["verse"][key]['file'] ??
            ''; // Get audio file if available
        String audioUrl =
            'data/audio/$index/$audioFile'; // Construct the audio URL

        VerseModal verse = VerseModal(
          content: value,
          translationEng: translation,
          audioData: audioUrl, // Add audio data to VerseModal
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
