import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Modals/SouratModal.dart';
import 'package:quran_app/Pages/SearchPage.dart';

import 'package:quran_app/Providers/verses_Provide.dart';

import '../Components/quranReading_Widget.dart';
import '../Components/surahReadingInformations_widget.dart';
import '../Providers/last_Read_Provider.dart';

class QuranReadingPage extends StatefulWidget {
  static const String route = '/quranReadingPage';

  const QuranReadingPage({super.key});

  @override
  State<QuranReadingPage> createState() => _QuranReadingPageState();
}

class _QuranReadingPageState extends State<QuranReadingPage> {
  late SouratModal surah;
  LastReadProvider? lastReadProvider;
  VersesProvider? dataProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    surah = ModalRoute.of(context)!.settings.arguments as SouratModal;
    lastReadProvider = Provider.of<LastReadProvider>(context, listen: false);
    lastReadProvider?.storeLastReadSurahName(surah.nameEng.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surah.nameEng ?? ''),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                Provider.of<VersesProvider>(context, listen: false).toggleChromeReaderMode();
              });
            },
            icon: const Icon(Icons.chrome_reader_mode),
          ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPage(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SurahReadingInformationsWidget(surah: surah),
          Expanded(
            flex: 5,
            child: quranReading_Widget(id: surah.id),
          ),
        ],
      ),
    );
  }
}
