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

  double _value = 0;
  final List<double> _specifiedValues = [50.0, 120.0, 230.0];
  int _currentIndex = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        _value = _specifiedValues[_currentIndex];
        _currentIndex = (_currentIndex + 1) % _specifiedValues.length;
        onGasConcentrationChanged(_value);
      });
    });

    retrieveGasLevelData();
    determinePosition();
  }

  // @override
  // void dispose() {
  //   timer!.cancel();
  //   super.dispose();
  // }

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
    if (_gasConcentration >= 150) {
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
            const SizedBox(height: 44),
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
              canvasColor: const Color(0xff393b3e),
            ),
            child: BottomNavigationBar(
              selectedItemColor: const Color(0xff4db5ff),
              unselectedItemColor: const Color(0xffcceaff),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w400),
              iconSize: 28,
              items: const [
                BottomNavigationBarItem(
                    icon: MyIcon(
                      assetPath: 'assets/icons/home.svg',
                      color: kSelectedIcon,
                    ),
                    label: 'Home',
                    tooltip: 'Home'),
                BottomNavigationBarItem(
                  icon: MyIcon(
                    assetPath: 'assets/icons/history.svg',
                    color: kUnselectedIcon,
                  ),
                  label: 'History',
                  tooltip: 'History',
                ),
                BottomNavigationBarItem(
                  icon: MyIcon(
                    assetPath: 'assets/icons/map.svg',
                    color: kUnselectedIcon,
                  ),
                  label: 'Map',
                  tooltip: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: MyIcon(
                    assetPath: 'assets/icons/settings.svg',
                    color: kUnselectedIcon,
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
