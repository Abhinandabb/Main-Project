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
      title: 'Complaint Against Driver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const send_complaints_against_driver(title: 'Complaint Against Driver'),
    );
  }
}

class send_complaints_against_driver extends StatefulWidget {
  const send_complaints_against_driver({super.key, required this.title});
  final String title;

  @override
  State<send_complaints_against_driver> createState() => _send_complaints_against_driverState();
}

class _send_complaints_against_driverState extends State<send_complaints_against_driver> {
  TextEditingController complaintsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor:Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "File a Complaint Against Driver",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: complaintsController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Your Complaint",
                  hintText: "Describe the issue...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your complaint";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: _isSending
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Icon(Icons.send),
                  label: Text(_isSending ? "Sending..." : "Send"),
                  onPressed: _isSending
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      senddata();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  senddata() async {
    setState(() => _isSending = true);

    String complaint = complaintsController.text.trim();
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';
    String did = sh.getString('did') ?? '';

    final urls = Uri.parse('$url/u_send_complaints_drv/');
    try {
      final response = await http.post(urls, body: {
        'sendcmpuser': complaint,
        'lid': lid,
        'did': did,
      });

      setState(() => _isSending = false);

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Complaint sent successfully');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserHome(title: "Home")),
          );
        } else {
          Fluttertoast.showToast(msg: 'Failed to send complaint');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error');
      }
    } catch (e) {
      setState(() => _isSending = false);
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }
}
