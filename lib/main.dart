import 'package:facebook/auth_wrapper.dart';
import 'package:facebook/services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().catchError((err) {
    print("@@firebase error: ${err.toString()}");
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final FirebaseService _firebaseService = FirebaseService();
 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>(
          create: (context) => _firebaseService.onAuthStateChanged,
          initialData: null,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}
