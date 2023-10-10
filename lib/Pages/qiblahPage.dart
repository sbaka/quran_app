import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Components/QiblahCompass_widget.dart';
import 'package:quran_app/Pages/SearchPage.dart';

import '../Providers/QiblahCompass_Provider.dart';

class qiblahPage extends StatefulWidget {
  const qiblahPage({super.key});

  @override
  State<qiblahPage> createState() => _qiblahPageState();
}

class _qiblahPageState extends State<qiblahPage> {
  @override
  void initState() {
    super.initState();
    final dataProvider =
        Provider.of<QiblahCompassProvider>(context, listen: false);
    dataProvider.checkLocationStatus(); // Check location status on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: Text("")),
      appBar: AppBar(
        title: const Text(
          'Qiblah',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.5,
            color: Color(0xffffffff),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPage(),
              );
            },
            child: const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.search,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Consumer<QiblahCompassProvider>(
          builder: (context, provider, _) {
            if (provider.enabled) {
              switch (provider.permissionStatus) {
                case LocationPermissionStatus.Always:
                case LocationPermissionStatus.WhileInUse:
                  // Replace this with your QiblahCompassWidget implementation.
                  return QiblahCompassWidget();
                case LocationPermissionStatus.Denied:
                  // TODO: Handle this case.
                  break;
                case LocationPermissionStatus.DeniedForever:
                  // TODO: Handle this case.
                  break;
                case LocationPermissionStatus.UnableToDetermine:
                  // TODO: Handle this case.
                  break;
              }
            }
            // Fallback widget if none of the conditions are met.
            return Text("Fallback Widget");
          },
        ),
      ),
    );
  }
}
