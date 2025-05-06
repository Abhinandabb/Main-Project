import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_transportation/driver/update_profile.dart';
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
      title: 'Driver Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const user_drv_view_profile(title: 'Driver Profile'),
    );
  }
}

class user_drv_view_profile extends StatefulWidget {
  const user_drv_view_profile({super.key, required this.title});
  final String title;

  @override
  State<user_drv_view_profile> createState() => _user_drv_view_profileState();
}

class _user_drv_view_profileState extends State<user_drv_view_profile> {
  _user_drv_view_profileState() {
    getdata();
  }

  String name = "";
  String age = "";
  String mobileno = "";
  String email = "";
  String photo = "";
  String vehiclephoto = "";
  String place = "";
  String pin = "";
  String post = "";
  String experience = "";
  String vehicle = "";
  String license = "";
  String rcno = "";
  String km_amount = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        actions: [

        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Images Row
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Driver Documents",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text("Photo", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: photo.isNotEmpty
                                      ? Image.network(photo, fit: BoxFit.cover)
                                      : Icon(Icons.person, size: 40, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text("License", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: license.isNotEmpty
                                      ? Image.network(license, fit: BoxFit.cover)
                                      : Icon(Icons.badge, size: 40, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text("Vehicle", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: vehiclephoto.isNotEmpty
                                      ? Image.network(vehiclephoto, fit: BoxFit.cover)
                                      : Icon(Icons.directions_car, size: 40, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Driver Information
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Driver Information",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      _buildInfoRow("Name:", name, Icons.person),
                      _buildInfoRow("Age:", age, Icons.calendar_today),
                      _buildInfoRow("Mobile:", mobileno, Icons.phone),
                      _buildInfoRow("Email:", email, Icons.email),
                      _buildInfoRow("Experience:", experience, Icons.work_history),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Vehicle Information
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Vehicle Information",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      _buildInfoRow("Vehicle:", vehicle, Icons.directions_car),
                      _buildInfoRow("RC Number:", rcno, Icons.confirmation_number),
                      _buildInfoRow("Km Amount:", km_amount, Icons.money),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Address Information
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Address Information",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      _buildInfoRow("Place:", place, Icons.location_city),
                      _buildInfoRow("Post:", post, Icons.local_post_office),
                      _buildInfoRow("PIN:", pin, Icons.pin_drop),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              )),
              SizedBox(height: 4),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(value.isNotEmpty ? value : "Not provided",
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getdata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('did').toString();
    String img_url = sh.getString('img_url').toString();

    final urls = Uri.parse('$url/d_view_profile/');
    try {
      final response = await http.post(urls, body: {
        'lid': lid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          setState(() {
            name = jsonDecode(response.body)['name'].toString();
            age = jsonDecode(response.body)['age'].toString();
            mobileno = jsonDecode(response.body)['mobile'].toString();
            email = jsonDecode(response.body)['email'].toString();
            photo = img_url + jsonDecode(response.body)['photo'].toString();
            vehiclephoto = img_url + jsonDecode(response.body)['vehicle_photo'].toString();
            place = jsonDecode(response.body)['place'].toString();
            pin = jsonDecode(response.body)['pin'].toString();
            post = jsonDecode(response.body)['post'].toString();
            experience = jsonDecode(response.body)['experience'].toString();
            vehicle = jsonDecode(response.body)['vehicle'].toString();
            license = img_url + jsonDecode(response.body)['license'].toString();
            rcno = jsonDecode(response.body)['rcno'].toString();
            km_amount = jsonDecode(response.body)['f_amount'].toString();
          });
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}