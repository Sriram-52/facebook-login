import 'package:facebook/services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print(user);
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            padding: EdgeInsets.all(3),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user?.photoURL ?? ""),
            )),
        toolbarHeight: kToolbarHeight + 10,
        title: Text("${user?.displayName}"),
        actions: [
          ElevatedButton(
            onPressed: () {
              _firebaseService.signOut();
            },
            child: Text("SIGN OUT"),
            style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
          )
        ],
      ),
      body: Container(),
    );
  }
}
