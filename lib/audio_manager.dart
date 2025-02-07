import 'package:flutter_soloud/flutter_soloud.dart';

class AudioManager {
  AudioManager._(this.sounds);

  final Map<String, AudioSource> sounds;

  static Future<AudioManager> load() async {
    final soloud = SoLoud.instance;
    await soloud.init();
    final sounds = await Future.wait([
      soloud.loadAsset('assets/sound/nuggets1.wav'),
      soloud.loadAsset('assets/sound/nuggets2.wav'),
      soloud.loadAsset('assets/sound/donkey.mp3'),
      soloud.loadAsset('assets/sound/emma_loser.wav'),
      soloud.loadAsset('assets/sound/rappare.wav'),
    ]);

    final itemSounds = {
      'nuggets1': sounds[0],
      'nuggets2': sounds[1],
      'donkey': sounds[2],
      'emma_loser': sounds[3],
      'rappare': sounds[4],
    };

    return AudioManager._(itemSounds);
  }

  int currentlyPlaying = 0;

  void play(String name) {
    SoLoud.instance.play(sounds[name]!);
  }
}
