// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:public_transportation/user/userhome.dart';
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
//       title: 'Send Complaint',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const send_complaints(title: 'Send Complaint'),
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
//   TextEditingController Complaint_controller = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//   bool _isSending = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 "Submit a Complaint",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 30),
//               TextFormField(
//                 controller: Complaint_controller,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   labelText: "Enter your complaint",
//                   hintText: "Type your issue here...",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return "Please enter a complaint.";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton.icon(
//                   onPressed: _isSending
//                       ? null
//                       : () {
//                     if (_formKey.currentState!.validate()) {
//                       sendata();
//                     }
//                   },
//                   icon: _isSending
//                       ? const CircularProgressIndicator(
//                       color: Colors.white, strokeWidth: 2)
//                       : const Icon(Icons.send),
//                   label: Text(
//                     _isSending ? "Sending..." : "Send Complaint",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   sendata() async {
//     setState(() {
//       _isSending = true;
//     });
//
//     String complaint = Complaint_controller.text.trim();
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//
//     final urls = Uri.parse('$url/u_send_complaints/');
//     try {
//       final response = await http.post(urls, body: {
//         'complaint': complaint,
//         'lid': lid,
//       });
//
//       setState(() {
//         _isSending = false;
//       });
//
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status == 'ok') {
//           Fluttertoast.showToast(msg: 'Sent successfully');
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const UserHome(title: "Home")),
//           );
//         } else {
//           Fluttertoast.showToast(msg: 'Submission failed');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network error');
//       }
//     } catch (e) {
//       setState(() {
//         _isSending = false;
//       });
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_transportation/user/userhome.dart';
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
      title: 'Send Complaint',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF4A47A3),
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.grey),
        ),
      ),
      home: const send_complaints(title: 'Send Complaint'),
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
  TextEditingController Complaint_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                // Image.asset(
                //   'assets/images/complaint.png', // Add your own asset
                //   height: 150,
                //   width: 150,
                // ),
                const SizedBox(height: 30),
                Text(
                  "Report an Issue",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We're here to help. Please describe your issue below.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: Complaint_controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Your complaint",
                    hintText: "Describe your issue in detail...",
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please describe your issue";
                    }
                    if (value.trim().length < 10) {
                      return "Please provide more details";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSending
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        sendata();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isSending
                        ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("Submitting..."),
                      ],
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send, size: 20),
                        SizedBox(width: 10),
                        Text(
                          "Submit Complaint",
                          style: TextStyle(fontSize: 16,color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserHome(title: "Home")),
                    );
                  },
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendata() async {
    setState(() {
      _isSending = true;
    });

    String complaint = Complaint_controller.text.trim();
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/u_send_complaints/');
    try {
      final response = await http.post(urls, body: {
        'complaint': complaint,
        'lid': lid,
      });

      setState(() {
        _isSending = false;
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(
            msg: 'Complaint submitted successfully!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserHome(title: "Home")),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Submission failed. Please try again.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Network error occurred',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        _isSending = false;
      });
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}