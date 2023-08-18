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
    // TODO: implement initState
    super.initState();
    dataProvider = Provider.of<VersesProvider>(context, listen: false);
    dataProvider!.getData(widget.id); // Fetch verses data for the surah
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VersesProvider>(
      builder: (context, versesProvider, _) {
        return ListView.builder(
          itemCount: versesProvider.verses.length,
          itemBuilder: (context, index) {
            VerseModal verse = versesProvider.verses[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFA44AFF),
                              ),
                            ),
                            Text(
                              (index + 1)
                                  .toString(), // Display index + 1 as the verse number
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
                            // Add your share action here
                          },
                          icon: const Icon(
                            Icons.share_outlined,
                            color: Color(0xFFA44AFF),
                            size: 25,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Add your play action here
                          },
                          icon: const Icon(
                            Icons.play_circle_outline_outlined,
                            color: Color(0xFFA44AFF),
                            size: 25,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Add your save action here
                          },
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
                      verse.content, // Display the Arabic content of the verse
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
                      verse.translationEng, // Display the English translation
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
