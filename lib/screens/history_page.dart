import 'package:flutter/material.dart';

import '../components/bar_chart.dart';
import '../components/custom_icon.dart';
import '../components/line_chart.dart';
import '../utils/constants.dart';
import 'home_page.dart';
import 'maps_page.dart';
import 'settings.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 60,
            ),
            Text(
              'History',
              style: kHeadingTextStyle,
            ),
            SizedBox(height: 16),
            Expanded(
              child: MyLineChart(),
            ),
            SizedBox(height: 16),

            Text(
              'Weekly Report',
              style: kLargeTextStyle,
            ),

            SizedBox(height: 24),

            // Bar chart to display gas levels over time
            Expanded(
              child: MyBarChart(),
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
                BottomNavigationBarItem(
                    icon: MyIcon(
                      assetPath: 'assets/icons/home.svg',
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : kUnselectedIcon,
                    ),
                    label: 'Home',
                    tooltip: 'Home'),
                const BottomNavigationBarItem(
                  icon: MyIcon(
                    assetPath: 'assets/icons/history.svg',
                    color: kSelectedIcon,
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
              currentIndex: 1,
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
