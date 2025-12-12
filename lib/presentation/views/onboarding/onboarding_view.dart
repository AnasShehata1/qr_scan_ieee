import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main_layout.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  Future<void> completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainLayout()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 70),
            Image.asset(
              'assets/logo.png',
              color: Colors.blue[900],
              width: 230,
              height: 230,
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Center(
                child: Column(children: [
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    thickness: 3,
                    indent: 130,
                    endIndent: 130,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Go and enjoy our features for free and',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'make your life easy with us',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () => completeOnboarding(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: 15),
                          Text(
                            'Lets Go',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.arrow_forward,
                              size: 2, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
