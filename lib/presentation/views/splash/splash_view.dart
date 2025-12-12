import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main_layout.dart';
import '../onboarding/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      checkOnboarding(context);
    });
  }

  void checkOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    if (seenOnboarding) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainLayout()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => OnboardingView()));
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/qr.png',
              width: 230,
              height: 230,
            )
                .animate()
                .fade(duration: 1200.ms)
                .scale(duration: 1200.ms)
                .rotate(duration: 1200.ms),

            const SizedBox(height: 50),

            Text(
              "Event Registration",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            )
                .animate()
                .fade(duration: 1200.ms)
                .scale(duration: 1200.ms)
                .rotate(duration: 1200.ms),
          ],
        ),
      ),
    );
  }
}