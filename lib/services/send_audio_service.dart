import 'dart:io';
import 'package:dio/dio.dart';

class SendAudioService {
  final dio = Dio();

  Future<void> sendAudio(String path) async {

    try {
      final url = 'http://192.168.1.9:8000/audio';

      final file = File(path);

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: 'audio.m4a'
        )
      });

      await dio.post(
        url,
        data: formData,  
      );
    } catch (e) {
      throw Exception('Error al enviar el audio $e');
    }
  }
}
