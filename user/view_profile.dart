// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:public_transportation/user/update_profile.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
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
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const user_profile_page(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class user_profile_page extends StatefulWidget {
//   const user_profile_page({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<user_profile_page> createState() => _user_profile_pageState();
// }
//
// class _user_profile_pageState extends State<user_profile_page> {
//   _user_profile_pageState(){
//     getdata();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//
//         title: Text(widget.title),
//       ),
//       body: Center(
//
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//         Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Image(image: NetworkImage(photo),height: 100,width: 100,),
//             ],
//         ),
//             Text(name),
//             Text(email),
//             Text(age),
//             Text(gender),
//             Text(place),
//             Text(pin),
//             Text(post),
//             Text(mobileno),
//             ElevatedButton(onPressed: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context) => update_profile(title: 'Update_Profile', name: name, age: age, mobileno: mobileno, email: email, photo: photo, place: place, pin: pin, post: post, gender:gender,),));
//
//             },
//                 child: Text("Edit"))
//
//           ],
//         ),
//       ),
//
//     );
//   }
//   String name="";
//   String email="";
//   String age="";
//   String gender="";
//   String place="";
//   String pin="";
//   String post="";
//   String photo="";
//   String mobileno="";
//
//   getdata() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//     String img_url = sh.getString('img_url').toString();
//
//     final urls = Uri.parse('$url/u_user_profile_page/');
//     try {
//       final response = await http.post(urls, body: {
//         'lid':lid,
//
//
//
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status=='ok') {
//
//
//           setState(() {
//             name=jsonDecode(response.body)['name'].toString();
//             email=jsonDecode(response.body)['email'].toString();
//             age=jsonDecode(response.body)['age'].toString();
//             gender=jsonDecode(response.body)['gender'].toString();
//             place=jsonDecode(response.body)['place'].toString();
//             pin=jsonDecode(response.body)['pin'].toString();
//             post=jsonDecode(response.body)['post'].toString();
//             photo=img_url+jsonDecode(response.body)['photo'].toString();
//             mobileno=jsonDecode(response.body)['mobile_no'].toString();
//           });
//
//         }else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       }
//       else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     }
//     catch (e){
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_transportation/user/update_profile.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const user_profile_page(title: 'My Profile'),
    );
  }
}

class user_profile_page extends StatefulWidget {
  const user_profile_page({super.key, required this.title});
  final String title;

  @override
  State<user_profile_page> createState() => _user_profile_pageState();
}

class _user_profile_pageState extends State<user_profile_page> {
  _user_profile_pageState() {
    getdata();
  }

  String name = "";
  String email = "";
  String age = "";
  String gender = "";
  String place = "";
  String pin = "";
  String post = "";
  String photo = "";
  String mobileno = "";

  getdata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String img_url = sh.getString('img_url').toString();

    final urls = Uri.parse('$url/u_view_profile/');
    try {
      final response = await http.post(urls, body: {
        'lid': lid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          setState(() {
            name = jsonDecode(response.body)['name'].toString();
            email = jsonDecode(response.body)['email'].toString();
            age = jsonDecode(response.body)['age'].toString();
            gender = jsonDecode(response.body)['gender'].toString();
            place = jsonDecode(response.body)['place'].toString();
            pin = jsonDecode(response.body)['pin'].toString();
            post = jsonDecode(response.body)['post'].toString();
            photo = img_url + jsonDecode(response.body)['photo'].toString();
            mobileno = jsonDecode(response.body)['mobile_no'].toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(photo),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 16),

            // Profile Details
            Expanded(
              child: ListView(
                children: [
                  profileItem("Name", name),
                  profileItem("Email", email),
                  profileItem("Mobile No", mobileno),
                  profileItem("Age", age),
                  profileItem("Gender", gender),
                  profileItem("Place", place),
                  profileItem("Post", post),
                  profileItem("PIN", pin),
                ],
              ),
            ),

            // Edit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
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
                        place: place,
                        pin: pin,
                        post: post,
                        gender: gender,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.edit),
                label: Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for profile detail item
  Widget profileItem(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        leading: Icon(Icons.person_outline),
      ),
    );
  }
}
