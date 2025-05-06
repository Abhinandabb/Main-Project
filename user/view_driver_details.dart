import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
      home: const view_driver_details(title: 'Flutter Demo Home Page'),
    );
  }
}

class view_driver_details extends StatefulWidget {
  const view_driver_details({super.key, required this.title});


  final String title;

  @override
  State<view_driver_details> createState() => _view_driver_detailsState();
}

class _view_driver_detailsState extends State<view_driver_details> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.deepPurpleAccent,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(name),
            Text(email),
            Text(age),
            Text(gender),
            Text(place),
            Text(pin),
            Text(post),
            Text(photo),
            Text(mobileno),

          ],
        ),
      ),

    );
  }
  String name="";
  String email="";
  String age="";
  String gender="";
  String place="";
  String pin="";
  String post="";
  String photo="";
  String mobileno="";

  getdata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/myapp/u_driver_details/');
    try {
      final response = await http.post(urls, body: {
        'lid':lid,



      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {


          setState(() {
            name=jsonDecode(response.body)['name'].toString();
            email=jsonDecode(response.body)['email'].toString();
            age=jsonDecode(response.body)['age'].toString();
            gender=jsonDecode(response.body)['gender'].toString();
            place=jsonDecode(response.body)['place'].toString();
            pin=jsonDecode(response.body)['pin'].toString();
            post=jsonDecode(response.body)['post'].toString();
            photo=jsonDecode(response.body)['photo'].toString();
            mobileno=jsonDecode(response.body)['mobile_no'].toString();
          });

        }else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e){
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
