import 'package:catatan_keuangan/screens/auth/login_screen.dart';
import 'package:catatan_keuangan/screens/homepage/homepage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// main program untuk memulai aplikasi
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/images/blur.jpg',
            fit: BoxFit.cover,
          ),
        ),
    );
  }
}

class Init {
  Init._();

  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(const Duration(milliseconds: 2500));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        /// Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: Splash());
        } else {
          /// cek apakah pengguna sudah login sebelumnya atau belum, jika sudah langsung masuk ke homepage, jika belum masuk ke login
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            return MaterialApp(
              theme: ThemeData(
                fontFamily: 'Saira',
              ),
              home: HomepageScreen(),
            );
          } else {
            return MaterialApp(
              theme: ThemeData(
                fontFamily: 'Saira',
              ),
              home: LoginScreen(),
            );
          }
        }
      },
    );
  }
}
