import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:qr_scan_ieee/presentation/views/splash/splash_view.dart';

import 'constants.dart';
import 'data/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>(user);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IEEE Registration',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: fontFamily,
      ),
      home: const SplashView(),
    );
  }
}
