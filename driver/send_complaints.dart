// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:public_transportation/driver/driverhome.dart';
// import 'package:shared_preferences/shared_preferences.dart';
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
//       title: 'Send Complaint',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const send_complaints(title: 'Send Complaint'),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class send_complaints extends StatefulWidget {
//   const send_complaints({super.key, required this.title});
//   final String title;
//
//   @override
//   State<send_complaints> createState() => _send_complaintsState();
// }
//
// class _send_complaintsState extends State<send_complaints> {
//   final TextEditingController complaintController = TextEditingController();
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const SizedBox(height: 50),
//             TextField(
//               controller: complaintController,
//               maxLines: 6,
//               decoration: InputDecoration(
//                 labelText: "Enter your complaint",
//                 alignLabelWithHint: true,
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 hintText: "Type your complaint here...",
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : sendData,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   backgroundColor: Theme.of(context).colorScheme.primary,
//                   foregroundColor: Colors.white,
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text("Send Complaint", style: TextStyle(fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> sendData() async {
//     String complaint = complaintController.text.trim();
//     if (complaint.isEmpty) {
//       Fluttertoast.showToast(msg: "Please enter your complaint");
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? url = prefs.getString('url');
//     String? lid = prefs.getString('lid');
//
//     if (url == null || lid == null) {
//       Fluttertoast.showToast(msg: "Missing required information");
//       setState(() => _isLoading = false);
//       return;
//     }
//
//     final uri = Uri.parse('$url/d_send_complaints/');
//
//     try {
//       final response = await http.post(uri, body: {
//         'complaint': complaint,
//         'lid': lid,
//       });
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == 'ok') {
//           Fluttertoast.showToast(msg: 'Complaint sent successfully');
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const DriverHome(title: "Driver Home")),
//           );
//         } else {
//           Fluttertoast.showToast(msg: 'Submission failed');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Server error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: ${e.toString()}");
//     }
//
//     setState(() => _isLoading = false);
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:public_transportation/driver/driverhome.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send Complaint',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade800,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
      home: const send_complaints(title: 'Submit Complaint'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class send_complaints extends StatefulWidget {
  const send_complaints({super.key, required this.title});
  final String title;

  @override
  State<send_complaints> createState() => _send_complaintsState();
}

class _send_complaintsState extends State<send_complaints> {
  final TextEditingController complaintController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Describe your complaint',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please provide detailed information about the issue you encountered',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: complaintController,
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your complaint';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Complaint details",
                  alignLabelWithHint: true,
                  hintText: "Type your complaint here...",
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () {
                    if (_formKey.currentState!.validate()) {
                      sendData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Submit Complaint",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                Center(
                  child: Text(
                    'Submitting your complaint...',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendData() async {
    setState(() => _isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString('url');
    String? lid = prefs.getString('lid');
    String? uid = prefs.getString('uid');

    if (url == null || lid == null) {
      Fluttertoast.showToast(msg: "Missing required information");
      setState(() => _isLoading = false);
      return;
    }

    final uri = Uri.parse('$url/d_send_complaints/');

    try {
      final response = await http.post(uri, body: {
        'complaint': complaintController.text.trim(),
        'lid': lid,
        'uid': uid ?? '',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: 'Complaint submitted successfully',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green.shade700,
            textColor: Colors.white,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DriverHome(title: "Driver Home"),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: data['message'] ?? 'Submission failed',
            backgroundColor: Colors.red.shade700,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Server error occurred',
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Network error: ${e.toString()}",
        backgroundColor: Colors.red.shade700,
        textColor: Colors.white,
      );
    }

    setState(() => _isLoading = false);
  }
}