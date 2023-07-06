import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'main.dart';

class ButtonController extends StatelessWidget {
  final MyGeorgeGame game;

  const ButtonController({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.volume_up_rounded),
          color: Colors.pink.shade200,
          onPressed: () {
            FlameAudio.bgm.play('music.mp3');
            print('Button pressed');
          },
        ),
        IconButton(
          icon: const Icon(Icons.volume_off_rounded),
          color: Colors.pink.shade200,
          onPressed: () {
            FlameAudio.bgm.stop();
            print('Button pressed');
          },
        ),
      ],
    );
  }
}
