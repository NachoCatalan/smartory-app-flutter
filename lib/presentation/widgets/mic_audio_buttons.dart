import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/services.dart';

class AudioMedia extends StatefulWidget {
  const AudioMedia({super.key});

  @override
  State<AudioMedia> createState() => _AudioMediaState();
}

class _AudioMediaState extends State<AudioMedia> {
  final AudioService audioService = AudioService();
  final AudioPlayerService audioPlayerService = AudioPlayerService();
  final SendAudioService sendAudioService = SendAudioService();

  bool isRecording = false;
  String? audioPath;

  Future<void> startRecording() async {
    await audioService.startRecording();
    setState(() {
      isRecording = true;
      audioPath = null;
    });
  }

  Future<String?> stopRecording() async {
    final path = await audioService.stopRecording();
    setState(() {
      isRecording = false;
      audioPath = path;
    });
    return path;
  }

  Future<void> sendAudio() async {
    await sendAudioService.sendAudio(audioPath!);
  }

  Future<void> deleteAudio() async {
    try {
      File file = File(audioPath!);
      if (await file.exists()) {
        await file.delete();
        setState(() {
          audioPath = null;
        });
      }
    } catch (e) {
      throw Exception('Error al eliminar audio');
    }
  }

  @override
  void initState() {
    super.initState();
    audioService.init();
  }

  @override
  void dispose() {
    audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: (audioPath != null)
              ? MediaButtons(
                  key: const ValueKey('media-buttons'),
                  audioPath: audioPath,
                  deleteAudio: deleteAudio,
                  sendAudio: sendAudio,
                )
              : MicButton(
                  key: const ValueKey('mic-button'),
                  isRecording: isRecording,
                  startRecording: startRecording,
                  stopRecording: stopRecording,
                ),
        ),
      ],
    );
  }
}

class MediaButtons extends StatelessWidget {
  final String? audioPath;
  final AudioPlayerService audioPlayerService = AudioPlayerService();

  final Future<void> Function() deleteAudio;
  final Future<void> Function() sendAudio;

  MediaButtons({
    super.key,
    required this.audioPath,
    required this.deleteAudio,
    required this.sendAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orangeAccent,
          ),
          child: IconButton(
            onPressed: deleteAudio,
            icon: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orangeAccent,
          ),
          child: IconButton(
            onPressed: () {
              audioPlayerService.start(audioPath!);
            },
            icon: Icon(Icons.play_arrow, color: Colors.white, size: 50),
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orangeAccent,
          ),
          child: IconButton(
            onPressed: sendAudio,
            icon: Icon(Icons.send_outlined, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class MicButton extends StatelessWidget {
  const MicButton({
    super.key,
    required this.isRecording,
    required this.startRecording,
    required this.stopRecording,
  });

  final bool isRecording;
  final Future<void> Function() startRecording;
  final Future<String?> Function() stopRecording;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) async {
        await startRecording();
      },
      onLongPressEnd: (_) async {
        await stopRecording();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: isRecording ? Colors.deepOrange : Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: 74,
          height: 74,
          child: Icon(Icons.mic_sharp, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}
