import 'package:flutter/material.dart';

import '../utils/constants.dart';

class SettingsCard extends StatelessWidget {
  final String cardName;
  final IconData iconName;
  const SettingsCard(
      {super.key, required this.cardName, required this.iconName});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xffe9e9ea)
          : const Color(0xff232529),
      elevation: 0,
      child: ListTile(
        title: Text(
          cardName,
          style: kNormalTextStyle,
        ),
        leading: Icon(iconName,
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xff232529)
                : const Color(0xffe6f4ff)),
      ),
    );
  }
}
