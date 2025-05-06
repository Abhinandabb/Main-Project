// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:public_transportation/login.dart';
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
//       home: const sign_up(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class sign_up extends StatefulWidget {
//   const sign_up({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<sign_up> createState() => _sign_upState();
// }
//
// class _sign_upState extends State<sign_up> {
//   TextEditingController Name_controller = new TextEditingController();
//   TextEditingController Email_controller = new TextEditingController();
//   TextEditingController Age_controller = new TextEditingController();
//   TextEditingController Gender_controller = new TextEditingController();
//   TextEditingController Place_controller = new TextEditingController();
//   TextEditingController Pin_controller = new TextEditingController();
//   TextEditingController Post_controller = new TextEditingController();
//   TextEditingController Mobile_no_controller = new TextEditingController();
//   TextEditingController Password_controller = new TextEditingController();
//   TextEditingController Confirm_Password_controller = new TextEditingController();
//   String gender="";
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
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
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
//                       Image(image: NetworkImage('https://cdn.pixabay.com/photo/2017/11/10/05/24/select-2935439_1280.png'),height: 200,width: 200,),
//                       Text('Select Image',style: TextStyle(color: Colors.cyan))
//                     ],
//                   ),
//                 ),
//               },
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//               controller: Name_controller,
//               decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Name")),),
//             ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: TextField(
//                          controller: Email_controller,
//                          decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Email")),),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: TextField(
//                          controller: Age_controller,
//                          decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Age")),),
//              ),
//              RadioListTile(value: "Male", groupValue: gender, onChanged: (value){setState(() {gender="Male";});},title: Text("Male")),
//              RadioListTile(value: "Female", groupValue: gender, onChanged: (value){setState(() {gender="Female";});},title: Text("Female")),
//              RadioListTile(value: "Others", groupValue: gender, onChanged: (value){setState(() {gender="Others";});},title:Text("Others")),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: TextField(
//                          controller: Place_controller,
//                          decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Place")),),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: TextField(
//                          controller: Pin_controller,
//                          decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Pin")),),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: TextField(
//                          controller: Post_controller,
//                          decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Post")),),
//              ),
//
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: TextField(
//                          controller: Mobile_no_controller,
//                          decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Mobile_no")),),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: TextField(
//                          controller: Password_controller,
//                          decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Password")),),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: TextField(
//                          controller: Confirm_Password_controller,
//                          decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Confirm_Password")),),
//              ),
//
//               ElevatedButton(onPressed: (){
//                 senddata();
//               }, child: Text('Submit'))
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
// senddata() async {
//     String name=Name_controller.text;
//     String email=Email_controller.text;
//     String age=Age_controller.text;
//     String place=Place_controller.text;
//     String pin=Pin_controller.text;
//     String post=Post_controller.text;
//     String mobile_no=Mobile_no_controller.text;
//     String password=Password_controller.text;
//     String confirm_password=Confirm_Password_controller.text;
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//
//     final urls = Uri.parse('$url/u_register/');
//     try {
//       final response = await http.post(urls, body: {
//         'name':name,
//         'email':email,
//         'age':age,
//         'gender':gender,
//         'place':place,
//         'pin':pin,
//         'post':post,
//         'photo':photo,
//         'mobile_no':mobile_no,
//         'password':password,
//         'confirm_password':confirm_password,
//
//
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status=='ok') {
//
//
//           Navigator.push(context, MaterialPageRoute(
//             builder: (context) => login(title: "login"),));
//           Fluttertoast.showToast(msg: 'Registration Successfull');
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
//
// }
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
//         photo = _encodedImage.toString();
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
//   String photo = '';
// }

// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
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
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const sign_up(title: 'User Sign Up'),
//     );
//   }
// }
//
// class sign_up extends StatefulWidget {
//   const sign_up({super.key, required this.title});
//   final String title;
//
//   @override
//   State<sign_up> createState() => _sign_upState();
// }
//
// class _sign_upState extends State<sign_up> {
//   TextEditingController Name_controller = TextEditingController();
//   TextEditingController Email_controller = TextEditingController();
//   TextEditingController Age_controller = TextEditingController();
//   TextEditingController Gender_controller = TextEditingController();
//   TextEditingController Place_controller = TextEditingController();
//   TextEditingController Pin_controller = TextEditingController();
//   TextEditingController Post_controller = TextEditingController();
//   TextEditingController Mobile_no_controller = TextEditingController();
//   TextEditingController Password_controller = TextEditingController();
//   TextEditingController Confirm_Password_controller = TextEditingController();
//
//   String gender = "";
//   File? _selectedImage;
//   String? _encodedImage;
//   String photo = '';
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
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: InkWell(
//                 onTap: _checkPermissionAndChooseImage,
//                 child: CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Colors.grey.shade300,
//                   backgroundImage:
//                   _selectedImage != null ? FileImage(_selectedImage!) : null,
//                   child: _selectedImage == null
//                       ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Icon(Icons.add_a_photo, size: 30, color: Colors.deepPurple),
//                       SizedBox(height: 5),
//                       Text("Upload", style: TextStyle(fontSize: 12, color: Colors.deepPurple)),
//                     ],
//                   )
//                       : null,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildTextField(Name_controller, "Name", Icons.person),
//             _buildTextField(Email_controller, "Email", Icons.email),
//             _buildTextField(Age_controller, "Age", Icons.cake),
//             const SizedBox(height: 8),
//             const Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             _buildGenderRadio("Male"),
//             _buildGenderRadio("Female"),
//             _buildGenderRadio("Others"),
//             _buildTextField(Place_controller, "Place", Icons.location_on),
//             _buildTextField(Post_controller, "Post", Icons.local_post_office),
//             _buildTextField(Pin_controller, "Pin", Icons.pin),
//             _buildTextField(Mobile_no_controller, "Mobile Number", Icons.phone),
//             _buildTextField(Password_controller, "Password", Icons.lock, isPassword: true),
//             _buildTextField(Confirm_Password_controller, "Confirm Password", Icons.lock_outline, isPassword: true),
//             const SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   senddata();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                   backgroundColor: Colors.deepPurple,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: const Text("Submit", style: TextStyle(fontSize: 16, color: Colors.white)),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon),
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGenderRadio(String value) {
//     return RadioListTile(
//       value: value,
//       groupValue: gender,
//       onChanged: (val) {
//         setState(() {
//           gender = val!;
//         });
//       },
//       title: Text(value),
//       activeColor: Colors.deepPurple,
//     );
//   }
//
//   Future<void> _chooseAndUploadImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//         _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
//         photo = _encodedImage.toString();
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
//   Future<void> senddata() async {
//     String name = Name_controller.text;
//     String email = Email_controller.text;
//     String age = Age_controller.text;
//     String place = Place_controller.text;
//     String pin = Pin_controller.text;
//     String post = Post_controller.text;
//     String mobile_no = Mobile_no_controller.text;
//     String password = Password_controller.text;
//     String confirm_password = Confirm_Password_controller.text;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//
//     final urls = Uri.parse('$url/u_register/');
//
//     try {
//       final response = await http.post(urls, body: {
//         'name': name,
//         'email': email,
//         'age': age,
//         'gender': gender,
//         'place': place,
//         'pin': pin,
//         'post': post,
//         'photo': photo,
//         'mobile_no': mobile_no,
//         'password': password,
//         'confirm_password': confirm_password,
//       });
//
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status == 'ok') {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => login(title: "login")));
//           Fluttertoast.showToast(msg: 'Registration Successful');
//         } else {
//           Fluttertoast.showToast(msg: 'Registration Failed');
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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const sign_up(title: 'User Sign Up'),
    );
  }
}

class sign_up extends StatefulWidget {
  const sign_up({super.key, required this.title});
  final String title;

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController Name_controller = TextEditingController();
  TextEditingController Email_controller = TextEditingController();
  TextEditingController Age_controller = TextEditingController();
  TextEditingController Gender_controller = TextEditingController();
  TextEditingController Place_controller = TextEditingController();
  TextEditingController Pin_controller = TextEditingController();
  TextEditingController Post_controller = TextEditingController();
  TextEditingController Mobile_no_controller = TextEditingController();
  TextEditingController Password_controller = TextEditingController();
  TextEditingController Confirm_Password_controller = TextEditingController();

  String gender = "";
  File? _selectedImage;
  String? _encodedImage;
  String photo = '';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: InkWell(
                  onTap: _checkPermissionAndChooseImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                    _selectedImage != null ? FileImage(_selectedImage!) : null,
                    child: _selectedImage == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo, size: 30, color: Colors.deepPurple),
                        SizedBox(height: 5),
                        Text("Upload", style: TextStyle(fontSize: 12, color: Colors.deepPurple)),
                      ],
                    )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(Name_controller, "Name", Icons.person, validator: _validateName),
              _buildTextField(Email_controller, "Email", Icons.email, validator: _validateEmail),
              _buildTextField(Age_controller, "Age", Icons.cake, validator: _validateAge),
              const SizedBox(height: 8),
              const Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _buildGenderRadio("Male"),
              _buildGenderRadio("Female"),
              _buildGenderRadio("Others"),
              _buildTextField(Place_controller, "Place", Icons.location_on, validator: _validatePlace),
              _buildTextField(Post_controller, "Post", Icons.local_post_office, validator: _validatePost),
              _buildTextField(Pin_controller, "Pin", Icons.pin,
                validator: _validatePin,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(Mobile_no_controller, "Mobile Number", Icons.phone,
                validator: _validateMobile,
                keyboardType: TextInputType.phone,
              ),
              _buildPasswordField(Password_controller, "Password", Icons.lock,
                obscure: _obscurePassword,
                toggleVisibility: _togglePasswordVisibility,
              ),
              _buildPasswordField(Confirm_Password_controller, "Confirm Password", Icons.lock_outline,
                obscure: _obscureConfirmPassword,
                toggleVisibility: _toggleConfirmPasswordVisibility,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : senddata,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white))
                      : const Text("Submit", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool isPassword = false,
        String? Function(String?)? validator,
        TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller,
      String label,
      IconData icon, {
        required bool obscure,
        required VoidCallback toggleVisibility,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: _validatePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
            onPressed: toggleVisibility,
          ),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Widget _buildGenderRadio(String value) {
    return RadioListTile(
      value: value,
      groupValue: gender,
      onChanged: (val) {
        setState(() {
          gender = val!;
        });
      },
      title: Text(value),
      activeColor: Colors.deepPurple,
    );
  }

  // Validation functions
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    if (int.tryParse(value) == null) {
      return 'Enter a valid age';
    }
    if (int.parse(value) < 1 || int.parse(value) > 120) {
      return 'Enter a valid age between 1-120';
    }
    return null;
  }

  String? _validatePlace(String? value) {
    if (value == null || value.isEmpty) {
      return 'Place is required';
    }
    return null;
  }

  String? _validatePost(String? value) {
    if (value == null || value.isEmpty) {
      return 'Post is required';
    }
    return null;
  }

  String? _validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return 'Enter a valid 6-digit PIN';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase and digits';
    }
    return null;
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

  Future<void> _checkPermissionAndChooseImage() async {
    final PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseAndUploadImage();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
            'Please go to app settings and grant permission to choose an image.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> senddata() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (gender.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select gender');
      return;
    }

    if (_selectedImage == null) {
      Fluttertoast.showToast(msg: 'Please upload a photo');
      return;
    }

    if (Password_controller.text != Confirm_Password_controller.text) {
      Fluttertoast.showToast(msg: 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url').toString();

      final response = await http.post(
        Uri.parse('$url/u_register/'),
        body: {
          'name': Name_controller.text,
          'email': Email_controller.text,
          'age': Age_controller.text,
          'gender': gender,
          'place': Place_controller.text,
          'pin': Pin_controller.text,
          'post': Post_controller.text,
          'photo': photo,
          'mobile_no': Mobile_no_controller.text,
          'password': Password_controller.text,
          'confirm_password': Confirm_Password_controller.text,
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Registration Successful');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => login(title: "login")),
          );
        } else {
          Fluttertoast.showToast(msg: responseData['message'] ?? 'Registration Failed');
        }
      } else {
        Fluttertoast.showToast(msg: 'Server Error: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}