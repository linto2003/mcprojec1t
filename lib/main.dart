import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mcproj/auth/logIn.dart';
import 'package:mcproj/pages/home.dart';
import 'package:mcproj/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (settings) => getRoutes(routeSettings: settings),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator if authentication state is still loading
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            // User is signed in, show home page
            return HomePage();
          } else {
            // User is not signed in, show login page
            return LoginPage();
          }
        },
      ),
    );
  }
}
