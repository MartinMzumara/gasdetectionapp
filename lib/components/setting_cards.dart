import 'package:flutter/material.dart';

import '../utils/constants.dart';

class SettingsCard extends StatelessWidget {
  final String cardName;
  final IconData iconName;
  final VoidCallback onTap;
  const SettingsCard(
      {super.key,
      required this.cardName,
      required this.iconName,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xffd3d3d4)
          : const Color(0xff232529),
      elevation: 0,
      child: GestureDetector(
        onTap: onTap,
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
      ),
    );
  }
}
