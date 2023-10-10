import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Pages/quran_reading_page.dart';

import '../Providers/sourat_Provider.dart';

class SearchPage extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    final souratProvider = Provider.of<SouratProvider>(context);
    final surahs = souratProvider.sourat;
    final queryText = query.toLowerCase();

    final filteredSurahs = surahs.where((surah) {
      final nameEng = surah.nameEng!.toLowerCase();
      final nameArabic = surah.nameArabic!.toLowerCase();
      return nameEng.contains(queryText) || nameArabic.contains(queryText);
    }).toList();

    if (filteredSurahs.isEmpty) {
      return Center(
        child: Text('No results found'),
      );
    }

    return ListView.builder(
      itemCount: filteredSurahs.length,
      itemBuilder: (context, index) {
        final surah = filteredSurahs[index];
        return ListTile(
          title: Text(surah.nameEng.toString()),
          onTap: () {
            // Handle the tap action here
            Navigator.pushNamed(
              context,
              QuranReadingPage.route,
              arguments: surah,
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final souratProvider = Provider.of<SouratProvider>(context);
    final surahs = souratProvider.sourat;
    final queryText = query.toLowerCase();

    final filteredSurahs = surahs.where((surah) {
      final nameEng = surah.nameEng!.toLowerCase();
      final nameArabic = surah.nameArabic!.toLowerCase();
      return nameEng.contains(queryText) || nameArabic.contains(queryText);
    }).toList();

    return ListView.builder(
      itemCount: filteredSurahs.length,
      itemBuilder: (context, index) {
        final surah = filteredSurahs[index];
        return ListTile(
          title: Text(surah.nameEng.toString()),
          onTap: () {
            Navigator.pushNamed(
              context,
              QuranReadingPage.route,
              arguments: surah,
            );
          },
        );
      },
    );
  }
}
