import 'package:flutter/material.dart';

class AnimatedCountingText extends StatefulWidget {
  final int targetScore;
  final Duration duration;

  const AnimatedCountingText(
      {super.key, required this.targetScore, required this.duration});

  @override
  _AnimatedCountingTextState createState() => _AnimatedCountingTextState();
}

class _AnimatedCountingTextState extends State<AnimatedCountingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    const int beginScore = 0;
    final int endScore = widget.targetScore;
    _animation =
        IntTween(begin: beginScore, end: endScore).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Text(
          ' ${_animation.value}/10',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w400,
          ),
        );
      },
    );
  }
}
