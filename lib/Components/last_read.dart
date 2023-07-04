import 'package:flutter/material.dart';

class LastRead extends StatelessWidget {
  const LastRead({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
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
            padding: EdgeInsets.fromLTRB(8.0, 5, 0, 0),
            child: Text(
              'Al-Fatiah',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
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
