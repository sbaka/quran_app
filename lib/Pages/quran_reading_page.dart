import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Modals/SouratModal.dart';

import 'package:quran_app/Providers/verses_Provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranReadingPage extends StatefulWidget {
  static const String route = '/quranReadingPage';

  const QuranReadingPage({super.key});

  @override
  State<QuranReadingPage> createState() => _QuranReadingPageState();
}

class _QuranReadingPageState extends State<QuranReadingPage> {
  late SouratModal surah;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    surah = ModalRoute.of(context)!.settings.arguments as SouratModal;
    final dataProvider = Provider.of<VersesProvider>(context, listen: false);
    dataProvider.getMyData(surah.id);
  }

  Future<void> _storeSelectedSurah() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedSurahId', surah.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surah.nameEng ?? ''),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: const Center(),
    );
  }
}
