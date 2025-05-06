// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:public_transportation/user/view_profile.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // void main() {
// //   runApp(const MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //         useMaterial3: true,
// //       ),
// //       home: const update_profile(title: 'Flutter Demo Home Page'),
// //     );
// //   }
// // }
//
// class update_profile extends StatefulWidget {
//   const update_profile({super.key, required this.title, required this.name , required this.age, required this.mobileno, required this.email, required this.photo, required this.place, required this.pin, required this.post, required this.gender});
//
//
//   final String title;
//   final String name;
//   final String email;
//   final String age;
//   final String gender;
//   final String place;
//   final String pin;
//   final String post;
//   final String photo;
//   final String mobileno;
//
//
//   @override
//   State<update_profile> createState() => _update_profileState();
// }
//
// class _update_profileState extends State<update_profile> {
//
//   void initState() {
//     // TODO: implement initState
//     a();
//     super.initState();
//   }
//
//
//   TextEditingController Name_controller = new TextEditingController();
//   TextEditingController Email_controller = new TextEditingController();
//   TextEditingController Age_controller = new TextEditingController();
//   TextEditingController Gender_controller = new TextEditingController();
//   TextEditingController Place_controller = new TextEditingController();
//   TextEditingController Pin_controller = new TextEditingController();
//   TextEditingController Post_controller = new TextEditingController();
//   TextEditingController Photo_controller = new TextEditingController();
//   TextEditingController Mobile_no_controller = new TextEditingController();
//   String uphoto="";
//
//
//   a(){
//     setState(() {
//     Name_controller.text=widget.name;
//     Email_controller.text=widget.email;
//     Age_controller.text=widget.age;
//     Gender_controller.text=widget.gender;
//     Place_controller.text=widget.place;
//     Pin_controller.text=widget.pin;
//     Post_controller.text=widget.post;
//     uphoto=widget.photo;
//     Mobile_no_controller.text=widget.mobileno;
//     });
//   }
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
//         child: SingleChildScrollView(
//           child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//           Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               if (_selectedImage != null) ...{
//                 InkWell(
//                   child:
//                   Image.file(_selectedImage!, height: 200,width: 200),
//                   radius: 399,
//                   onTap: _checkPermissionAndChooseImage,
//                   // borderRadius: BorderRadius.all(Radius.circular(200)),
//                 ),
//               } else ...{
//                 // Image(image: NetworkImage(),height: 100, width: 70,fit: BoxFit.cover,),
//                 InkWell(
//                   onTap: _checkPermissionAndChooseImage,
//                   child:Column(
//                     children: [
//                       Image(image: NetworkImage(uphoto),height: 200,width: 200,),
//                       Text('Select Image',style: TextStyle(color: Colors.cyan))
//                     ],
//                   ),
//                 ),
//               },
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//             controller: Name_controller,
//             decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Name")),),
//           ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             controller: Email_controller,
//             decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Email")),),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             controller: Age_controller,
//             decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Age")),),
//         ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: Gender_controller,
//                 decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Gender")),),
//             ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             controller: Place_controller,
//             decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Place")),),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             controller: Pin_controller,
//             decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Pin")),),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             controller: Post_controller,
//             decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Post")),),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             controller: Photo_controller,
//             decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Photo")),),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             controller: Mobile_no_controller,
//             decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Mobile_no")),),
//         ),
//             ElevatedButton(onPressed: (){
//               senddata();
//             }, child: Text('Update'))
//             ],
//           ),
//         ]),
//       ),
//
//     ));
//   }
//   senddata() async {
//     String name = Name_controller.text;
//     String email = Email_controller.text;
//     String age = Age_controller.text;
//     String gender=Gender_controller.text;
//     String place = Place_controller.text;
//     String pin = Pin_controller.text;
//     String post = Post_controller.text;
//     // String photo = Photo_controller.text;
//     String mobile_no = Mobile_no_controller.text;
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//
//
//     final urls = Uri.parse('$url/u_update_profile/');
//     try {
//       final response = await http.post(urls, body: {
//         'name': name,
//         'email': email,
//         'age': age,
//         'gender':gender,
//         'place': place,
//         'pin': pin,
//         'post': post,
//         'photo': uphoto,
//         'mobile_no': mobile_no,
//         'lid':'lid'
//
//
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status == 'ok') {
//           //
//           Navigator.push(context, MaterialPageRoute(
//             builder: (context) => view_profile(title: "Home"),));
//           Fluttertoast.showToast(msg: 'Updated Successfully');
//         } else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       }
//       else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     }
//     catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//   File? _selectedImage;
//   String? _encodedImage;
//   Future<void> _chooseAndUploadImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//         _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
//         uphoto = _encodedImage.toString();
//       });
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage() async {
//     final PermissionStatus status = await Permission.mediaLibrary.request();
//     if (status.isGranted) {
//       _chooseAndUploadImage();
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: const Text('Permission Denied'),
//           content: const Text(
//             'Please go to app settings and grant permission to choose an image.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
// }


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:public_transportation/user/view_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class update_profile extends StatefulWidget {
  const update_profile({
    super.key,
    required this.title,
    required this.name,
    required this.age,
    required this.mobileno,
    required this.email,
    required this.photo,
    required this.place,
    required this.pin,
    required this.post,
    required this.gender
  });

  final String title;
  final String name;
  final String email;
  final String age;
  final String gender;
  final String place;
  final String pin;
  final String post;
  final String photo;
  final String mobileno;

  @override
  State<update_profile> createState() => _update_profileState();
}

class _update_profileState extends State<update_profile> {
  @override
  void initState() {
    super.initState();
    a();
  }

  TextEditingController Name_controller = TextEditingController();
  TextEditingController Email_controller = TextEditingController();
  TextEditingController Age_controller = TextEditingController();
  TextEditingController Gender_controller = TextEditingController();
  TextEditingController Place_controller = TextEditingController();
  TextEditingController Pin_controller = TextEditingController();
  TextEditingController Post_controller = TextEditingController();
  TextEditingController Mobile_no_controller = TextEditingController();
  String uphoto = "";
  File? _selectedImage;
  String? _encodedImage;

  void a() {
    setState(() {
      Name_controller.text = widget.name;
      Email_controller.text = widget.email;
      Age_controller.text = widget.age;
      Gender_controller.text = widget.gender;
      Place_controller.text = widget.place;
      Pin_controller.text = widget.pin;
      Post_controller.text = widget.post;
      uphoto = widget.photo;
      Mobile_no_controller.text = widget.mobileno;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor:Colors.deepPurpleAccent,
        elevation: 0,
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
              // Profile Picture Section
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: ClipOval(
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : uphoto.isNotEmpty
                          ? Image.network(uphoto, fit: BoxFit.cover)
                          : Icon(Icons.person, size: 60, color: Colors.grey),
                    ),
                  ),
                  GestureDetector(
                    onTap: _checkPermissionAndChooseImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Form Fields
              _buildTextField("Name", Name_controller, Icons.person),
              _buildTextField("Email", Email_controller, Icons.email),
              _buildTextField("Age", Age_controller, Icons.calendar_today),
              _buildTextField("Gender", Gender_controller, Icons.transgender),
              _buildTextField("Place", Place_controller, Icons.location_city),
              _buildTextField("PIN Code", Pin_controller, Icons.pin),
              _buildTextField("Post", Post_controller, Icons.local_post_office),
              _buildTextField("Mobile Number", Mobile_no_controller, Icons.phone),

              SizedBox(height: 30),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: senddata,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('UPDATE PROFILE',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }

  Future<void> senddata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/u_update_profile/');
    try {
      final response = await http.post(urls, body: {
        'name': Name_controller.text,
        'email': Email_controller.text,
        'age': Age_controller.text,
        'gender': Gender_controller.text,
        'place': Place_controller.text,
        'pin': Pin_controller.text,
        'post': Post_controller.text,
        'photo': photo,
        'mobile_no': Mobile_no_controller.text,
        'lid': lid,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => user_profile_page(title: "Profile")));
          Fluttertoast.showToast(msg: 'Profile updated successfully!');
        } else {
          Fluttertoast.showToast(msg: 'Update failed. Please try again.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network error occurred');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }

  Future<void> _chooseAndUploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
        photo = _encodedImage.toString();
      });
    }
  }
  String photo="";

  Future<void> _checkPermissionAndChooseImage() async {
    final PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseAndUploadImage();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'We need access to your gallery to select a profile picture.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }
  }
}