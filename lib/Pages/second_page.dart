import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/Components/QiblahCompass_Widget.dart';

import '../Providers/QiblahCompass_Provider.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
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
      appBar: AppBar(
        title: Text("Qiblah Page"),
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
