import 'package:flutter/material.dart';
import 'package:gasdetector/utils/constants.dart';

import '../components/bar_chart.dart';
import '../components/custom_icon.dart';
import '../components/google_maps.dart';
import 'history_page.dart';
import 'home_page.dart';
import 'settings.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 44),

                const Text(
                  'Map',
                  style: kHeadingTextStyle,
                ),

                const SizedBox(height: 16),

                // Google Map to display location of gas leak

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Expanded(
                      child: SizedBox(
                          height: constraints.maxHeight * 0.8, child: MyMap())),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      color: kUnselectedIcon,
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
                    color: kSelectedIcon,
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
              currentIndex: 2,
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
