import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Providers/sourat_Provider..dart';

class SouraWidget extends StatefulWidget {
  const SouraWidget({
    super.key,
  });

  @override
  State<SouraWidget> createState() => _SouraWidgetState();
}

class _SouraWidgetState extends State<SouraWidget> {
  ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    final dataProvider = Provider.of<SouratProvider>(context, listen: false);
    dataProvider.getMyData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Reach the end of the list, load more data
        if (!isLoadingMore) {
          setState(() {
            isLoadingMore = true;
          });
          dataProvider.loadMoreData().then((_) {
            setState(() {
              isLoadingMore = false;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SouratProvider>(
      builder: (context, dataProvider, _) {
        if (dataProvider.isLoading) {
          // Display a loading indicator
          return CircularProgressIndicator();
        } else {
          final surahs = dataProvider.sourat;

          return SizedBox(
            height: 500,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                if (index == surahs.length) {
                  // Last item, show loading indicator if more data is being loaded
                  return isLoadingMore
                      ? CircularProgressIndicator()
                      : SizedBox();
                } else {
                  final surah = surahs[index];

                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF7B80AD),
                          width: 1.0,
                        ),
                      ),
                    ),
                    width: 370,
                    height: 62,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                  style: TextStyle(
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
                                  surah.nameArabic.toString(),
                                  style: TextStyle(
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
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        color: Color(0xFFA19CC5),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.circle,
                                      color: Color(0xFFBBC4CE),
                                      size: 4,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${surah.totalVerses.toString()} verses',
                                      style: TextStyle(
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
                                    style: TextStyle(
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
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
