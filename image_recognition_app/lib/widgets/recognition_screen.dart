import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../image_classifier.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  File? _image;
  String _result = "Select an image to classify";
  final ImagePicker _picker = ImagePicker();
  late ImageClassifier _classifier;

  @override
  void initState() {
    super.initState();
    _classifier = ImageClassifier();
    _classifier.loadModel(); // Initialize model on startup
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = "Processing...";
      });
      _classifyImage();
    }
  }

  Future<void> _classifyImage() async {
    if (_image == null) return;

    final result = await _classifier.classifyImage(_image!);
    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edge Image Recognition'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying the selected image
            if (_image == null)
              const Text('No image selected.')
            else
              Image.file(_image!, height: 300, fit: BoxFit.cover),
            const SizedBox(height: 20),
            // Displaying the AI model result
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _result,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              label: const Text('Select from Gallery'),
            ),
            const SizedBox(height: 40),
            const Text(
              'Developed by Desmond',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
