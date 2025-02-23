import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model.dart'; // Import Model page

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Lock orientation to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://godse-07.github.io/Flutter_three_js/'));

    // Navigate to Model page after 5 seconds
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Model()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Title
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: const Text(
                "DeepScan",
                style: TextStyle(
                  fontFamily: 'space_age',
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),

            // Spacer to push WebView to the center
            const Spacer(),

            // WebView in the middle with a fixed height
            SizedBox(
              height: 400, // Adjust height as needed
              child: WebViewWidget(controller: _controller),
            ),

            // Spacer to push the loading animation to the bottom
            const Spacer(),

            // Loading animation at the bottom
            LoadingAnimationWidget.horizontalRotatingDots(
              color: Colors.white,
              size: 60,
            ),

            const SizedBox(height: 20), // Add some space at the bottom
          ],
        ),
      ),
    );
  }
}
