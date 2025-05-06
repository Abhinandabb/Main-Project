// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:public_transportation/user/prebooking.dart';
// import 'package:public_transportation/user/view_pre_booking.dart';
// import 'package:public_transportation/user/view_spot_booking.dart';
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
//       home: const view_cabs(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class view_cabs extends StatefulWidget {
//   const view_cabs({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<view_cabs> createState() => _view_cabsState();
// }
//
// class _view_cabsState extends State<view_cabs> {
//  _view_cabsState(){
//    // Timer.periodic(Duration(seconds: 15), (timer) {
//      getdata();
//    // });
//  }
//  TextEditingController location_controller = new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//
//           backgroundColor: Theme
//               .of(context)
//               .colorScheme
//               .inversePrimary,
//
//           title: Text(widget.title),
//         ),
//         body: ListView.builder(
//           itemCount: id_.length,
//           itemBuilder: (context, index) {
//             return Card(
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Image.network(vehicle_photo_[index],height: 100,width: 100,),
//                       Image.network(photo_[index],height: 100,width: 100),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("name"),
//                         Text(name_[index]),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("mobile_no"),
//                         Text(mobile_no_[index]),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("vehicle"),
//                         Text(vehicle_[index]),
//                       ],
//                     ),
//                   ),Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("experience"),
//                         Text(experience_[index]),
//                       ],
//                     ),
//                   ),Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Active_status"),
//                         Text(astatus_[index]),
//                       ],
//                     ),
//                   ),
//                   ElevatedButton(onPressed: () async {
//                     showDialog(context: context, builder: (context) {
//                       return AlertDialog(
//                         title: Text("Destination"),
//                         content: TextField(
//                             controller:location_controller,
//                         ),
//                         actions: [
//                           TextButton(onPressed: () async {
//                             SharedPreferences sh = await SharedPreferences.getInstance();
//                             String url = sh.getString('url').toString();
//                             String lid = sh.getString('lid').toString();
//                             Position position = await Geolocator.getCurrentPosition(
//                               desiredAccuracy: LocationAccuracy.high,
//                             );
//                             String lat = position.latitude.toString();
//                             String lon = position.longitude.toString();
//
//                             final urls = Uri.parse('$url/u_spot_booking_cabs/');
//                             try {
//                               final response = await http.post(urls, body: {
//                                 'latitude':lat,
//                                 'longitude':lon,
//                                 'location':location_controller.text,
//                                 'lid':lid,
//
//                                 'did':id_[index],
//
//
//
//                               });
//                               if (response.statusCode == 200) {
//                                 String status = jsonDecode(response.body)['status'];
//                                 if (status=='ok') {
//                                   Navigator.pop(context);
//                                   Fluttertoast.showToast(msg: 'Booked Successfully');
//                                   getdata();
//                                 }else {
//                                   Fluttertoast.showToast(msg: 'Not Found');
//                                 }
//                               }
//                               else {
//                                 Fluttertoast.showToast(msg: 'Network Error');
//                               }
//                             }
//                             catch (e){
//                               Fluttertoast.showToast(msg: e.toString());
//                             }
//                           }, child: Text("ok")),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop(); // Closes the dialog
//                             },
//                             child: Text("Cancel"),
//                           )
//
//                         ],
//                       );
//                     },);
//
//                   },
//                       child: Text("spotbooking")),
//                   ElevatedButton(onPressed: () async {
//                     SharedPreferences sh = await SharedPreferences.getInstance();
//                     sh.setString("did", id_[index]);
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => pre_booking(title: 'Pre_booking', ),));
//                   }, child: Text("prebooking")),
//
//                 ],
//               ),
//             );
//           },)
//
//
//     );
//   }
//
//
//
//
//
//
//     List id_=[],name_=[],mobile_no_=[],photo_=[],vehicle_=[],vehicle_photo_=[],experience_=[],astatus_=[];
//     getdata() async {
//       List id=[],name=[],mobile_no=[],photo=[],vehicle=[],vehicle_photo=[],experience=[],astatus=[];
//       try {
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         String lat = position.latitude.toString();
//         String lon = position.longitude.toString();
//         SharedPreferences sh = await SharedPreferences.getInstance();
//         String urls = sh.getString('url').toString();
//         String lid = sh.getString('lid').toString();
//         String img_url = sh.getString('img_url').toString();
//         String url = '$urls/u_view_cabs/';
//         String nid="0";
//         if(sh.containsKey("nid")==false) {}
//         else{
//           nid=sh.getString('nid').toString();
//         }
//         Fluttertoast.showToast(msg:nid);
//         var data = await http.post(Uri.parse(url), body: {
//
//           'latitude':lat,
//           'longitude':lon,'lid':lid
//
//         });
//         var jsondata = json.decode(data.body);
//         String statuss = jsondata['status'];
//
//
//
//         var arr = jsondata["data"];
//
//         print(arr.length);
//
//         for (int i = 0; i < arr.length; i++) {
//           id.add(arr[i]['id'].toString());
//           name.add(arr[i]['name'].toString());
//           mobile_no.add(arr[i]['mobile_no'].toString());
//           photo.add(img_url+arr[i]['photo'].toString());
//           vehicle.add(arr[i]['vehicle'].toString());
//           vehicle_photo.add(img_url+arr[i]['vehicle_photo'].toString());
//           experience.add(arr[i]['experience'].toString());
//           astatus.add(arr[i]['Active_status'].toString());
//         }
//
//         setState(() {
//           id_ = id;
//           name_ = name;
//           mobile_no_ = mobile_no;
//           photo_ = photo;
//           vehicle_ = vehicle;
//           vehicle_photo_=vehicle_photo;
//           experience_=experience;
//           astatus_=astatus;
//         });
//
//         print(statuss);
//       } catch (e) {
//         print("Error ------------------- " + e.toString());
//         //there is error during converting file image to base64 encoding.
//       }
//     }
//
//
//
//   }
//
//


import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:public_transportation/user/prebooking.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Public Transportation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const view_cabs(title: 'Nearby Cabs'),
    );
  }
}

class view_cabs extends StatefulWidget {
  const view_cabs({super.key, required this.title});

  final String title;

  @override
  State<view_cabs> createState() => _view_cabsState();
}

class _view_cabsState extends State<view_cabs> {
  _view_cabsState() {
    getdata();
  }

  TextEditingController location_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: getdata,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: id_.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(vehicle_photo_[index], height: 80, width: 80),
                        SizedBox(width: 10),
                        Image.network(photo_[index], height: 80, width: 80),
                      ],
                    ),
                    SizedBox(height: 10),
                    infoRow("Name", name_[index]),
                    infoRow("Mobile", mobile_no_[index]),
                    infoRow("Vehicle", vehicle_[index]),
                    infoRow("Experience", experience_[index]),
                    infoRow("Active Status", astatus_[index]),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => bookSpot(index),
                          icon: Icon(Icons.directions_car),
                          label: Text("Spot Booking"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            SharedPreferences sh = await SharedPreferences.getInstance();
                            sh.setString("did", id_[index]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => pre_booking(title: 'Pre_booking')),
                            );
                          },
                          icon: Icon(Icons.schedule),
                          label: Text("Pre Booking"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  List id_ = [], name_ = [], mobile_no_ = [], photo_ = [], vehicle_ = [], vehicle_photo_ = [], experience_ = [], astatus_ = [];

  getdata() async {
    List id = [], name = [], mobile_no = [], photo = [], vehicle = [], vehicle_photo = [], experience = [], astatus = [];
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      String lat = position.latitude.toString();
      String lon = position.longitude.toString();

      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String img_url = sh.getString('img_url').toString();

      String url = '$urls/u_view_cabs/';
      var data = await http.post(Uri.parse(url), body: {
        'latitude': lat,
        'longitude': lon,
        'lid': lid
      });

      var jsondata = json.decode(data.body);
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        name.add(arr[i]['name'].toString());
        mobile_no.add(arr[i]['mobile_no'].toString());
        photo.add(img_url + arr[i]['photo'].toString());
        vehicle.add(arr[i]['vehicle'].toString());
        vehicle_photo.add(img_url + arr[i]['vehicle_photo'].toString());
        experience.add(arr[i]['experience'].toString());
        astatus.add(arr[i]['Active_status'].toString());
      }

      setState(() {
        id_ = id;
        name_ = name;
        mobile_no_ = mobile_no;
        photo_ = photo;
        vehicle_ = vehicle;
        vehicle_photo_ = vehicle_photo;
        experience_ = experience;
        astatus_ = astatus;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }

  void bookSpot(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Destination"),
          content: TextField(controller: location_controller),
          actions: [
            TextButton(
              onPressed: () async {
                SharedPreferences sh = await SharedPreferences.getInstance();
                String url = sh.getString('url').toString();
                String lid = sh.getString('lid').toString();
                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                String lat = position.latitude.toString();
                String lon = position.longitude.toString();

                final urls = Uri.parse('$url/u_spot_booking_cabs/');
                try {
                  final response = await http.post(urls, body: {
                    'latitude': lat,
                    'longitude': lon,
                    'location': location_controller.text,
                    'lid': lid,
                    'did': id_[index],
                  });

                  if (response.statusCode == 200) {
                    String status = jsonDecode(response.body)['status'];
                    if (status == 'ok') {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: 'Booked Successfully');
                      getdata();
                    } else {
                      Fluttertoast.showToast(msg: 'Booking Failed');
                    }
                  } else {
                    Fluttertoast.showToast(msg: 'Server Error');
                  }
                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              },
              child: Text("Book"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
