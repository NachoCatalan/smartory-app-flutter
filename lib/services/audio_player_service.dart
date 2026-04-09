import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> start(String path) async {
    await _audioPlayer.play(DeviceFileSource(path));
  }

  Future<void> pause(String path) async {
    await _audioPlayer.pause();
  }
  void dispose() {
    _audioPlayer.dispose();
  }
}