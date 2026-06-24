import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../network/reverb_service.dart';

class GlobalSosListener extends StatefulWidget {
  final Widget child;

  const GlobalSosListener({super.key, required this.child});

  @override
  State<GlobalSosListener> createState() => _GlobalSosListenerState();
}

class _GlobalSosListenerState extends State<GlobalSosListener> {
  late final StreamSubscription _sosSubscription;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isShowingAlert = false;

  @override
  void initState() {
    super.initState();
    _sosSubscription = ReverbService().sosStream.listen(_handleSosEvent);
  }

  @override
  void dispose() {
    _sosSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleSosEvent(dynamic eventData) async {
    if (_isShowingAlert) return;
    _isShowingAlert = true;

    // Play a loud sound
    // Using a remote siren URL for testing or falling back to local asset if configured
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // loop until dismissed
      await _audioPlayer.play(UrlSource('https://actions.google.com/sounds/v1/alarms/bugle_tune.ogg')); 
      // Replace with: AssetSource('audio/siren.mp3') when available locally
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false, // Must be dismissed explicitly
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red.shade900,
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 40),
              SizedBox(width: 10),
              Text(
                'SOS ALERT',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Emergency triggered!\nData: $eventData',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _audioPlayer.stop();
                _isShowingAlert = false;
                Navigator.of(context).pop();
              },
              child: const Text(
                'DISMISS',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
