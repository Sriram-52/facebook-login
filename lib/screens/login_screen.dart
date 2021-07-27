import 'package:facebook/services/firebase.dart';
import 'package:facebook/utils/loading.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool isLoading = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo App"),
        centerTitle: true,
      ),
      body: Container(
        child: isLoading
            ? Loading()
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("LOGIN WITH FACEBOOK"),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        var res = await _firebaseService.signInWithFaceBook();
                        if (res == null) {
                          setState(() {
                            error = "Failed to login";
                          });
                        }
                        setState(() {
                          isLoading = false;
                        });
                        print(res);
                      },
                    ),
                    Text(error, style: TextStyle(color: Colors.red),)
                  ],
                ),
              ),
      ),
    );
  }
}
