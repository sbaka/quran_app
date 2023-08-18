import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Modals/SouratModal.dart';

import 'package:quran_app/Providers/verses_Provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/surahReadingInformations_widget.dart';

class QuranReadingPage extends StatefulWidget {
  static const String route = '/quranReadingPage';

  const QuranReadingPage({super.key});

  @override
  State<QuranReadingPage> createState() => _QuranReadingPageState();
}

class _QuranReadingPageState extends State<QuranReadingPage> {
  late SouratModal surah;
  VersesProvider? dataProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    surah = ModalRoute.of(context)!.settings.arguments as SouratModal;
    _storeSelectedSurah();
    dataProvider = Provider.of<VersesProvider>(context, listen: false);
    dataProvider!.getData(surah.id); // Fetch verses data for the surah
  }

  //to save the last read surah
  Future<void> _storeSelectedSurah() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedSurahName', surah.nameEng.toString());
  }

  @override
  Widget build(BuildContext context) {
    dataProvider ??= Provider.of<VersesProvider>(context, listen: true);

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SurahReadingInformationsWidget(
              surah: surah), // Use the extracted widget here

          const Expanded(
            flex: 5,
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
