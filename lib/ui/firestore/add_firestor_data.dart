import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practise/ui/widget/round_button.dart';
import 'package:firebase_practise/utils/utils.dart';
import 'package:flutter/material.dart';

class AddFireStoreData extends StatefulWidget {
  const AddFireStoreData({super.key});

  @override
  State<AddFireStoreData> createState() => _AddFireStoreDataState();
}

class _AddFireStoreDataState extends State<AddFireStoreData> {
  final postController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Post FireStore")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: postController,
            maxLines: 4,
            decoration: const InputDecoration(
                hintText: 'What is in your mind', border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 30,
          ),
          RoundButton(
            loading: loading,
            title: 'Add',
            onTap: () {
              setState(() {
                loading = true;
              });
              String id = DateTime.now().microsecondsSinceEpoch.toString();
              fireStore.doc(id).set({
                'title': postController.text.toString(),
                'id': id,
              }).then((value) {
                setState(() {
                  loading = false;
                });
                Utils().toastMessage('Post added');
              }).onError((error, stackTrace) {
                setState(() {
                  loading = false;
                });
                Utils().toastMessage(error.toString());
              });
            },
          )
        ]),
      ),
    );
  }
}
