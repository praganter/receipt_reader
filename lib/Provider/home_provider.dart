import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HomeProvider extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;
  String? _path;
  bool? _isAcceptable;
  String _scannedText = "";

  int currentStep = 0;

  get image => _image;
  get path => _path;
  get isAcceptable => _isAcceptable;
  get scannedText => _scannedText;

  Future getImage(ImageSource source) async {
    _image = null;
    _path = null;
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _path = pickedFile.path;
      await _imageLaberlerJob();
    }
    notifyListeners();
  }

  Future<void> _imageLaberlerJob() async {
    const path = "assets/ml/object_labeler.tflite";
    final modelPath = await _getModel(path);
    final options = LocalLabelerOptions(modelPath: modelPath);
    final imageLabeler = ImageLabeler(options: options);
    await _processImage(InputImage.fromFilePath(this.path), imageLabeler);
    if (_isAcceptable != null) {
      _isAcceptable!
          ? await _getText(
              InputImage.fromFilePath(this.path),
            )
          : null;
    }
  }

  Future<String> _getModel(String assetPath) async {
    if (Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  Future<void> _processImage(InputImage inputImage, ImageLabeler imageLabeler) async {
    final labels = await imageLabeler.processImage(inputImage);
    bool bBool = false;
    for (var element in labels) {
      if (element.label.toLowerCase().contains("receipt") && element.confidence >= 0.65) {
        bBool = true;
        break;
      }
    }
    bBool ? _isAcceptable = true : _isAcceptable = false;
    notifyListeners();
  }

  _getText(
    InputImage inputImage,
  ) async {
    _scannedText = "";
    final recognizedText = await TextRecognizer().processImage(inputImage);
    List<TextLine> totalLines = [];
    Map<int, String> seperatedRows = {};
    for (var element in recognizedText.blocks) {
      totalLines.addAll(element.lines);
    }
    print(totalLines.length.toString());
    for (var i = 0; i < totalLines.length; i++) {
      String tempRow = totalLines[i].text;
      for (var j = i + 1; j < totalLines.length; j++) {
        double baseBottom = totalLines[i].boundingBox.top;
        double baseHeight = totalLines[i].boundingBox.height;
        double currentBottom = totalLines[j].boundingBox.top;
        if (((baseBottom + baseHeight * 0.8 >= currentBottom) && (baseBottom - baseHeight * 0.8 <= currentBottom)) ||
            (baseBottom == currentBottom)) {
          tempRow += " ${totalLines[j].text} ";
          totalLines.removeAt(j);
          i--;
        }
        if (j == (totalLines.length - 1)) {
          seperatedRows[i] = tempRow.trim();
        }
      }
    }
    print(seperatedRows.toString());
    for (var i = 0; i < seperatedRows.length; i++) {
      _scannedText += "${seperatedRows[i]}" "\n\n";
    }
    notifyListeners();
  }

  nextStep() {
    currentStep++;
    notifyListeners();
  }

  previousStep() {
    currentStep--;
    notifyListeners();
  }
}
