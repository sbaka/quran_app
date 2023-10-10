import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LastReadProvider extends ChangeNotifier {
  Box<String>? _lastReadBox;
  bool _isInitialized = false;

  LastReadProvider() {
    openBox();
  }

  Future<void> openBox() async {
    _lastReadBox = await Hive.openBox<String>('lastReadBox');
    _isInitialized = true;
    notifyListeners(); // Notify listeners after the box is opened
  }

  Future<void> storeLastReadSurahName(String surahName) async {
    if (!_isInitialized) {
      // Handle the case where box is not initialized
      return;
    }
    await _lastReadBox!.put('lastReadSurahName', surahName);
    notifyListeners();
  }

  String? getLastReadSurahName() {
    if (!_isInitialized) {
      // Handle the case where box is not initialized
      return null;
    }
    return _lastReadBox!.get('lastReadSurahName');
  }
}
