import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastReadProvider extends ChangeNotifier {
  String? _lastReadsurahName;

  get lastReadsurahName => _lastReadsurahName;

  Future<void> loadLastReadSurahId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lastReadsurahName = prefs.getString('selectedSurahName');
    notifyListeners();
  }
}
