import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gasdetector/components/custom_icon.dart';
import 'package:gasdetector/components/gas_indicator.dart';
import 'package:gasdetector/screens/history_page.dart';
import 'package:gasdetector/screens/maps_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gasdetector/services/geolocator.dart';

import '../components/bar_chart.dart';
import '../components/google_maps.dart';
import '../utils/constants.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? _user = FirebaseAuth.instance.currentUser;
  bool isGasDetectionEnabled = false;
  List<FlSpot> gasLevelData = [];

  @override
  void initState() {
    super.initState();

    retrieveGasLevelData();
    determinePosition();
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
            const GasIndicator(
              gasLevel: 30,
              minLevel: 50,
              maxLevel: 200,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
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
