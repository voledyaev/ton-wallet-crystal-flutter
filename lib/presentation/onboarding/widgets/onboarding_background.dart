import 'package:flutter/material.dart';

/// Background that is used on main screen.
/// It adds gradient behind [child].
class OnboardingBackground extends StatelessWidget {
  final Widget child;

  const OnboardingBackground({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: OnboardingGradient()),
        Positioned.fill(child: child),
      ],
    );
  }
}

class OnboardingGradient extends StatelessWidget {
  const OnboardingGradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: -200,
          top: -100,
          width: 500,
          height: 500,
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                stops: [0.35, 1],
                colors: [
                  Color(0x3D0038FF),
                  Color(0x006557FF),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: -150,
          bottom: -50,
          width: 400,
          height: 400,
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                stops: [0.4, 1],
                colors: [
                  Color(0x335200FF),
                  Color(0x00DD57FF),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}