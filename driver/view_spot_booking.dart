//
//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:public_transportation/driver/send_complaints_against_user.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
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
//       home: const view_spot_bookings(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class view_spot_bookings extends StatefulWidget {
//   const view_spot_bookings({super.key, required this.title});
//   final String title;
//
//   @override
//   State<view_spot_bookings> createState() => _view_spot_bookingsState();
// }
//
// class _view_spot_bookingsState extends State<view_spot_bookings> {
//
//   _view_spot_bookingsState(){
//     getssdata();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: ListView.builder(
//         itemCount: id_.length,
//         itemBuilder: (context, index) {
//           return Card(
//             child: Column(
//               children: [
//                 _buildRow("Date", date_[index]),
//                 _buildRow("User", user_[index]),
//                 // _buildRow("Latitude", latitude_[index]),
//                 // _buildRow("Longitude", longitude_[index]),
//                 _buildRow("Location", location_[index]),
//                 _buildRow("Amount", amount_[index]),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //     Text("QR:", style: TextStyle()),
//                 //     Image.network(qr_[index], height: 100, width: 100),
//                 //   ],
//                 // ),
//
//
//                 _buildRow("Status", sts_[index]),
//
//                 // Approve & Reject Buttons (if status is pending)
//                 if (sts_[index] == "pending") ...[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () async {
//                           try {
//                             SharedPreferences sh = await SharedPreferences.getInstance();
//                             String url = sh.getString('url').toString();
//
//                             final Uri uri = Uri.parse('$url/d_s_bookings_accept/');  // API endpoint
//
//                             var response = await http.post(uri, body: {
//                               'id': id_[index], // Booking ID
//                             });
//
//                             var jsonResponse = json.decode(response.body);
//
//                             if (jsonResponse['status'] == 'ok') {
//                               Fluttertoast.showToast(msg: 'Booking Approved Successfully');
//
//                               // Refresh the data after cancellation
//                               getssdata();
//                             } else {
//                               Fluttertoast.showToast(msg: 'Error:');
//                             }
//                           } catch (e) {
//                             Fluttertoast.showToast(msg: 'Network Error:');
//                           }
//                         },
//                         child: Text("Approve"),
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           try {
//                             SharedPreferences sh = await SharedPreferences.getInstance();
//                             String url = sh.getString('url').toString();
//
//                             final Uri uri = Uri.parse('$url/d_s_bookings_reject/');  // API endpoint
//
//                             var response = await http.post(uri, body: {
//                               'id': id_[index], // Booking ID
//                             });
//
//                             var jsonResponse = json.decode(response.body);
//
//                             if (jsonResponse['status'] == 'ok') {
//                               Fluttertoast.showToast(msg: 'Booking Rejected ');
//
//                               // Refresh the data after cancellation
//                               getssdata();
//                             } else {
//                               Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
//                             }
//                           } catch (e) {
//                             Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
//                           }
//                         },
//                         child: Text("Reject"),
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//
//                       ),
//
//                     ]
//
//                     ,
//                   ),
//                 ] else if (sts_[index] == "Accepted" || sts_[index] == "verified"|| sts_[index] == "paid")...[
//
//                   ElevatedButton(
//                     onPressed: () async {
//                       SharedPreferences sh = await SharedPreferences
//                           .getInstance();
//                       sh.setString('uid', uid_[index]);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               send_complaints_against_user(
//                                   title: 'Complaints'),
//                         ),
//                       );
//                     },
//                     child: Text("Complaint"),
//                   ),
//                   if (sts_[index] == "paid" || sts_[index] == "verified")
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (!await launchUrl(Uri.parse("https://maps.google.com/?q="+latitude_[index]+","+longitude_[index]+""))) {
//                         throw Exception('Could not launch ');
//                       }
//                     },
//                     child: Text("Locate"),
//                   )
//
//
//                 ]
//
//
//
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [Text(label), Text(value)],
//       ),
//     );
//   }
//
//   List id_ = [], user_ = [], date_ = [], amount_ = [], qr_ = [], latitude_ = [], longitude_ = [], location_ = [], sts_=[] ,uid_=[];
//
//   getssdata() async {
//     List id = [], user = [], date = [], amount = [], qr = [], latitude = [], longitude = [], location = [], sts = [],uid=[];
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//
//       // String img = sh.getString('img_url').toString();
//       String url = '$urls/d_view_spot_bookings/';
//
//       var data = await http.post(Uri.parse(url), body: {'lid': lid});
//       var jsondata = json.decode(data.body);
//       var arr = jsondata["data"];
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         uid.add(arr[i]['uid'].toString());
//         date.add(arr[i]['date'].toString());
//         user.add(arr[i]['user'].toString());
//         latitude.add(arr[i]['latitude'].toString());
//         longitude.add(arr[i]['longitude'].toString());
//         location.add(arr[i]['location'].toString());
//         amount.add(arr[i]['amount'].toString());
//         // qr.add(img+arr[i]['qr'].toString());
//         sts.add(arr[i]['status'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         uid_=uid;
//         date_ = date;
//         user_ = user;
//         latitude_ = latitude;
//         longitude_ = longitude;
//         location_ = location;
//         amount_ = amount;
//         qr_ = qr;
//         sts_ = sts;
//       });
//     } catch (e) {
//       print("Error: ${e.toString()}");
//     }
//   }
//
//   updateStatus(String id, String newStatus) async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url').toString();
//
//       final Uri uri = Uri.parse('$url/d_view_spot_bookings/');
//       var response = await http.post(uri, body: {'id': id, 'status': newStatus});
//
//       var jsonResponse = json.decode(response.body);
//       if (jsonResponse['status'] == 'ok') {
//         Fluttertoast.showToast(msg: 'Booking $newStatus Successfully');
//         getssdata();
//       } else {
//         Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_transportation/driver/send_complaints_against_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spot Bookings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const view_spot_bookings(title: 'Spot Bookings'),
    );
  }
}

class view_spot_bookings extends StatefulWidget {
  const view_spot_bookings({super.key, required this.title});
  final String title;

  @override
  State<view_spot_bookings> createState() => _view_spot_bookingsState();
}

class _view_spot_bookingsState extends State<view_spot_bookings> {
  _view_spot_bookingsState() {
    getssdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.white],
          ),
        ),
        child: id_.isEmpty
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
          ),
        )
            : RefreshIndicator(
          onRefresh: () async {
            await getssdata();
          },
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: id_.length,
            itemBuilder: (context, index) {
              return _buildBookingCard(index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(int index) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Booking #${id_[index]}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(sts_[index]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    sts_[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildInfoRow(Icons.calendar_today, "Date:", date_[index]),
            _buildInfoRow(Icons.person, "User:", user_[index]),
            _buildInfoRow(Icons.location_on, "Location:", location_[index]),
            _buildInfoRow(Icons.attach_money, "Amount:", "₹${amount_[index]}"),
            _buildInfoRow(Icons.phone_android, "Mobile_no:", mobile_no_[index]),
            SizedBox(height: 16),
            if (sts_[index] == "pending") _buildActionButtons(index),
            if (sts_[index] == "Accepted" || sts_[index] == "verified" || sts_[index] == "paid" || sts_[index]=="Completed")
              _buildSecondaryActions(index),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blue[800]),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(
                    text: "$label ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.check_circle, size: 18),
            label: Text("Approve"),
            onPressed: () async {
              try {
                SharedPreferences sh = await SharedPreferences.getInstance();
                String url = sh.getString('url').toString();

                final Uri uri = Uri.parse('$url/d_s_bookings_accept/');

                var response = await http.post(uri, body: {
                  'id': id_[index],
                });

                var jsonResponse = json.decode(response.body);

                if (jsonResponse['status'] == 'ok') {
                  Fluttertoast.showToast(msg: 'Booking Approved Successfully');
                  getssdata();
                } else {
                  Fluttertoast.showToast(msg: 'Error:');
                }
              } catch (e) {
                Fluttertoast.showToast(msg: 'Network Error:');
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.cancel, size: 18),
            label: Text("Reject"),
            onPressed: () async {
              try {
                SharedPreferences sh = await SharedPreferences.getInstance();
                String url = sh.getString('url').toString();

                final Uri uri = Uri.parse('$url/d_s_bookings_reject/');

                var response = await http.post(uri, body: {
                  'id': id_[index],
                });

                var jsonResponse = json.decode(response.body);

                if (jsonResponse['status'] == 'ok') {
                  Fluttertoast.showToast(msg: 'Booking Rejected');
                  getssdata();
                } else {
                  Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
                }
              } catch (e) {
                Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  // if(sts_[index] == "paid" || sts_[index] == "Verified" || sts_[index] == "Accepted" || sts_[index] == "Completed") ...[
  Widget _buildSecondaryActions(int index) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.report_problem, size: 18),
            label: Text("Complaint"),
            onPressed: () async {
              SharedPreferences sh = await SharedPreferences.getInstance();
              sh.setString('uid', uid_[index]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      send_complaints_against_user(title: 'Complaints'),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.orange,
              side: BorderSide(color: Colors.orange),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
  // ]
        if (sts_[index] == "paid" || sts_[index] == "verified") ...[
          SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              icon: Icon(Icons.map, size: 18),
              label: Text("Locate"),
              onPressed: () async {
                if (!await launchUrl(Uri.parse(
                    "https://maps.google.com/?q=${latitude_[index]},${longitude_[index]}"))) {
                  throw Exception('Could not launch');
                }
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.blue,
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'verified':
        return Colors.purple;
      case 'paid':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List id_ = [],
      user_ = [],
      date_ = [],
      amount_ = [],
      qr_ = [],
      latitude_ = [],
      longitude_ = [],
      location_ = [],
      sts_ = [],
      uid_ = [],
      mobile_no_=[];

  getssdata() async {
    List id = [],
        user = [],
        date = [],
        amount = [],
        qr = [],
        latitude = [],
        longitude = [],
        location = [],
        sts = [],
        uid = [],
        mobile_no = [];
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();

      String url = '$urls/d_view_spot_bookings/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        uid.add(arr[i]['uid'].toString());
        date.add(arr[i]['date'].toString());
        user.add(arr[i]['user'].toString());
        latitude.add(arr[i]['latitude'].toString());
        longitude.add(arr[i]['longitude'].toString());
        location.add(arr[i]['location'].toString());
        amount.add(arr[i]['amount'].toString());
        sts.add(arr[i]['status'].toString());
        mobile_no.add(arr[i]['Contact_number'].toString());
      }

      setState(() {
        id_ = id;
        uid_ = uid;
        date_ = date;
        user_ = user;
        latitude_ = latitude;
        longitude_ = longitude;
        location_ = location;
        amount_ = amount;
        qr_ = qr;
        sts_ = sts;
        mobile_no_=mobile_no;
      });
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  updateStatus(String id, String newStatus) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url').toString();

      final Uri uri = Uri.parse('$url/d_view_spot_bookings/');
      var response = await http.post(uri, body: {'id': id, 'status': newStatus});

      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'ok') {
        Fluttertoast.showToast(msg: 'Booking $newStatus Successfully');
        getssdata();
      } else {
        Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
    }
  }
}