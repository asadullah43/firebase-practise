import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practise/ui/widget/round_button.dart';
import 'package:firebase_practise/utils/utils.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  final postController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Post")),
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
              String id = DateTime.now().millisecondsSinceEpoch.toString();
              databaseRef.child(id).set({
                'title': postController.text.toString(),
                'id': id,
              }).then((value) {
                Utils().toastMessage('Post Added');
                setState(() {
                  loading = false;
                });
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
                setState(() {
                  loading = false;
                });
              });
            },
          )
        ]),
      ),
    );
  }
}
