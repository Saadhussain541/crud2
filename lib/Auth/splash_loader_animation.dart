import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class SplashLoaderAnimation extends StatefulWidget {
  const SplashLoaderAnimation({super.key});

  @override
  State<SplashLoaderAnimation> createState() => _SplashLoaderAnimationState();
}

class _SplashLoaderAnimationState extends State<SplashLoaderAnimation> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.halfTriangleDot(color: Colors.deepPurple, size: 100),
    );
  }
}
