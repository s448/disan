import 'dart:io';

import 'package:disan/Core/ultis/snakbar.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecordService {
  final _recorder = FlutterSoundRecorder();

  record() async {
    await _recorder.startRecorder(toFile: 'post_audio');
  }

  stop() async {
    final path = await _recorder.stopRecorder();
    final recordFile = File(path!);

    print("recorded audio: $recordFile");
    return recordFile;
  }

  initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      dangerSnackbar("Microphone permission not granted", "");
      return;
    }

    await _recorder.openRecorder();

    _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  openRecord(String url) async {
    final FlutterSoundPlayer player = FlutterSoundPlayer();
    await player.startPlayer(fromURI: url);
  }
}
