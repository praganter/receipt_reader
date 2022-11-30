import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeProvider extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;
  String? _path;
  int currentStep = 0;

  get image => _image;
  get path => _path;

  Future getImage(ImageSource source) async {
    _image = null;
    _path = null;
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
  }

  _processPickedFile(XFile file) {
    if (file.path == null) {
      return;
    }
    _image = File(file.path);
    _path = file.path;
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
