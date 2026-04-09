import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioService {

  final _recorder = AudioRecorder();

  Future<bool> init() async {
    return await _recorder.hasPermission();
  }

  Future<void> startRecording() async {
    final path = await getAudioPath();
    await _recorder.start(const RecordConfig(), path: path);
  }

  Future<String?> stopRecording() async {
    return await _recorder.stop();
  }

  Future<void> cancelRecording() async {
    await _recorder.cancel();
  }
  
  void dispose() {
    _recorder.dispose();
  }

  static Future<String> getAudioPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/audio_${DateTime.now().microsecondsSinceEpoch}.m4a';
  }
}