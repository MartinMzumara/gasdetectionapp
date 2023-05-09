import 'package:flutter/material.dart';
import 'package:gasdetector/utils/constants.dart';

class GasIndicator extends StatelessWidget {
  final double gasLevel; // gas concentration level
  final double minLevel; // minimum safe level
  final double maxLevel; // maximum safe level

  const GasIndicator({
    Key? key,
    required this.gasLevel,
    required this.minLevel,
    required this.maxLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    // Determine the color and text based on the gas level
    if (gasLevel < minLevel) {
      color = Colors.green;
      text = 'Safe';
    } else if (gasLevel > maxLevel) {
      color = Colors.red;
      text = 'Danger';
    } else {
      color = Colors.orange;
      text = 'Warning';
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xffe9e9ea)
                : const Color(0xff393b3e),
          ),
          alignment: const Alignment(1.0, 1.0),
          height: 170,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Baseline(
              //   baseline: 80,
              //   baselineType: TextBaseline.alphabetic,
              //   child: Text(
              //     '$gasLevel',
              //     style: const TextStyle(
              //       fontSize: 80,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // const Baseline(
              //   baseline: 10,
              //   baselineType: TextBaseline.alphabetic,
              //   child: Text(
              //     'PPM',
              //     style: TextStyle(
              //       fontSize: 32,
              //       textBaseline: TextBaseline.alphabetic,
              //     ),
              //   ),
              // ),
              RichText(
                text: TextSpan(
                  text: '$gasLevel ',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.light
                        ? kBackgroundColor
                        : kUnselectedIcon,
                  ),
                  children: const [
                    TextSpan(
                      text: 'PPM',
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 16,
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: color,
                ),
                height: 30,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? kBackgroundColor
                    : kUnselectedIcon,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
