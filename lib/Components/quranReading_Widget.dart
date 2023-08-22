import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Modals/VerseModal.dart';
import '../Providers/verses_Provide.dart';

class quranReading_Widget extends StatefulWidget {
  final int id;

  const quranReading_Widget({
    required this.id,
    super.key,
  });

  @override
  _quranReading_WidgetState createState() => _quranReading_WidgetState();
}

class _quranReading_WidgetState extends State<quranReading_Widget> {
  VersesProvider? dataProvider;

  @override
  void initState() {
    super.initState();
    dataProvider = Provider.of<VersesProvider>(context, listen: false);
    dataProvider!.getData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VersesProvider>(
      builder: (context, versesProvider, _) {
        return versesProvider.isChromeReaderMode
            ? ChromeReaderModeWidget(
                verses: versesProvider.verses,
              )
            : ListView.builder(
                itemCount: versesProvider.verses.length,
                itemBuilder: (context, index) {
                  VerseModal verse = versesProvider.verses[index];
                  final isCurrentVersePlaying = index == versesProvider.currentPlayingIndex;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF121931),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 27,
                                    height: 27,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCurrentVersePlaying ? Colors.green : Color(0xFFA44AFF),
                                    ),
                                  ),
                                  Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  versesProvider.shareContent(verse.content);
                                },
                                icon: const Icon(
                                  Icons.share_outlined,
                                  color: Color(0xFFA44AFF),
                                  size: 25,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (versesProvider.isPlaying && index == versesProvider.currentPlayingIndex) {
                                    versesProvider.stopAudio();
                                  } else {
                                    versesProvider.playAudio(verse.audioData, index);
                                  }
                                },
                                icon: Icon(
                                  isCurrentVersePlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline_outlined,
                                  color: Color(0xFFA44AFF),
                                  size: 25,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.bookmark_border_outlined,
                                  color: Color(0xFFA44AFF),
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            verse.content,
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            verse.translationEng,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xFFA19CC5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Divider(
                          thickness: 0.8,
                          indent: 15,
                          endIndent: 10,
                          color: const Color(0xff7B80AD).withOpacity(0.35),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                },
              );
      },
    );
  }
}

class ChromeReaderModeWidget extends StatelessWidget {
  final List<VerseModal> verses;

  const ChromeReaderModeWidget({super.key, required this.verses});

  String getVerseEndSymbol(int verseNumber, {bool arabicNumeral = true}) {
    var arabicNumeric = '';
    var digits = verseNumber.toString().split("").toList();

    if (!arabicNumeral) return '\u06dd${verseNumber.toString()}';

    const Map arabicNumbers = {"0": "٠", "1": "١", "2": "٢", "3": "٣", "4": "٤", "5": "٥", "6": "٦", "7": "٧", "8": "٨", "9": "٩"};

    for (var e in digits) {
      arabicNumeric += arabicNumbers[e];
    }

    return '\u06dd$arabicNumeric';
  }

  @override
  Widget build(BuildContext context) {
    String suraStr = verses.map((e) => "${e.content} ${getVerseEndSymbol(verses.indexOf(e))}").reduce((value, element) => "$value  $element");
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Flexible(
            child: Text(
              suraStr,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "amiri",
                fontSize: 20,
              ),
              softWrap: true,
            ),
          ),
        ),
      ),
    );
  }
}

//  Wrap(
//           alignment: WrapAlignment.end,
//           children: verses
//               .map(
//                 (e) => Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: Text(
//                         "${e.content} ",
//                         textDirection: TextDirection.rtl,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontFamily: "amiri",
//                           fontSize: 20,
//                         ),
//                         softWrap: true,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//               .toList(),
//         ),
