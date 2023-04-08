import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gasdetector/services/geolocator.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Welcome, ${_user!.displayName}!',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: ${_user!.email}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Gas Detection Status: ${isGasDetectionEnabled ? 'On' : 'Off'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),

              // Line chart to display gas levels over time
              Expanded(
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: gasLevelData,
                      ),
                    ],
                    minX: 0,
                    maxX: 10,
                    minY: 0,
                    maxY: 10,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Google Map to display location of gas leak

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey[50],
                  ),
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(37.7749, -122.4194),
                      zoom: 12,
                    ),
                    markers: <Marker>{
                      const Marker(
                        markerId: MarkerId('gas-leak'),
                        position: LatLng(37.7749, -122.4194),
                      ),
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
