import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:public_transportation/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Logout',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Logout(title: 'Logout'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Logout extends StatefulWidget {
  const Logout({super.key, required this.title});
  final String title;

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  void initState() {
    super.initState();
    logout(); // Automatically call logout on screen load
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Optional: show while logging out
      ),
    );
  }

  logout() async {
    Fluttertoast.showToast(msg: 'Logged out successfully');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => login(title: "Login")),
    );
  }
}
