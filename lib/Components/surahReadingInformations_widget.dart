import 'package:flutter/material.dart';

import '../Modals/SouratModal.dart';

class SurahReadingInformationsWidget extends StatelessWidget {
  final SouratModal surah;

  const SurahReadingInformationsWidget({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                            fontFamily: 'AlQalamQuran',
                            fontSize: 55,
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
    );
  }
}
