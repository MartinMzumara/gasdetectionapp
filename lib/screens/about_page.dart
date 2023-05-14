import 'package:flutter/material.dart';

import '../utils/constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 70,
          elevation: 0,
          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'ABOUT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            background: Container(color: const Color(0xff16171a)),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Gas Leakage Detection App',
                  style: kHeadingTextStyle,
                ),
                SizedBox(height: 10),
                Text(
                  'Version 1.0.0',
                  style: kLargeTextStyle,
                ),
                SizedBox(height: 20),
                Text(
                  'Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'This app detects gas leakage and sends notifications to the user. The app also provides real-time gas concentration levels and alerts the user when the concentration exceeds a certain limit.',
                  style: kNormalTextStyle,
                ),
                SizedBox(height: 20),
                Text(
                  'Developed by:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Martin & Harry',
                  style: kLargeTextStyle,
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
