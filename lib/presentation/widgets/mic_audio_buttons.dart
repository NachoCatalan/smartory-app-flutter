
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
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (audioPath != null)
            ? MediaButtons(
                audioPath: audioPath,
                deleteAudio: deleteAudio,
                sendAudio: sendAudio,
              )
            : MicButton(
                isRecording: isRecording,
                startRecording: startRecording,
                stopRecording: stopRecording,
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
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey),
          ),
          child: IconButton(
            onPressed: deleteAudio,
            iconSize: 30,
            icon: Icon(Icons.delete),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 3.5),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: IconButton(
              onPressed: () {
                audioPlayerService.start(audioPath!);
              },
              icon: Icon(Icons.play_arrow, color: Colors.black, size: 40),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey),
          ),
          child: IconButton(
            onPressed: sendAudio,
            iconSize: 30,
            icon: Icon(Icons.arrow_circle_right_outlined),
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
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isRecording ? Colors.redAccent : Colors.deepPurple.shade400,
            width: 3.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(
              Icons.mic_sharp,
              color: isRecording
                  ? Colors.redAccent
                  : Colors.deepPurple.shade400,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}