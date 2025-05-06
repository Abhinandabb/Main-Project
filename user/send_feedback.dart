// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:public_transportation/user/userhome.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Add this import
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
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const send_feedback(title: 'Flutter Demo Home Page'),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class send_feedback extends StatefulWidget {
//   const send_feedback({super.key, required this.title});
//   final String title;
//
//   @override
//   State<send_feedback> createState() => _send_feedbackState();
// }
//
// class _send_feedbackState extends State<send_feedback> {
//   TextEditingController Review_controller = TextEditingController();
//   TextEditingController Rating_controller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor:Colors.deepPurpleAccent,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextField(
//                 controller: Review_controller,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   label: Text("Review"),
//                 ),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 20),
//               const Text("Rating", style: TextStyle(fontSize: 16)),
//               const SizedBox(height: 10),
//               RatingBar.builder(
//                 initialRating: 3,
//                 minRating: 1,
//                 direction: Axis.horizontal,
//                 allowHalfRating: true,
//                 itemCount: 5,
//                 itemBuilder: (context, _) =>
//                 const Icon(Icons.star, color: Colors.amber),
//                 onRatingUpdate: (rating) {
//                   Rating_controller.text = rating.toString(); // Store in controller
//                 },
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   senddata();
//                 },
//                 child: const Text('Send'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   senddata() async {
//     String review = Review_controller.text;
//     String rating = Rating_controller.text;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//
//     final urls = Uri.parse('$url/u_send_feedback/');
//     try {
//       final response = await http.post(urls, body: {
//         'review': review,
//         'rating': rating,
//         'lid': lid,
//       });
//
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status == 'ok') {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => UserHome(title: "Home")),
//           );
//           Fluttertoast.showToast(msg: 'Sended Successfully');
//         } else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:public_transportation/user/userhome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send Feedback',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const send_feedback(title: 'Send Feedback'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class send_feedback extends StatefulWidget {
  const send_feedback({super.key, required this.title});
  final String title;

  @override
  State<send_feedback> createState() => _send_feedbackState();
}

class _send_feedbackState extends State<send_feedback> {
  TextEditingController Review_controller = TextEditingController();
  TextEditingController Rating_controller = TextEditingController();
  double _currentRating = 0.0; // Track rating separately
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: Review_controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Review",
                      hintText: "Enter your feedback here...",
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your review';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text("Rating", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _currentRating = rating;
                      });
                      Rating_controller.text = rating.toString();
                    },
                  ),
                  if (_currentRating == 0) // Show validation message if no rating
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Please select a rating',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    onPressed: () {
                      _validateAndSubmit();
                    },
                    child: const Text(
                      'Submit Feedback',
                      style: TextStyle(fontSize: 16,
                      color: Colors.black,)
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_currentRating == 0) {
        Fluttertoast.showToast(
          msg: 'Please select a rating',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        senddata();
      }
    }
  }

  senddata() async {
    String review = Review_controller.text;
    String rating = Rating_controller.text;

    if (review.isEmpty || rating.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill all fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/u_send_feedback/');
    try {
      final response = await http.post(urls, body: {
        'review': review,
        'rating': rating,
        'lid': lid,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserHome(title: "Home")),
          );
          Fluttertoast.showToast(
            msg: 'Feedback submitted successfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Submission failed. Please try again.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Network error. Please check your connection.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An error occurred: ${e.toString()}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}