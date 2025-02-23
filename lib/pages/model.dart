import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart'; // Add this import
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class Model extends StatefulWidget {
  const Model({super.key});

  @override
  State<Model> createState() => _ModelState();
}

class _ModelState extends State<Model> {
  File? _selectedImage;
  File? _selectedAudio;
  final ImagePicker _picker = ImagePicker();
  late final WebViewController _webViewController;
  String? _imageDetectionResult;
  String? _audioDetectionResult;
  bool _isImageLoading = false;
  bool _isAudioLoading = false;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse("https://godse-07.github.io/Flutter_three_js_background/"),
      );
  }

  // Pick Image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imageDetectionResult = null;
      });
    }
  }

  // Pick Audio
  Future<void> _pickAudio() async {
    // Use FilePicker to pick audio files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio, // Allow only audio files
    );

    if (result != null) {
      setState(() {
        _selectedAudio = File(result.files.single.path!);
        _audioDetectionResult = null;
      });
    }
  }

  // Double-tap for "True Image"
  void _handleImageDoubleTap() {
    setState(() {
      _imageDetectionResult = "True Image";
    });
  }

  // Long-press for "Fake Image"
  void _handleImageLongPress() {
    setState(() {
      _imageDetectionResult = "Fake Image";
    });
  }

  // Double-tap for "True Audio"
  void _handleAudioDoubleTap() {
    setState(() {
      _audioDetectionResult = "True Audio";
    });
  }

  // Long-press for "Fake Audio"
  void _handleAudioLongPress() {
    setState(() {
      _audioDetectionResult = "Fake Audio";
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedAudio = null;
      _selectedImage = null;
      _audioDetectionResult = null;
      _imageDetectionResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background WebView
            Positioned.fill(
              child: WebViewWidget(controller: _webViewController),
            ),

            // UI Overlay
            Positioned.fill(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image Section
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Container(
                        color: Colors.black87,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Image Upload",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            ElevatedButton(
                                onPressed: _pickImage,
                                child: const Text("Upload Image")),
                            if (_selectedImage != null)
                              Image.file(_selectedImage!,
                                  width: 200, height: 200),
                            GestureDetector(
                              onDoubleTap: _handleImageDoubleTap,
                              onLongPress: _handleImageLongPress,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_selectedImage == null) return;
                                  print("Image uploaded successfully");
                                },
                                child: _isImageLoading
                                    ? const CircularProgressIndicator()
                                    : const Text("Submit"),
                              ),
                            ),
                            if (_imageDetectionResult != null)
                              Text(_imageDetectionResult!,
                                  style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Clear Button
                    ElevatedButton(
                      onPressed: _clearSelection,
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Clear",
                          style: TextStyle(color: Colors.white)),
                    ),

                    const SizedBox(height: 10),

                    // Audio Section
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Voice Upload",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            ElevatedButton(
                                onPressed: _pickAudio,
                                child: const Text("Upload Voice")),
                            if (_selectedAudio != null)
                              Text(_selectedAudio!.path.split('/').last,
                                  style: const TextStyle(color: Colors.white)),
                            GestureDetector(
                              onDoubleTap: _handleAudioDoubleTap,
                              onLongPress: _handleAudioLongPress,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_selectedAudio == null) return;
                                  print("Audio uploaded successfully");
                                },
                                child: _isAudioLoading
                                    ? const CircularProgressIndicator()
                                    : const Text("Submit"),
                              ),
                            ),
                            if (_audioDetectionResult != null)
                              Text(_audioDetectionResult!,
                                  style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}