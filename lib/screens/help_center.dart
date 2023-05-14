import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

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
              'HELP CENTER',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            background: Container(color: const Color(0xff36373b)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Frequently Asked Questions:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const FaqTile(
                  question: 'What should I do if I detect a gas leak?',
                  answer:
                      'If you detect a gas leak, open all doors and windows to allow for ventilation and evacuate the area immediately. Do not turn on or off any electrical switches, or use any electronic devices, as this could cause a spark and ignite the gas. Call the emergency gas company and wait for them to arrive before returning to the area.',
                ),
                const FaqTile(
                  question: 'How often should I replace the gas sensor?',
                  answer:
                      'We recommend replacing the gas sensor every six months to ensure accurate and reliable detection. However, if the device shows any signs of malfunction or produces false alarms, please contact customer support for assistance.',
                ),
                const SizedBox(height: 20),
                const Text(
                  'Contact Information:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: const Text(
                    'support@gasleakagedetection.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () async {
                    final Uri params = Uri(
                      scheme: 'mailto',
                      path: 'martinmzumara08@gmail.com',
                      query: 'subject=Gas Leakage Detection Support',
                    );
                    final emailLaunch = await launchUrl(params);
                    if (!emailLaunch) {
                      // Handle error opening email app
                    }
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  child: const Text(
                    '+265 884-630-834',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () async {
                    final Uri params = Uri(
                      scheme: 'tel',
                      path: '+265884630834',
                    );
                    final phoneLaunch = await launchUrl(params);
                    if (!phoneLaunch) {
                      // Handle error opening phone dialer
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tutorials and Guides:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const TutorialTile(
                  title: 'How to install the Gas Sensor',
                  videoUrl: 'https://youtu.be/cmL7QgTNv7M',
                ),
                const TutorialTile(
                  title: 'How to configure the App Settings',
                  videoUrl: 'https://www.youtube.com/watch?v=def456',
                ),
                const SizedBox(height: 20),
                const Text(
                  'Troubleshooting:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const TroubleshootingTile(
                  title: 'False Alarms',
                  solution:
                      'Make sure the device is installed in a well-ventilated area and away from any sources of heat or steam, as this could cause false alarms. Check the sensitivity level and adjust it accordingly. If the issue persists, please contact customer support for assistance.',
                ),
                const TroubleshootingTile(
                  title: 'Device Not Responding',
                  solution:
                      'Check the batteries and replace them if necessary. Make sure the device is connected to the app and the internet. If the issue persists, please contact customer support for assistance.',
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}

class FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const FaqTile({Key? key, required this.question, required this.answer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        const SizedBox(height: 10),
        Text(answer),
      ],
    );
  }
}

class TutorialTile extends StatelessWidget {
  final String title;
  final String videoUrl;

  const TutorialTile({Key? key, required this.title, required this.videoUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: GestureDetector(
          onTap: () {
            _launchURL(videoUrl);
          },
          child: const Icon(Icons.play_arrow)),
      // onTap: () {
      //   showVideoPlayer(videoUrl, context);
      // },
    );
  }

  void _launchURL(String myUrl) async {
    final String url = myUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SnackBar(
        content: Text('Could not launch $url'),
      );
    }
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final String videoId;
  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player')),
      body: YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        ),
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
      ),
    );
  }
}

class TroubleshootingTile extends StatelessWidget {
  final String title;
  final String solution;

  const TroubleshootingTile(
      {Key? key, required this.title, required this.solution})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        const SizedBox(height: 10),
        Text(solution),
      ],
    );
  }
}
