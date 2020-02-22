import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:toast/toast.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class SecondScreenState extends State<SecondScreen> {

  File _image;

  void _upload(List<String> labelTexts) async{
    var uuid = Uuid();

    final String uid = uuid.v4();
    final String downloadURL = await _uploadFile(uid);

    await _addItem(downloadURL, labelTexts);
  }


  Future<List<String>> detectLabels() async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(
        _image);
    final ImageLabeler cloudLabeler = FirebaseVision.instance.cloudImageLabeler();

    final List<ImageLabel> cloudLabels = await cloudLabeler.processImage(visionImage);

    List<String> labelTexts = new List();
    for (ImageLabel label in cloudLabels) {
      final String text = label.text;
      final String entityId = label.entityId;
      final double confidence = label.confidence;
      labelTexts.add(text);
    }

  }

  Future<String> _uploadFile(filename) async {
//    final File file = _image;
    final StorageReference ref = FirebaseStorage.instance.ref().child('$filename.jpg');
    final StorageUploadTask uploadTask = ref.putFile(
      _image,
      StorageMetadata(
        contentLanguage: 'en',
      ),
    );

    final downloadURL = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadURL.toString();
  }

  Future<void> _addItem(String downloadURL, List<String> labels) async {
    await Firestore.instance.collection('people').add(<String, dynamic>{
      'downloadURL': downloadURL,
      'labels': labels,
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
            ? Text('No image selected.')
            : Image.file(_image);
          ]
        )
    );
  }
}

class SecondScreen extends StatefulWidget {
  SecondScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  SecondScreenState createState() => new SecondScreenState();

}