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
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFDF98FA),
                    Color(0xFF9055FF),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      'assets/Images/QuranOpacitylow.png',
                      colorBlendMode: BlendMode.color,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                surah.nameArabic.toString(),
                                style: const TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 42,
                                ),
                              ),
                              Text(
                                surah.nameEng.toString(),
                                style: const TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 250,
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      surah.type.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.circle,
                                    color: Color(0xFFBBC4CE),
                                    size: 4,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      surah.totalVerses.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                "assets/Images/basmala.png",
                                scale: 1.5,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
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
