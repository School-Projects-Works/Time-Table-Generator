import 'package:flutter/material.dart';

class SpritePainter extends CustomPainter {
  final Animation<double> _animation;

  SpritePainter(this._animation) : super(repaint: _animation);

  void roundedRect(Canvas canvas, Rect rect, double animValue, int waveAmount) {
    double opacity = (1.0 - (animValue / waveAmount)).clamp(0.0, 1.0);
    Color color = Color.fromRGBO(225, 0, 0, opacity);

    const pixelMiltiplier = 20;
    final newWidth = rect.width + animValue * pixelMiltiplier;
    final newHeight = rect.height + animValue * pixelMiltiplier;
    final widthIncrease = newWidth / rect.width;
    final heightIncrease = newHeight / rect.height;
    final widthOffset = (widthIncrease - 1) / 2;
    final heightOffet = (heightIncrease - 1) / 2;

    final Paint paint = Paint()..color = color;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(-rect.width * widthOffset, -rect.height * heightOffet,
                rect.width * widthIncrease, rect.height * heightIncrease),
            const Radius.circular(10.0)),
        paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    const waveAmount = 1;

    if (!_animation.isDismissed) {
      for (int wave = waveAmount - 1; wave >= 0; wave--) {
        roundedRect(canvas, rect, wave + _animation.value, waveAmount);
      }
    }
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return true;
  }
}

class BreathingWidget extends StatefulWidget {
  const BreathingWidget({super.key, required this.child});
  final Widget child;

  @override
  State<BreathingWidget> createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<BreathingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
    _controller
      ..stop()
      ..reset()
      ..repeat(period: const Duration(seconds: 1));
    //_startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SpritePainter(_controller),
      child: widget.child,
    );
  }
}
