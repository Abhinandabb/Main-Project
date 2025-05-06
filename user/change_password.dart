import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:public_transportation/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Change Password',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const change_password(title: 'Change Password'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class change_password extends StatefulWidget {
  const change_password({super.key, required this.title});
  final String title;

  @override
  State<change_password> createState() => _change_passwordState();
}

class _change_passwordState extends State<change_password> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildPasswordField(
              controller: currentPasswordController,
              label: "Current Password",
              obscureText: _obscureCurrent,
              toggle: () {
                setState(() => _obscureCurrent = !_obscureCurrent);
              },
            ),
            const SizedBox(height: 20),
            _buildPasswordField(
              controller: newPasswordController,
              label: "New Password",
              obscureText: _obscureNew,
              toggle: () {
                setState(() => _obscureNew = !_obscureNew);
              },
            ),
            const SizedBox(height: 20),
            _buildPasswordField(
              controller: confirmPasswordController,
              label: "Confirm Password",
              obscureText: _obscureConfirm,
              toggle: () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : sendData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Update Password", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> sendData() async {
    setState(() => _isLoading = true);

    String currentPass = currentPasswordController.text.trim();
    String newPass = newPasswordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    if (currentPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required");
      setState(() => _isLoading = false);
      return;
    }

    if (newPass != confirmPass) {
      Fluttertoast.showToast(msg: "Passwords do not match");
      setState(() => _isLoading = false);
      return;
    }
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');
    if (!passwordRegex.hasMatch(newPass)) {
      Fluttertoast.showToast(
        msg: "Password must contain uppercase, lowercase, and a digit",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() => _isLoading = false);
      return;
    }


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString('url');
    String? lid = prefs.getString('lid');

    if (url == null || lid == null) {
      Fluttertoast.showToast(msg: "Missing user info");
      setState(() => _isLoading = false);
      return;
    }

    final uri = Uri.parse('$url/u_change_passw/');

    try {
      final response = await http.post(uri, body: {
        'currentpass': currentPass,
        'newpass': newPass,
        'confirmpass': confirmPass,
        'lid': lid,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: "Password changed successfully");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const login(title: "Login")),
          );
        } else {
          Fluttertoast.showToast(msg: "Incorrect current password");
        }
      } else {
        Fluttertoast.showToast(msg: "Server error. Try again later.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }

    setState(() => _isLoading = false);
  }
}
