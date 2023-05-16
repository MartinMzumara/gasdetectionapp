import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gasdetector/components/custom_icon.dart';
import 'package:gasdetector/components/gas_indicator.dart';
import 'package:gasdetector/screens/history_page.dart';
import 'package:gasdetector/screens/maps_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gasdetector/services/geolocator.dart';
import 'dart:async';

import '../services/notifications.dart';
import '../utils/constants.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? _user = FirebaseAuth.instance.currentUser;
  List<FlSpot> gasLevelData = [];
  double _gasConcentration = 0;
  final NotificationService _notificationService = NotificationService();

  double _value = 127;
  final List<double> _specifiedValues = [59.0, 83.7, 236.3];
  int _currentIndex = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        // onGasConcentrationChanged(_value);
        _value = _specifiedValues[_currentIndex];
        _currentIndex = (_currentIndex + 1) % _specifiedValues.length;
      });
    });

    retrieveGasLevelData();
    determinePosition();
    onGasConcentrationChanged(_value);
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  // Retrieve gas level data from Firebase
  void retrieveGasLevelData() {
    final databaseReference = FirebaseDatabase.instance.ref();
    databaseReference.child('gas-levels').onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? data = snapshot.value as Map?;
      gasLevelData.clear();
      data!.forEach((key, value) {
        gasLevelData.add(FlSpot(double.parse(key), value));
      });
      setState(() {});
    });
  }

  void onGasConcentrationChanged(double concentration) {
    setState(() {
      _gasConcentration = concentration;
    });
    if (_gasConcentration >= 100) {
      // adjust the threshold as needed
      _notificationService.showNotification(
        id: 0,
        title: 'Gas Leak Detected',
        body:
            'The gas concentration has reached ${_gasConcentration.toStringAsFixed(2)} ppm!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 56),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: const [
            //     Icon(
            //       Icons.person,
            //       size: 32,
            //     )
            //   ],
            // ),
            // const SizedBox(height: 16),
            Text(
              'Welcome, ${_user!.displayName}',
              style: kHeadingTextStyle,
            ),
            const SizedBox(height: 24),
            const Text(
              'Current Gas Reading',
              style: kLargeTextStyle,
            ),
            const SizedBox(height: 16),
            GasIndicator(
              gasLevel: _value,
              minLevel: 85,
              maxLevel: 200,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Theme(
            data: Theme.of(context).copyWith(
              //background color of the BottomNavigationBar
              canvasColor: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xffd3d3d4)
                  : const Color(0xff393b3e),
            ),
            child: BottomNavigationBar(
              selectedItemColor: kSelectedIcon,
              unselectedItemColor:
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : kUnselectedIcon,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w400),
              iconSize: 28,
              items: [
                const BottomNavigationBarItem(
                    icon: MyIcon(
                      assetPath: 'assets/icons/home.svg',
                      color: kSelectedIcon,
                    ),
                    label: 'Home',
                    tooltip: 'Home'),
                BottomNavigationBarItem(
                  icon: MyIcon(
                    assetPath: 'assets/icons/history.svg',
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : kUnselectedIcon,
                  ),
                  label: 'History',
                  tooltip: 'History',
                ),
                BottomNavigationBarItem(
                  icon: MyIcon(
                    assetPath: 'assets/icons/map.svg',
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : kUnselectedIcon,
                  ),
                  label: 'Map',
                  tooltip: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: MyIcon(
                    assetPath: 'assets/icons/settings.svg',
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : kUnselectedIcon,
                  ),
                  label: 'Settings',
                  tooltip: 'Settings',
                ),
              ],
              currentIndex: 0,
              onTap: (index) {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DevicePage(),
                    ),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GoogleMapPage(),
                    ),
                  );
                } else if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
