// @dart=2.9
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Rotation extends StatefulWidget {
  @override
  _RotationState createState() => _RotationState();
}

class _RotationState extends State<Rotation> with TickerProviderStateMixin {
  AnimationController animController;
  Animation flipAnimation;
  Animation positionAnimation;

  @override
  void initState() {
    print("My card init State");
    super.initState();
    animController =
        new AnimationController(vsync: this, duration: Duration(seconds: 3));
    flipAnimation = Tween<double>(begin: 1.0, end: 0).animate(animController);
    positionAnimation =
        Tween<double>(begin: 40.0, end: 240.0).animate(animController);

    animController.forward();
  }

  @override
  void didUpdateWidget(Rotation oldWidget) {
    animController.reset();
    animController.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return PositionTransition(
      position: positionAnimation,
      flip: flipAnimation,
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}

class PositionTransition extends AnimatedWidget {
  PositionTransition({
    @required Animation<double> position,
    @required this.flip,
  }) : super(listenable: position);

  final Animation<double> flip;

  @override
  Widget build(BuildContext context) {
    final position = super.listenable as Animation<double>;
    return Positioned(
      top: position.value,
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.rotationX(math.pi * flip.value),
        child: flip.value >= 0.5
            ? Container(
                width: 100,
                height: 128,
                decoration: BoxDecoration(color: Colors.deepOrange),
              )
            : Container(
                width: 100,
                height: 128,
                decoration: BoxDecoration(color: Colors.amber),
              ),
      ),
    );
  }
}
