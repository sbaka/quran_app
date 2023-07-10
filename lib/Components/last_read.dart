import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/last_Read_Provider.dart';

class LastRead extends StatefulWidget {
  const LastRead({
    super.key,
  });

  @override
  State<LastRead> createState() => _LastReadState();
}

class _LastReadState extends State<LastRead> {
  LastReadProvider? dataProvider;

  @override
  Widget build(BuildContext context) {
    dataProvider ??= Provider.of<LastReadProvider>(context, listen: true);

    String name = dataProvider?.lastReadsurahName;

    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(image: AssetImage("assets/Images/Quran.png"), alignment: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFDF98FA),
            Color(0xFF9055FF),
          ],
        ),
      ),
      width: 350,
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 5, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.menu_book,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Last Read',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 5, 0, 0),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 5, 0, 0),
            child: Text(
              'Ayah No: 1',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
