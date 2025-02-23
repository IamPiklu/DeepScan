import 'package:authentiscan/pages/demo.dart';
import 'package:authentiscan/pages/model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isFirstTime = await checkFirstTime();
  runApp(MyApp(isFirstTime: isFirstTime));
}

Future<bool> checkFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('first_time') ?? true;

  if (isFirstTime) {
    await prefs.setBool('first_time', false);
  }

  return isFirstTime;
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isFirstTime ? const Demo() : const Model(),
    );
  }
}

