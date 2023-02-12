import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practise/ui/widget/round_button.dart';
import 'package:firebase_practise/utils/utils.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool loading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_rounded),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundButton(
              title: 'Forgot Password',
              onTap: () {
                setState(() {
                  loading = true;
                });

                auth
                    .sendPasswordResetEmail(
                        email: emailController.text.toString())
                    .then((value) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage('Check email');
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              },
              loading: loading,
            )
          ],
        ),
      ),
    );
  }
}
