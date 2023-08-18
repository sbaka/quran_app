import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Pages/quran_reading_page.dart';
import 'package:quran_app/Providers/last_Read_Provider.dart';
import 'package:quran_app/Providers/sourat_Provider.dart';

class SouraWidget extends StatefulWidget {
  const SouraWidget({
    super.key,
  });

  @override
  State<SouraWidget> createState() => _SouraWidgetState();
}

class _SouraWidgetState extends State<SouraWidget> {
  SouratProvider? dataProvider;
  LastReadProvider? lastReadProvider;

  @override
  void initState() {
    super.initState();
    dataProvider = Provider.of<SouratProvider>(context, listen: false);
    lastReadProvider = Provider.of<LastReadProvider>(context, listen: false);
    dataProvider!.getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SouratProvider>(
      builder: (context, dataProvider, _) {
        if (dataProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final surahs = dataProvider.sourat;

          return SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          QuranReadingPage.route,
                          arguments: surah,
                        ).then((value) {
                          lastReadProvider!.loadLastReadSurahId();
                        });
                      },
                      child: SizedBox(
                        width: 370,
                        height: 62,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/Images/Star.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                    Text(
                                      surah.id.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      surah.nameEng.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          surah.type.toString(),
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                            color: Color(0xFFA19CC5),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          Icons.circle,
                                          color: Color(0xFFBBC4CE),
                                          size: 4,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${surah.totalVerses.toString()} verses',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Poppins',
                                            color: Color(0xFFA19CC5),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        surah.nameArabic.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFA44AFF),
                                          fontFamily: 'Amiri',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 0.8,
                      indent: 15,
                      endIndent: 10,
                      color: const Color(0xff7B80AD).withOpacity(0.35),
                    )
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
}
