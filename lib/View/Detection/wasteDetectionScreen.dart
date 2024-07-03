import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';

class WasteDetectionScreen extends StatefulWidget {
  @override
  _WasteDetectionScreenState createState() => _WasteDetectionScreenState();
}

class _WasteDetectionScreenState extends State<WasteDetectionScreen> {
  File? _image;
  List? _recognitions;
  bool _busy = false;
  //Interpreter? _interpreter;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  void _loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
    print('........');
    print(res);
    print('................');
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _busy = true;
        });
        await _detectWaste();
        print("image................." + _image!.path);
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  Future<void> _detectWaste() async {
    if (_image == null) print('Null Image');

    try {
      //print("detect image................." + _image!.path);
      var recognitions = await Tflite.runModelOnImage(
        path: _image!.path,
        numResults: 6,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
      );
      print('..............++++++++++++');
      print(_recognitions?.length);
      setState(() {
        _recognitions = recognitions;
      });
    } catch (e) {
      print('Error detecting waste: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error detecting waste: $e')),
      );
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Waste Detection')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: _image == null
                  ? Text('No image selected.')
                  : Image.file(_image!),
            ),
          ),
          _busy
              ? CircularProgressIndicator()
              : (_recognitions != null && _recognitions!.isNotEmpty)
                  ? Column(
                      children: _recognitions!.map((res) {
                        return Text(
                          "${res["label"]} - ${(res["confidence"] * 100).toStringAsFixed(1)}%",
                          style: TextStyle(fontSize: 18),
                        );
                      }).toList(),
                    )
                  : Container(
                      child: Text('Not detect'),
                    ),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Select Image'),
          ),
        ],
      ),
    );
  }
}
