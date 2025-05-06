//
//
// import 'dart:convert';
//
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
//       home: const view_pre_bookings(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class view_pre_bookings extends StatefulWidget {
//   const view_pre_bookings({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<view_pre_bookings> createState() => _view_pre_bookingsState();
// }
//
// class _view_pre_bookingsState extends State<view_pre_bookings> {
//   _view_pre_bookingsState() {
//     getdata();
//   }
//
//   List id_ = [],
//       date_ = [],
//       user_ = [],
//       bookingdate_ = [],
//       amount_ = [],
//       latitude_ = [],
//       longitude_ = [],
//       pickup_latitude_ = [],
//       pickup_longitude_ = [],
//       time_ = [],
//       qr_ = [],
//       status_ = [],
//       uid_ = [];
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
//             margin: const EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 _buildRow("Date", date_[index]),
//                 _buildRow("User", user_[index]),
//                 // _buildRow("Latitude", latitude_[index]),
//                 // _buildRow("Longitude", longitude_[index]),
//                 // _buildRow("Pickup Latitude", pickup_latitude_[index]),
//                 // _buildRow("Pickup Longitude", pickup_longitude_[index]),
//                 _buildRow("Booking Date", bookingdate_[index]),
//                 _buildRow("Amount", amount_[index]),
//                 _buildRow("Time", time_[index]),
//                 _buildRow("Status", status_[index]),
//               if (status_[index] == "Accepted")
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     String lat = pickup_latitude_[index];
//                     String lng = pickup_longitude_[index];
//                     _launchMaps(lat, lng);
//                   },
//                   icon: Icon(Icons.location_pin),
//                   label: Text("Locate Pickup"),
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                 ),
//                 if (status_[index] == "Accepted")
//           ElevatedButton.icon(
//           onPressed: () {
//           String lat = latitude_[index];
//           String lng = longitude_[index];
//           _launchMaps(lat, lng);
//           },
//           icon: Icon(Icons.flag),
//           label: Text("Locate Destination"),
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//           ),
//
//                 if (status_[index] == "pending") ...[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () async {
//                           try {
//                             SharedPreferences sh =
//                             await SharedPreferences.getInstance();
//                             String url = sh.getString('url').toString();
//
//                             final Uri uri =
//                             Uri.parse('$url/d_p_bookings_accept/');
//
//                             var response = await http.post(uri, body: {
//                               'id': id_[index],
//                             });
//
//                             var jsonResponse = json.decode(response.body);
//
//                             if (jsonResponse['status'] == 'ok') {
//                               Fluttertoast.showToast(
//                                   msg: 'Booking Approved Successfully');
//                               getdata();
//                             } else {
//                               Fluttertoast.showToast(msg: 'Error:');
//                             }
//                           } catch (e) {
//                             Fluttertoast.showToast(msg: 'Network Error:');
//                           }
//                         },
//                         child: Text("Approve"),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green),
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           try {
//                             SharedPreferences sh =
//                             await SharedPreferences.getInstance();
//                             String url = sh.getString('url').toString();
//
//                             final Uri uri =
//                             Uri.parse('$url/d_p_bookings_reject/');
//
//                             var response = await http.post(uri, body: {
//                               'id': id_[index],
//                             });
//
//                             var jsonResponse = json.decode(response.body);
//
//                             if (jsonResponse['status'] == 'ok') {
//                               Fluttertoast.showToast(
//                                   msg: 'Booking Rejected ');
//                               getdata();
//                             } else {
//                               Fluttertoast.showToast(
//                                   msg: 'Error: ${jsonResponse['message']}');
//                             }
//                           } catch (e) {
//                             Fluttertoast.showToast(
//                                 msg: 'Network Error: ${e.toString()}');
//                           }
//                         },
//                         child: Text("Reject"),
//                         style:
//                         ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                       ),
//                     ],
//                   ),
//                 ] else if (status_[index] == "Accepted") ...[
//                   ElevatedButton(
//                     onPressed: () async {
//                       SharedPreferences sh =
//                       await SharedPreferences.getInstance();
//                       sh.setString('uid', uid_[index]);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               send_complaints_against_user(title: 'Complaints'),
//                         ),
//                       );
//                     },
//                     child: Text("Complaint"),
//                   )
//                 ]
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
//       padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [Text(label), Text(value)],
//       ),
//     );
//   }
//
//   Future<void> _launchMaps(String lat, String lng) async {
//     final Uri googleMapsUrl =
//     Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
//
//     if (await canLaunchUrl(googleMapsUrl)) {
//       await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
//     } else {
//       Fluttertoast.showToast(msg: "Could not open map.");
//     }
//   }
//
//   getdata() async {
//     List id = [],
//         date = [],
//         user = [],
//         bookingdate = [],
//         amount = [],
//         latitude = [],
//         longitude = [],
//         pickup_latitude = [],
//         pickup_longitude = [],
//         time = [],
//         qr = [],
//         status = [],
//         uid = [];
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/d_view_pre_bookings/';
//
//       var data = await http.post(Uri.parse(url), body: {'lid': lid});
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//       var arr = jsondata["data"];
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         uid.add(arr[i]['uid'].toString());
//         date.add(arr[i]['date'].toString());
//         user.add(arr[i]['user'].toString());
//         latitude.add(arr[i]['latitude'].toString());
//         longitude.add(arr[i]['longitude'].toString());
//         pickup_latitude.add(arr[i]['pickup_latitude'].toString());
//         pickup_longitude.add(arr[i]['pickup_longitude'].toString());
//         bookingdate.add(arr[i]['bookingdate'].toString());
//         amount.add(arr[i]['amount'].toString());
//         time.add(arr[i]['time'].toString());
//         status.add(arr[i]['status'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         uid_ = uid;
//         date_ = date;
//         user_ = user;
//         latitude_ = latitude;
//         longitude_ = longitude;
//         pickup_latitude_ = pickup_latitude;
//         pickup_longitude_ = pickup_longitude;
//         bookingdate_ = bookingdate;
//         amount_ = amount;
//         time_ = time;
//         qr_ = qr;
//         status_ = status;
//       });
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
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
      title: 'Pre-Bookings',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade800,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      home: const view_pre_bookings(title: 'Pre-Bookings'),
    );
  }
}

class view_pre_bookings extends StatefulWidget {
  const view_pre_bookings({super.key, required this.title});

  final String title;

  @override
  State<view_pre_bookings> createState() => _view_pre_bookingsState();
}

class _view_pre_bookingsState extends State<view_pre_bookings> {
  _view_pre_bookingsState() {
    getdata();
  }

  List id_ = [],
      date_ = [],
      user_ = [],
      bookingdate_ = [],
      amount_ = [],
      latitude_ = [],
      longitude_ = [],
      pickup_latitude_ = [],
      pickup_longitude_ = [],
      time_ = [],
      qr_ = [],
      status_ = [],
      uid_ = [],
      mobile_no_=[],
      p_amount_=[];

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              getdata();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : id_.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: id_.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Booking #${id_[index]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status_[index]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status_[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.person, 'User:', user_[index]),
                  _buildInfoRow(
                      Icons.calendar_month, 'Date:', date_[index]),
                  _buildInfoRow(
                      Icons.calendar_month, 'Travel Date:', bookingdate_[index]),
                  _buildInfoRow(Icons.access_time, 'Time:', time_[index]),
                  _buildInfoRow(Icons.attach_money, 'Amount:',
                      '₹${p_amount_[index]}'),
                  _buildInfoRow(Icons.phone_android, 'Mobile_no:', mobile_no_[index]),
                  const SizedBox(height: 16),
                  if (status_[index] == "paid"||status_[index] == "verified"  ) ...[

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _launchMaps(
                                  pickup_latitude_[index],
                                  pickup_longitude_[index]);
                            },
                            icon: const Icon(Icons.location_on,
                                size: 18),
                            label: const Text("Pickup"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _launchMaps(
                                  latitude_[index], longitude_[index]);
                            },
                            icon:
                            const Icon(Icons.flag, size: 18),
                            label: const Text("Destination"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (status_[index] == "Accepted" ||status_[index] == "verified" || status_[index] == "paid" || status_[index] =="Completed")
                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences sh =
                        await SharedPreferences.getInstance();
                        sh.setString('uid', uid_[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                send_complaints_against_user(
                                    title: 'Complaints'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.report, size: 18),
                          SizedBox(width: 8),
                          Text("Report User"),
                        ],
                      ),
                    ),
                  ] else if(status_[index]=="Completed"||status_[index] == "verified" )...[
                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences sh =
                        await SharedPreferences.getInstance();
                        sh.setString('uid', uid_[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                send_complaints_against_user(
                                    title: 'Complaints'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.report, size: 18),
                          SizedBox(width: 8),
                          Text("Report User"),
                        ],
                      ),
                    ),


                  ]
                  else if (status_[index] == "pending") ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                SharedPreferences sh =
                                await SharedPreferences
                                    .getInstance();
                                String url =
                                sh.getString('url').toString();

                                final Uri uri = Uri.parse(
                                    '$url/d_p_bookings_accept/');

                                var response = await http.post(uri,
                                    body: {
                                      'id': id_[index],
                                    });

                                var jsonResponse =
                                json.decode(response.body);

                                if (jsonResponse['status'] == 'ok') {
                                  Fluttertoast.showToast(
                                      msg:
                                      'Booking Approved Successfully');
                                  getdata();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Error:');
                                }
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg: 'Network Error:');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                            ),
                            child: const Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check, size: 18),
                                SizedBox(width: 8),
                                Text("Approve"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                SharedPreferences sh =
                                await SharedPreferences
                                    .getInstance();
                                String url =
                                sh.getString('url').toString();

                                final Uri uri = Uri.parse(
                                    '$url/d_p_bookings_reject/');

                                var response = await http.post(uri,
                                    body: {
                                      'id': id_[index],
                                    });

                                var jsonResponse =
                                json.decode(response.body);

                                if (jsonResponse['status'] == 'ok') {
                                  Fluttertoast.showToast(
                                      msg: 'Booking Rejected');
                                  getdata();
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                      'Error: ${jsonResponse['message']}');
                                }
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg:
                                    'Network Error: ${e.toString()}');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                            ),
                            child: const Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Icon(Icons.close, size: 18),
                                SizedBox(width: 8),
                                Text("Reject"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _launchMaps(String lat, String lng) async {
    final Uri googleMapsUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: "Could not open map.");
    }
  }

  getdata() async {
    List id = [],
        date = [],
        user = [],
        bookingdate = [],
        amount = [],
        latitude = [],
        longitude = [],
        pickup_latitude = [],
        pickup_longitude = [],
        time = [],
        qr = [],
        status = [],
        uid = [],
        mobile_no=[],
        p_amount=[];
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/d_view_pre_bookings/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        uid.add(arr[i]['uid'].toString());
        date.add(arr[i]['date'].toString());
        user.add(arr[i]['user'].toString());
        latitude.add(arr[i]['latitude'].toString());
        longitude.add(arr[i]['longitude'].toString());
        pickup_latitude.add(arr[i]['pickup_latitude'].toString());
        pickup_longitude.add(arr[i]['pickup_longitude'].toString());
        bookingdate.add(arr[i]['bookingdate'].toString());
        amount.add(arr[i]['amount'].toString());
        time.add(arr[i]['time'].toString());
        status.add(arr[i]['status'].toString());
        mobile_no.add(arr[i]['Contact_number'].toString());
        p_amount.add(arr[i]['p_amount'].toString());
      }

      setState(() {
        id_ = id;
        uid_ = uid;
        date_ = date;
        user_ = user;
        latitude_ = latitude;
        longitude_ = longitude;
        pickup_latitude_ = pickup_latitude;
        pickup_longitude_ = pickup_longitude;
        bookingdate_ = bookingdate;
        amount_ = amount;
        time_ = time;
        qr_ = qr;
        status_ = status;
        mobile_no_=mobile_no;
        p_amount_=p_amount;
        _isLoading = false;
      });
      print(status_);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error ------------------- " + e.toString());
    }
  }
}