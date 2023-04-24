import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gasdetector/screens/device_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gasdetector/services/geolocator.dart';

import '../components/bar_chart.dart';
import '../components/google_maps.dart';
import '../constants.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 44),
            Text(
              'Welcome, ${_user!.displayName}!',
              style: kHeadingTextStyle,
            ),
            const SizedBox(height: 24),

            Text(
              'Gas Detection Status: ${isGasDetectionEnabled ? 'On' : 'Off'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Line chart to display gas levels over time
            const Expanded(
              child: MyBarChart(),
            ),

            const SizedBox(height: 24),

            // Google Map to display location of gas leak

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 250,
                child: MyMap(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: const Color(0xff001e33),
            ),
            child: BottomNavigationBar(
              selectedItemColor: const Color(0xff4db5ff),
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
              unselectedItemColor: const Color(0xffcceaff),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.developer_board_rounded),
                  label: 'Devices',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_rounded),
                  label: 'Settings',
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
