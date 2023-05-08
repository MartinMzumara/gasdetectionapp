import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gasdetector/screens/history_page.dart';

import '../components/custom_icon.dart';
import '../utils/constants.dart';
import 'home_page.dart';
import 'maps_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 44,
            ),
            const Text(
              'Settings',
              style: kHeadingTextStyle,
            ),
            const SizedBox(height: 16),
            const Text(
              'About',
              style: kNormalTextStyle,
            ),
            const SizedBox(height: 16),
            const Text(
              'Help Center',
              style: kNormalTextStyle,
            ),
            const SizedBox(height: 16),
            const Text(
              'Change Theme',
              style: kNormalTextStyle,
            ),
            const SizedBox(height: 16),
            const Text(
              'Follow Us',
              style: kNormalTextStyle,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
                    color: kUnselectedIcon,
                  ),
                  label: 'Map',
                  tooltip: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: MyIcon(
                    assetPath: 'assets/icons/settings.svg',
                    color: kSelectedIcon,
                  ),
                  label: 'Settings',
                  tooltip: 'Settings',
                ),
              ],
              currentIndex: 3,
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
