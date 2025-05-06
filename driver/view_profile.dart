// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:public_transportation/driver/update_profile.dart';
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
//       title: 'Driver Profile',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const view_profile(title: 'Driver Profile'),
//     );
//   }
// }
//
// class view_profile extends StatefulWidget {
//   const view_profile({super.key, required this.title});
//   final String title;
//
//   @override
//   State<view_profile> createState() => _view_profileState();
// }
//
// class _view_profileState extends State<view_profile> {
//   _view_profileState() {
//     getdata();
//   }
//
//   String name = "";
//   String age = "";
//   String mobileno = "";
//   String email = "";
//   String photo = "";
//   String vehiclephoto = "";
//   String place = "";
//   String pin = "";
//   String post = "";
//   String experience = "";
//   String vehicle = "";
//   String license = "";
//   String rcno = "";
//   String activestatus="";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text(
//               "Driver Images",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildImageCard(photo, "Photo"),
//                 _buildImageCard(license, "License"),
//                 _buildImageCard(vehiclephoto, "Vehicle"),
//               ],
//             ),
//             const SizedBox(height: 24),
//             _buildInfoTile("Name", name),
//             _buildInfoTile("Age", age),
//             _buildInfoTile("Mobile No", mobileno),
//             _buildInfoTile("Email", email),
//             _buildInfoTile("Place", place),
//             _buildInfoTile("Post", post),
//             _buildInfoTile("Pin", pin),
//             _buildInfoTile("Experience", experience),
//             _buildInfoTile("Vehicle", vehicle),
//             _buildInfoTile("RC No", rcno),
//             _buildInfoTile("Active_status ", activestatus),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurple,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => update_profile(
//                       title: 'Update_Profile',
//                       name: name,
//                       age: age,
//                       mobileno: mobileno,
//                       email: email,
//                       photo: photo,
//                       vehiclephoto: vehiclephoto,
//                       place: place,
//                       pin: pin,
//                       post: post,
//                       experience: experience,
//                       vehicle: vehicle,
//                       license: license,
//                       rcno: rcno,
//                       astatus:activestatus,
//
//                     ),
//                   ),
//                 );
//               },
//               child: const Text("Edit Profile"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageCard(String imageUrl, String label) {
//     return Column(
//       children: [
//         Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Image.network(
//               imageUrl,
//               height: 100,
//               width: 100,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   height: 100,
//                   width: 100,
//                   color: Colors.grey.shade300,
//                   child: const Icon(Icons.broken_image, size: 40),
//                 );
//               },
//             ),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//       ],
//     );
//   }
//
//   Widget _buildInfoTile(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(flex: 3, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold))),
//           Expanded(flex: 5, child: Text(value)),
//         ],
//       ),
//     );
//   }
//
//   getdata() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//     String img_url = sh.getString('img_url').toString();
//
//     final urls = Uri.parse('$url/d_view_profile/');
//     try {
//       final response = await http.post(urls, body: {
//         'lid': lid,
//       });
//
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status == 'ok') {
//           setState(() {
//             name = jsonDecode(response.body)['name'].toString();
//             age = jsonDecode(response.body)['age'].toString();
//             mobileno = jsonDecode(response.body)['mobile'].toString();
//             email = jsonDecode(response.body)['email'].toString();
//             photo = img_url + jsonDecode(response.body)['photo'].toString();
//             vehiclephoto = img_url + jsonDecode(response.body)['vehicle_photo'].toString();
//             place = jsonDecode(response.body)['place'].toString();
//             pin = jsonDecode(response.body)['pin'].toString();
//             post = jsonDecode(response.body)['post'].toString();
//             experience = jsonDecode(response.body)['experience'].toString();
//             vehicle = jsonDecode(response.body)['vehicle'].toString();
//             license = img_url + jsonDecode(response.body)['license'].toString();
//             rcno = jsonDecode(response.body)['rcno'].toString();
//             activestatus = jsonDecode(response.body)['active_status'].toString();
//           });
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF4A47A3),
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      home: const view_profile(title: 'Driver Profile'),
    );
  }
}

class view_profile extends StatefulWidget {
  const view_profile({super.key, required this.title});
  final String title;

  @override
  State<view_profile> createState() => _view_profileState();
}

class _view_profileState extends State<view_profile> {
  _view_profileState() {
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
  String activestatus = "";
  String f_amount = "";
  bool _isLoading = true;

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
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              "Driver Documents",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A47A3),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageCard(photo, "Profile Photo"),
                _buildImageCard(license, "License"),
                _buildImageCard(vehiclephoto, "Vehicle"),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoTile(Icons.person, "Name", name),
                    _buildInfoTile(Icons.cake, "Age", age),
                    _buildInfoTile(Icons.phone, "Mobile No", mobileno),
                    _buildInfoTile(Icons.email, "Email", email),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoTile(Icons.location_on, "Place", place),
                    _buildInfoTile(Icons.location_city, "Post", post),
                    _buildInfoTile(Icons.pin_drop, "Pin", pin),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoTile(Icons.work_history, "Experience", experience),
                    _buildInfoTile(Icons.directions_car, "Vehicle", vehicle),
                    _buildInfoTile(Icons.confirmation_number, "RC No", rcno),
                    _buildInfoTile(Icons.verified_user, "Active Status", activestatus),
                    _buildInfoTile(Icons.verified_user, "Km Amount", f_amount),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => update_profile(
                        title: 'Update_Profile',
                        name: name,
                        age: age,
                        mobileno: mobileno,
                        email: email,
                        photo: photo,
                        vehiclephoto: vehiclephoto,
                        place: place,
                        pin: pin,
                        post: post,
                        experience: experience,
                        vehicle: vehicle,
                        license: license,
                        rcno: rcno,
                        astatus: activestatus,
                        f_amount:f_amount,

                      ),
                    ),
                  );
                },
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(String imageUrl, String label) {
    return Column(
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.grey[100],
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
                },
              )
                  : const Icon(Icons.image, size: 40, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value.isNotEmpty ? value : "Not provided",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  getdata() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String img_url = sh.getString('img_url').toString();

      final urls = Uri.parse('$url/d_view_profile/');
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
            activestatus = jsonDecode(response.body)['active_status'].toString();
            f_amount = jsonDecode(response.body)['f_amount'].toString();
            _isLoading = false;
          });
        } else {
          Fluttertoast.showToast(msg: 'Profile not found');
          setState(() => _isLoading = false);
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      setState(() => _isLoading = false);
    }
  }
}