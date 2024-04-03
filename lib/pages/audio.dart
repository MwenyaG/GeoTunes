import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const AudioPlayerApp());

class AudioPlayerApp extends StatelessWidget {
  const AudioPlayerApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoTunes',
      home: AudioPlayerScreen(),
    );
  }
}

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioCache audioCache;
  AudioPlayer? audioPlayer;

  @override
  void initState() {
    super.initState();
    audioCache = AudioCache();
  }

  @override
  void dispose() {
    audioPlayer?.stop();
    super.dispose();
  }

  void playAudio() async {
    audioPlayer = await audioCache.play("spd.mp3");
  }

  void stopAudio() {
    audioPlayer?.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GeoTunes',
          style: TextStyle(
            color: Colors.teal, // Change the text color here
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange[50],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome to the GeoTunes!\nPlay soothing songs to help you relax and unwind.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 27),
              ),
            ),
          ),
          Expanded(
            flex: 4, // Add a flex value to give more space to the image and buttons
            child: SingleChildScrollView( // Add SingleChildScrollView here
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/relax.jpg', // Replace this with your image asset path
                    width: 400,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Row(
                    // Use Row instead of Column for side-by-side layout
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        color: Colors.blue,
                        iconSize: 60,
                        onPressed: () {
                          playAudio();
                        },
                      ),
                      SizedBox(width: 10), // Add some spacing between the buttons
                      Text(
                        'Play',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 20), // Add more spacing between the buttons
                      IconButton(
                        icon: Icon(Icons.stop),
                        color: Colors.red,
                        iconSize: 60,
                        onPressed: () {
                          stopAudio();
                        },
                      ),
                      SizedBox(width: 10), // Add some spacing between the buttons
                      Text(
                        'Stop',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}






