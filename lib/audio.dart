import 'package:flutter/services.dart';

class Audio {
  MethodChannel _audioChannel;
  EventChannel _eventChannel;

  Audio(Function audioEventsCallback) {
    _audioChannel = const MethodChannel('tv.mta/NativeAudioChannel');

    if (audioEventsCallback != null) {
      _eventChannel =
          EventChannel("tv.mta/NativeAudioEventChannel", JSONMethodCodec());

      _eventChannel.receiveBroadcastStream().listen(audioEventsCallback);
    }
  }

  Future<void> play(String url, String title, String subtitle,
      int durationInMilliseconds, Duration position) async {
    await _audioChannel.invokeMethod("play", <String, dynamic>{
      "title": title,
      "subtitle": subtitle,
      "duration": durationInMilliseconds,
      "url": url,
      "position": position.inMilliseconds,
    });
  }

  Future<void> pause() async {
    await _audioChannel.invokeMethod("pause");
  }

  Future<void> stop() async {
    await _audioChannel.invokeMethod("stop");
  }

  Future<void> seekTo(double seconds) async {
    await _audioChannel.invokeMethod("seekTo", <String, dynamic>{
      "second": seconds,
    });
  }

  Future<void> dispose() async {
    await stop();
  }
}
