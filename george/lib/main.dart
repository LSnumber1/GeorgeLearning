import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame/src/experimental/geometry/shapes/shape.dart';
import 'package:flame/widgets.dart';
import 'package:flame/camera.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'button_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp(
    MaterialApp(
        home: Scaffold(
            body: GameWidget(
      game: MyGeorgeGame(),
      overlayBuilderMap: {
        'ButtonController': (BuildContext context, MyGeorgeGame game) {
          return ButtonController(game: game);
        }
      },
    ))),
  );
}

class MyGeorgeGame extends FlameGame with TapDetector {
  late SpriteAnimation downAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation idleAnimation;

  late SpriteAnimationComponent george;
  late SpriteComponent backgroud;

  final world = World();
  late final CameraComponent cameraComponent;
  // 0=idle, 1=down, 2=left, 3=right, 4=up
  int direction = 0;
  final double animationSpeed = .1;
  final double characterSize = 100;
  final double characterSpeed = 40;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder.anchor = Anchor.topLeft;

    addAll([cameraComponent, world]);

    Sprite backgroundSprite = await loadSprite('background.png');
    backgroud = SpriteComponent()
      ..sprite = backgroundSprite
      ..size = backgroundSprite.originalSize;
    // add(backgroud);
    FlameAudio.bgm.initialize();
    FlameAudio.audioCache.load('music.mp3');
    world.add(backgroud);

    overlays.add("ButtonController");

    final spriteSheet = SpriteSheet(
        image: await images.load('george.png'), srcSize: Vector2(48, 48));

    downAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 4);
    leftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: animationSpeed, to: 4);
    rightAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: animationSpeed, to: 4);
    upAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: animationSpeed, to: 4);
    idleAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 1);

    george = SpriteAnimationComponent()
      ..animation = idleAnimation
      ..position = Vector2(100, 200)
      ..size = Vector2.all(characterSize);

    // add(george);
    world.add(george);
    // cameraComponent.follow(george);

    // camera.followComponent(george,
    //     worldBounds: Rect.fromLTRB(0, 0, backgroud.size.x, backgroud.size.y));
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    switch (direction) {
      case 1:
        george.animation = downAnimation;
        if (george.y < backgroud.size.y - george.height) {
          george.y += dt * characterSpeed;
        }

        break;
      case 2:
        george.animation = leftAnimation;
        if (george.x > 0) {
          george.x -= dt * characterSpeed;
        }

        break;
      case 3:
        george.animation = rightAnimation;
        if (george.y > 0) {
          george.y -= dt * characterSpeed;
        }
        break;
      case 4:
        george.animation = upAnimation;
        if (george.x < backgroud.size.x - george.width) {
          george.x += dt * characterSpeed;
        }

        break;
      default:
        george.animation = idleAnimation;
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    direction += 1;
    if (direction > 4) {
      direction = 0;
    }

    print("click");
  }
}
