import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practise/ui/widget/round_button.dart';
import 'package:firebase_practise/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  // ignore: unused_field
  File? _image;
  final picker = ImagePicker();
  Future getImageFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload image')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageFromGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : const Icon(Icons.image),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundButton(
                loading: loading,
                title: 'Upload',
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  firebase_storage.Reference ref = firebase_storage
                      .FirebaseStorage.instance
                      .ref('/images/' '1');
                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(_image!.absolute);

                  await Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();
                    databaseRef.child('1').set({
                      'id': '1234',
                      'title': newUrl.toString(),
                    }).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage('image uploaded');
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(error.toString());
                    });
                  });
                })
          ],
        ),
      ),
    );
  }
}
