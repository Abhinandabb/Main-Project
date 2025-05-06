// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:public_transportation/driver/driverhome.dart';
// import 'package:public_transportation/driver/signup.dart';
// import 'package:public_transportation/user/signup.dart';
// import 'package:public_transportation/user/userhome.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'main.dart';
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
//       home: const login(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class login extends StatefulWidget {
//   const login({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<login> createState() => _loginState();
// }
//
// class _loginState extends State<login> {
//
//   TextEditingController User_name_controller = new TextEditingController();
//   TextEditingController Password_controller = new TextEditingController();
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
//             TextField(
//               controller: User_name_controller,
//               decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Username")),),
//             TextField(
//               controller: Password_controller,
//               decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Password")),),
//
//             ElevatedButton(onPressed: (){senddata();}, child: Text('Login')),
//             TextButton(onPressed: (){
//               Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => signup(title: "Signup"),));
//             }, child: Text("Driver signup")),
//             TextButton(onPressed: (){
//               Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => sign_up(title: "Signup"),));
//             }, child: Text("User signup")),
//           ],
//         ),
//       ),
//
//     );
//   }
//   senddata() async {
//     String username=User_name_controller.text;
//     String password=Password_controller.text;
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//
//     final urls = Uri.parse('$url/d_login/');
//     try {
//       final response = await http.post(urls, body: {
//         'username':username,
//         'password':password,
//
//
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status=='ok') {
//
//           String lid=jsonDecode(response.body)['lid'].toString();
//           sh.setString("lid", lid);
//           String type=jsonDecode(response.body)['type'].toString();
//           if(type=='driver'){
//             Navigator.push(context, MaterialPageRoute(
//               builder: (context) => DriverHome(title: "Home"),));
//             Fluttertoast.showToast(msg: 'Login Successfull');
//
//           }
//           else if(type=="user"){
//             Navigator.push(context, MaterialPageRoute(
//               builder: (context) => UserHome(title: "Home"),));
//             Fluttertoast.showToast(msg: 'Login Successfull');
//
//           }
//           else{
//             Fluttertoast.showToast(msg: 'Not Found');
//
//           }
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
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:public_transportation/driver/driverhome.dart';
import 'package:public_transportation/driver/signup.dart';
import 'package:public_transportation/user/signup.dart';
import 'package:public_transportation/user/userhome.dart';

import 'driver/forgot_passw.dart';

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
      home: const login(title: 'Login'),
    );
  }
}

class login extends StatefulWidget {
  const login({super.key, required this.title});
  final String title;

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController User_name_controller = TextEditingController();
  TextEditingController Password_controller = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.lock, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),
              TextFormField(
                controller: User_name_controller,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: Password_controller,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: const Text("Forgot Password?"),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text("Login"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    senddata();
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              TextButton.icon(
                icon: const Icon(Icons.directions_car, color: Colors.deepPurple),
                label: const Text("Driver Signup"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => signup(title: "Signup")),
                  );
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.person_add_alt_1, color: Colors.deepPurple),
                label: const Text("User Signup"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => sign_up(title: "Signup")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  senddata() async {
    String username = User_name_controller.text;
    String password = Password_controller.text;
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/d_login/');
    try {
      final response = await http.post(urls, body: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          String lid = jsonDecode(response.body)['lid'].toString();
          sh.setString("lid", lid);
          String type = jsonDecode(response.body)['type'].toString();

          if (type == 'driver') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DriverHome(title: "Home")));
            Fluttertoast.showToast(msg: 'Login Successful');
          } else if (type == "user") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserHome(title: "Home")));
            Fluttertoast.showToast(msg: 'Login Successful');
          } else {
            Fluttertoast.showToast(msg: 'User type not recognized');
          }
        } else {
          Fluttertoast.showToast(msg: 'Invalid credentials');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({Key? key}) : super(key: key);
//
//   @override
//   // State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   TextEditingController emailController = TextEditingController();
//
//   resetPassword() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//
//     final Uri urls = Uri.parse('$url/and_forget_password_post/');
//
//     try {
//       final response = await http.post(urls, body: {
//         'em_add': emailController.text,
//       });
//
//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//         if (body['status'] == 'ok') {
//           Fluttertoast.showToast(msg: 'Check your email for reset code');
//           Navigator.pop(context);
//         } else {
//           Fluttertoast.showToast(msg: 'Invalid Email');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Server error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Forgot Password")),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             const Icon(Icons.email, size: 60, color: Colors.deepPurple),
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 labelText: "Enter your Email",
//                 prefixIcon: const Icon(Icons.mail),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.send),
//                 label: const Text("Send Reset Code"),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   backgroundColor: Colors.deepPurple,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 onPressed: () {
//                   resetPassword();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
