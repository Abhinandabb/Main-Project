// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:public_transportation/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Public Transportation',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const changepassword(title: 'Change Password'),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class changepassword extends StatefulWidget {
//   const changepassword({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<changepassword> createState() => _changepasswordState();
// }
//
// class _changepasswordState extends State<changepassword> {
//   final TextEditingController current_password_controller = TextEditingController();
//   final TextEditingController new_password_controller = TextEditingController();
//   final TextEditingController confirm_password_controller = TextEditingController();
//
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Colors.blue[800],
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: <Widget>[
//             const SizedBox(height: 30),
//             _buildPasswordField(current_password_controller, "Current Password"),
//             const SizedBox(height: 16),
//             _buildPasswordField(new_password_controller, "New Password"),
//             const SizedBox(height: 16),
//             _buildPasswordField(confirm_password_controller, "Confirm Password"),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _isLoading ? null : senddata,
//                 icon: const Icon(Icons.lock_reset),
//                 label: Text(_isLoading ? 'Updating...' : 'Update Password'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).colorScheme.primary,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   textStyle: const TextStyle(fontSize: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPasswordField(TextEditingController controller, String label) {
//     return TextField(
//       controller: controller,
//       obscureText: true,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: const Icon(Icons.lock),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
//
//   Future<void> senddata() async {
//     setState(() => _isLoading = true);
//
//     final currentpass = current_password_controller.text;
//     final newpass = new_password_controller.text;
//     final confirmpass = confirm_password_controller.text;
//
//     if (newpass != confirmpass) {
//       Fluttertoast.showToast(msg: 'Passwords do not match');
//       setState(() => _isLoading = false);
//       return;
//     }
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     final url = sh.getString('url') ?? '';
//     final lid = sh.getString('lid') ?? '';
//
//     final uri = Uri.parse('$url/d_change_password/');
//
//     try {
//       final response = await http.post(uri, body: {
//         'currentpass': currentpass,
//         'newpass': newpass,
//         'confirmpass': confirmpass,
//         'lid': lid,
//       });
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == 'ok') {
//           Fluttertoast.showToast(msg: 'Password changed successfully');
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const login(title: "Login")),
//           );
//         } else {
//           Fluttertoast.showToast(msg: 'Incorrect current password');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
//     }
//
//     setState(() => _isLoading = false);
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_transportation/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Public Transportation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const changepassword(title: 'Change Password'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class changepassword extends StatefulWidget {
  const changepassword({super.key, required this.title});

  final String title;

  @override
  State<changepassword> createState() => _changepasswordState();
}

class _changepasswordState extends State<changepassword> {
  final TextEditingController current_password_controller = TextEditingController();
  final TextEditingController new_password_controller = TextEditingController();
  final TextEditingController confirm_password_controller = TextEditingController();

  bool _isLoading = false;

  // Password visibility toggles
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            _buildPasswordField(
              current_password_controller,
              "Current Password",
              _showCurrent,
                  () {
                setState(() {
                  _showCurrent = !_showCurrent;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              new_password_controller,
              "New Password",
              _showNew,
                  () {
                setState(() {
                  _showNew = !_showNew;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              confirm_password_controller,
              "Confirm Password",
              _showConfirm,
                  () {
                setState(() {
                  _showConfirm = !_showConfirm;
                });
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : senddata,
                icon: const Icon(Icons.lock_reset),
                label: Text(_isLoading ? 'Updating...' : 'Update Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller,
      String label,
      bool isVisible,
      VoidCallback toggleVisibility,
      ) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> senddata() async {
    setState(() => _isLoading = true);

    final currentpass = current_password_controller.text;
    final newpass = new_password_controller.text;
    final confirmpass = confirm_password_controller.text;

    if (newpass != confirmpass) {
      Fluttertoast.showToast(msg: 'Passwords do not match');
      setState(() => _isLoading = false);
      return;
    }
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');
    if (!passwordRegex.hasMatch(newpass)) {
      Fluttertoast.showToast(
        msg: "Password must contain uppercase, lowercase, and a digit",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() => _isLoading = false);
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    final url = sh.getString('url') ?? '';
    final lid = sh.getString('lid') ?? '';

    final uri = Uri.parse('$url/d_change_password/');

    try {
      final response = await http.post(uri, body: {
        'currentpass': currentpass,
        'newpass': newpass,
        'confirmpass': confirmpass,
        'lid': lid,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Password changed successfully');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const login(title: "Login")),
          );
        } else {
          Fluttertoast.showToast(msg: 'Incorrect current password');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }

    setState(() => _isLoading = false);
  }
}
