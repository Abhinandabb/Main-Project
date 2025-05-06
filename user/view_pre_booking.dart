import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_transportation/user/send_complaints_against_driv.dart';
import 'package:public_transportation/user/user_driv_view_profile.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const view_pre_booking(title: 'My Pre-Bookings'),
    );
  }
}

class view_pre_booking extends StatefulWidget {
  const view_pre_booking({super.key, required this.title});
  final String title;

  @override
  State<view_pre_booking> createState() => _view_pre_bookingState();
}

class _view_pre_bookingState extends State<view_pre_booking> {
  _view_pre_bookingState() {
    getData();
  }

  late Razorpay _razorpay;
  List<String> id_ = [], driver_ = [], date_ = [], time_ = [], amount_ = [], qr_ = [],
      status_ = [], latitude_ = [], longitude_ = [], pickup_latitude_ = [],
      pickup_longitude_ = [], booking_date_ = [], did_ = [], lat_ = [], long_ = [], p_amount_ = [];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _addRazorpayListeners(String status, int index) async {
    _razorpay.clear();

    if (status == "Accepted") {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      _openCheckout(2000); // ₹20 (in paise)
    } else if (status == "paid") {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleCustomPaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

      double amount = double.tryParse(p_amount_[index]) ?? 0;
      int amountInPaise = (amount * 100).toInt();

      SharedPreferences sh = await SharedPreferences.getInstance();
      sh.setString('amount', amount.toString()); // Store amount in rupees for backend
      sh.setString('spid', id_[index]);
      String lid=sh.getString('lid').toString();
      // sh.setString('lid', did_[index]);

      _openCheckout(amountInPaise); // Custom amount
    }
  }

  void _openCheckout(int amountInPaise) {
    var options = {
      'key': 'rzp_test_HKCAwYtLt0rwQe',
      'amount': amountInPaise,
      'name': 'Cab Booking Payment',
      'description': 'Payment for pre-booked cab',
      'prefill': {'contact': '9747360170', 'email': 'tlikhil@gmail.com'},
      'external': {'wallets': ['paytm']},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String spid = sh.getString('spid').toString();

      final Uri uri = Uri.parse('$urls/pay_prebooking/');
      var response = await http.post(uri, body: {'id': spid});
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'ok') {
        Fluttertoast.showToast(msg: 'Payment Successful');
        getData();
      } else {
        Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
    }
    print("Payment Successful: ${response.paymentId}");
  }

  Future<void> _handleCustomPaymentSuccess(PaymentSuccessResponse response) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String spid = sh.getString('spid') ?? '';
      String lid = sh.getString('lid').toString();
      String amnt = sh.getString('amount') ?? '0'; // amount in rupees as string

      final Uri uri = Uri.parse('$urls/prebooking_payment/');
      var res = await http.post(uri, body: {
        'lid': lid,
        'pid': spid,

        'amount': amnt,
      });

      var jsonResponse = json.decode(res.body);

      if (jsonResponse['status'] == 'ok') {
        Fluttertoast.showToast(msg: 'Custom Payment Successful');
        getData();
      } else {
        Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
    }
    print("Custom Payment Successful: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Error in Payment: ${response.code} - ${response.message}");
    Fluttertoast.showToast(msg: 'Payment Failed: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  Future<void> _cancelBooking(String bookingId) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url').toString();

      final Uri uri = Uri.parse('$url/pre_cancel_booking/');
      var response = await http.post(uri, body: {'id': bookingId});
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'ok') {
        Fluttertoast.showToast(msg: 'Booking Canceled Successfully');
        getData();
      } else {
        Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
    }
  }

  getData() async {
    List<String> id = [], driver = [], date = [], time = [], amount = [], qr = [],
        status = [], latitude = [], longitude = [], pickup_latitude = [],
        pickup_longitude = [], booking_date = [], did = [], lat = [], long = [], p_amount = [];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String img = sh.getString('img_url').toString();
      String url = '$urls/u_view_pre_booking/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];
      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        did.add(arr[i]['did'].toString());
        driver.add(arr[i]['driver'].toString());
        date.add(arr[i]['date'].toString());
        latitude.add(arr[i]['latitude'].toString());
        longitude.add(arr[i]['longitude'].toString());
        pickup_latitude.add(arr[i]['pickup_latitude'].toString());
        pickup_longitude.add(arr[i]['pickup_longitude'].toString());
        booking_date.add(arr[i]['booking_date'].toString());
        time.add(arr[i]['time'].toString());
        amount.add(arr[i]['amount'].toString());
        qr.add(img + arr[i]['qr'].toString());
        lat.add(arr[i]['lat'].toString());
        long.add(arr[i]['long'].toString());
        p_amount.add(arr[i]['p_amount'].toString());
        status.add(arr[i]['status'].toString());
      }

      setState(() {
        id_ = id;
        did_ = did;
        driver_ = driver;
        date_ = date;
        booking_date_ = booking_date;
        latitude_ = latitude;
        longitude_ = longitude;
        pickup_latitude_ = pickup_latitude;
        pickup_longitude_ = pickup_longitude;
        time_ = time;
        amount_ = amount;
        p_amount_ = p_amount;
        qr_ = qr;
        lat_ = lat;
        long_ = long;
        status_ = status;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.deepPurpleAccent,
      ),


      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: id_.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: id_.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking Info Section
                    _buildInfoRow("Driver:", driver_[index], Icons.person),
                    _buildInfoRow("Travel Date:", booking_date_[index], Icons.calendar_today),
                    _buildInfoRow("Booking Date:", date_[index], Icons.date_range),
                    _buildInfoRow("Time:", time_[index], Icons.access_time),
                    if (status_[index]=="paid")...{
                      _buildInfoRow("Amount:", "₹${p_amount_[index]}", Icons.attach_money),

                    }
                    else...
                    {
                      _buildInfoRow("Amount:", "₹${p_amount_[index]}", Icons.attach_money),
                    },
                    // Status with colored indicator
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: _getStatusColor(status_[index])),
                          SizedBox(width: 12),
                          Text("Status: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(status_[index],
                              style: TextStyle(color: _getStatusColor(status_[index]))),
                        ],
                      ),
                    ),

                    // QR Code Section
                    if (qr_[index].isNotEmpty)
                      Column(
                        children: [
                          Divider(),
                          Center(
                            child: Column(
                              children: [
                                Text(" QR Code", style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(" QR Code",
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                              SizedBox(height: 16),
                                              Image.network(qr_[index]),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Image.network(qr_[index], height: 100, width: 100),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    // Action Buttons Section
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (status_[index] != "Cancelled" && status_[index] != "Rejected"&& status_[index] != "Completed")
                            ActionButton(
                              text: "Cancel Booking",
                              icon: Icons.cancel,
                              color: Colors.red,
                              onPressed: () => _cancelBooking(id_[index]),
                            ),

                          if (status_[index] == "Accepted" || status_[index] == "Completed" || status_[index] == "verified" || status_[index] == "paid")
                            ActionButton(
                              text: "Driver Details",
                              icon: Icons.directions_car,
                              color: Colors.blue,
                              onPressed: () async {
                                SharedPreferences sh = await SharedPreferences.getInstance();
                                sh.setString('did', did_[index]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => user_drv_view_profile(title: 'Driver Details'),
                                  ),
                                );
                              },
                            ),

                          if (status_[index] == "Accepted" || status_[index] == "Completed" || status_[index] == "verified" || status_[index] == "paid")
                            ActionButton(
                              text: "File Complaint",
                              icon: Icons.report_problem,
                              color: Colors.orange,
                              onPressed: () async {
                                SharedPreferences sh = await SharedPreferences.getInstance();
                                sh.setString('did', did_[index]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => send_complaints_against_driver(title: 'Complaint'),
                                  ),
                                );
                              },
                            ),

                          if (status_[index] == "verified" || status_[index] == "paid")
                            ActionButton(
                              text: "Locate Driver",
                              icon: Icons.location_on,
                              color: Colors.green,
                              onPressed: () async {
                                if (!await launchUrl(Uri.parse("https://maps.google.com/?q=${lat_[index]},${long_[index]}"))) {
                                  Fluttertoast.showToast(msg: 'Could not launch maps');
                                }
                              },
                            ),
                          status_[index] == "Accepted"
                              ? ActionButton(
                            text: "Pay ₹20",
                            icon: Icons.payment,
                            color: Colors.purple,
                            onPressed: () async {
                              SharedPreferences sh = await SharedPreferences.getInstance();
                              sh.setString('spid', id_[index]);
                              await _addRazorpayListeners("Accepted", index); // ✅ call this

                              // _openCheckout(2000); // Fixed ₹20
                            },
                          )
                              : status_[index] == "paid" || status_[index] == "verified"
                              ? ActionButton(
                            text: "Pay Custom",
                            icon: Icons.payment,
                            color: Colors.green,
                            onPressed: () async {
                              SharedPreferences sh = await SharedPreferences.getInstance();
                              sh.setString('spid', id_[index]);

                              // Calculate or fetch p_amount here
                              String amountString = p_amount_[index]; // assuming p_amount is a list of strings like ["50", "120.5"]
                              double amount = double.tryParse(amountString) ?? 0;
                              int amountInPaise = (amount * 100).toInt();

                              sh.setString('amount', amountString);
                              // Save for backend use if needed
                              await _addRazorpayListeners("paid", index); // ✅ call this

                              // _openCheckout(amountInPaise);
                            },
                          )
                              : Container(),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

    );
  }
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          SizedBox(width: 8),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'verified':
        return Colors.blue;
      case 'paid':
        return Colors.purple;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Future<void> _cancelBooking(String bookingId) async {
  //   try {
  //     SharedPreferences sh = await SharedPreferences.getInstance();
  //     String url = sh.getString('url').toString();
  //
  //     final Uri uri = Uri.parse('$url/pre_cancel_booking/');
  //     var response = await http.post(uri, body: {'id': bookingId});
  //     var jsonResponse = json.decode(response.body);
  //
  //     if (jsonResponse['status'] == 'ok') {
  //       Fluttertoast.showToast(msg: 'Booking Canceled Successfully');
  //       getdata();
  //     } else {
  //       Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
  //   }
  // }
}
class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
    );
  }
}






// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:public_transportation/user/send_complaints_against_driv.dart';
// import 'package:public_transportation/user/user_driv_view_profile.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
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
//       title: 'Pre-Bookings',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const view_pre_booking(title: 'My Pre-Bookings'),
//     );
//   }
// }
//
// class view_pre_booking extends StatefulWidget {
//   const view_pre_booking({super.key, required this.title});
//   final String title;
//
//   @override
//   State<view_pre_booking> createState() => _view_pre_bookingState();
// }
//
// class _view_pre_bookingState extends State<view_pre_booking> {
//   _view_pre_bookingState() {
//     getdata();
//   }
//
//   late Razorpay _razorpay;
//   List id_ = [], driver_ = [], date_ = [], time_ = [], amount_ = [], qr_ = [],
//       status_ = [], latitude_ = [], longitude_ = [], pickup_latitude_ = [],
//       pickup_longitude_ = [], booking_date_ = [], did_ = [], lat_ = [], long_ = [] ,p_amount_=[];
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url').toString();
//       String spid = sh.getString('spid').toString();
//
//       final Uri uri = Uri.parse('$url/pay_prebooking/');
//       var response = await http.post(uri, body: {'id': spid});
//       var jsonResponse = json.decode(response.body);
//
//       if (jsonResponse['status'] == 'ok') {
//         Fluttertoast.showToast(msg: 'Payment Successful');
//         getdata();
//       } else {
//         Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
//     }
//     print("Payment Successful: ${response.paymentId}");
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     print("Error in Payment: ${response.code} - ${response.message}");
//     Fluttertoast.showToast(msg: 'Payment Failed: ${response.message}');
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print("External Wallet: ${response.walletName}");
//   }
//
//
//
//   void _openCheckout() {
//     var options = {
//       'key': 'rzp_test_HKCAwYtLt0rwQe',
//       'amount': 2000,
//       'name': 'Cab Booking Payment',
//       'description': 'Payment for pre-booked cab',
//       'prefill': {'contact': '9747360170', 'email': 'tlikhil@gmail.com'},
//       'external': {'wallets': ['paytm']}
//
//
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: ${e.toString()}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title, style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.deepPurpleAccent,
//         // backgroundColor: Colors.blue[800],
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.blue.shade50, Colors.white],
//           ),
//         ),
//         child: id_.isEmpty
//             ? Center(child: CircularProgressIndicator())
//             : ListView.builder(
//           padding: EdgeInsets.all(16),
//           itemCount: id_.length,
//           itemBuilder: (context, index) {
//             return Card(
//               elevation: 4,
//               margin: EdgeInsets.only(bottom: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Booking Info Section
//                     _buildInfoRow("Driver:", driver_[index], Icons.person),
//                     _buildInfoRow("Travel Date:", booking_date_[index], Icons.calendar_today),
//                     _buildInfoRow("Booking Date:", date_[index], Icons.date_range),
//                     _buildInfoRow("Time:", time_[index], Icons.access_time),
//                     if (status_[index]=="paid")...{
//                       _buildInfoRow("Amount:", "₹${p_amount_[index]}", Icons.attach_money),
//
//                     }
//                     else...
//                       {
//                         _buildInfoRow("Amount:", "₹${amount_[index]}", Icons.attach_money),
//                       },
//                     // Status with colored indicator
//                     Padding(
//                       padding: EdgeInsets.symmetric(vertical: 8),
//                       child: Row(
//                         children: [
//                           Icon(Icons.info, color: _getStatusColor(status_[index])),
//                           SizedBox(width: 12),
//                           Text("Status: ", style: TextStyle(fontWeight: FontWeight.bold)),
//                           Text(status_[index],
//                               style: TextStyle(color: _getStatusColor(status_[index]))),
//                         ],
//                       ),
//                     ),
//
//                     // QR Code Section
//                     if (qr_[index].isNotEmpty)
//                       Column(
//                         children: [
//                           Divider(),
//                           Center(
//                             child: Column(
//                               children: [
//                                 Text(" QR Code", style: TextStyle(fontWeight: FontWeight.bold)),
//                                 SizedBox(height: 8),
//                                 InkWell(
//                                   onTap: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) => Dialog(
//                                         child: Padding(
//                                           padding: EdgeInsets.all(16),
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Text(" QR Code",
//                                                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                                               SizedBox(height: 16),
//                                               Image.network(qr_[index]),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   child: Image.network(qr_[index], height: 100, width: 100),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//
//                     // Action Buttons Section
//                     Padding(
//                       padding: EdgeInsets.only(top: 16),
//                       child: Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: [
//                           if (status_[index] != "Cancelled" && status_[index] != "Rejected")
//                             ActionButton(
//                               text: "Cancel Booking",
//                               icon: Icons.cancel,
//                               color: Colors.red,
//                               onPressed: () => _cancelBooking(id_[index]),
//                             ),
//
//                           if (status_[index] == "Accepted" || status_[index] == "verified" || status_[index] == "paid")
//                             ActionButton(
//                               text: "Driver Details",
//                               icon: Icons.directions_car,
//                               color: Colors.blue,
//                               onPressed: () async {
//                                 SharedPreferences sh = await SharedPreferences.getInstance();
//                                 sh.setString('did', did_[index]);
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => user_drv_view_profile(title: 'Driver Details'),
//                                   ),
//                                 );
//                               },
//                             ),
//
//                           if (status_[index] == "Accepted" || status_[index] == "verified" || status_[index] == "paid")
//                             ActionButton(
//                               text: "File Complaint",
//                               icon: Icons.report_problem,
//                               color: Colors.orange,
//                               onPressed: () async {
//                                 SharedPreferences sh = await SharedPreferences.getInstance();
//                                 sh.setString('did', did_[index]);
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => send_complaints_against_driver(title: 'Complaint'),
//                                   ),
//                                 );
//                               },
//                             ),
//
//                           if (status_[index] == "verified" || status_[index] == "paid")
//                             ActionButton(
//                               text: "Locate Driver",
//                               icon: Icons.location_on,
//                               color: Colors.green,
//                               onPressed: () async {
//                                 if (!await launchUrl(Uri.parse("https://maps.google.com/?q=${lat_[index]},${long_[index]}"))) {
//                                   Fluttertoast.showToast(msg: 'Could not launch maps');
//                                 }
//                               },
//                             ),
//
//                           if (status_[index] == "paid" )
//                             ActionButton(
//                               text: " Pay",
//                               icon: Icons.payment_sharp,
//                               color: Colors.teal,
//                               onPressed: () async {
//                                 SharedPreferences sh = await SharedPreferences.getInstance();
//                                 sh.setString('spid', id_[index]);
//                                 _openCheckout();
//                               },
//                             ),
//
//                           if (status_[index] == "Accepted" || status_[index] == "verified")
//                             ActionButton(
//                               text: " Payment",
//                               icon: Icons.payment,
//                               color: Colors.purple,
//                               onPressed: () async {
//                                 SharedPreferences sh = await SharedPreferences.getInstance();
//                                 sh.setString('spid', id_[index]);
//                                 _openCheckout();
//                               },
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value, IconData icon) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 20, color: Colors.blue),
//           SizedBox(width: 8),
//           Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
//           SizedBox(width: 8),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'accepted':
//         return Colors.green;
//       case 'verified':
//         return Colors.blue;
//       case 'paid':
//         return Colors.purple;
//       case 'cancelled':
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   Future<void> _cancelBooking(String bookingId) async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url').toString();
//
//       final Uri uri = Uri.parse('$url/pre_cancel_booking/');
//       var response = await http.post(uri, body: {'id': bookingId});
//       var jsonResponse = json.decode(response.body);
//
//       if (jsonResponse['status'] == 'ok') {
//         Fluttertoast.showToast(msg: 'Booking Canceled Successfully');
//         getdata();
//       } else {
//         Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
//     }
//   }
//
//   getdata() async {
//     List id = [], driver = [], date = [], time = [], amount = [], qr = [],
//         status = [], latitude = [], longitude = [], pickup_latitude = [],
//         pickup_longitude = [], booking_date = [], did = [], lat = [], long = [], p_amount=[];
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String img = sh.getString('img_url').toString();
//       String url = '$urls/u_view_pre_booking/';
//
//       var data = await http.post(Uri.parse(url), body: {'lid': lid});
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//       var arr = jsondata["data"];
//
//       print(arr.length);
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         did.add(arr[i]['did'].toString());
//         driver.add(arr[i]['driver'].toString());
//         date.add(arr[i]['date'].toString());
//         latitude.add(arr[i]['latitude'].toString());
//         longitude.add(arr[i]['longitude'].toString());
//         pickup_latitude.add(arr[i]['pickup_latitude'].toString());
//         pickup_longitude.add(arr[i]['pickup_longitude'].toString());
//         booking_date.add(arr[i]['booking_date'].toString());
//         time.add(arr[i]['time'].toString());
//         amount.add(arr[i]['amount'].toString());
//         qr.add(img + arr[i]['qr'].toString());
//         lat.add(arr[i]['lat'].toString());
//         long.add(arr[i]['long'].toString());
//         p_amount.add(arr[i]['p_amount'].toString());
//         status.add(arr[i]['status'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         did_ = did;
//         driver_ = driver;
//         date_ = date;
//         booking_date_ = booking_date;
//         latitude_ = latitude;
//         longitude_ = longitude;
//         pickup_latitude_ = pickup_latitude;
//         pickup_longitude_ = pickup_longitude;
//         time_ = time;
//         amount_ = amount;
//         p_amount_=p_amount;
//         qr_ = qr;
//         lat_ = lat;
//         long_ = long;
//         status_ = status;
//       });
//
//       print(statuss);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//     }
//   }
// }
//
// class ActionButton extends StatelessWidget {
//   final String text;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onPressed;
//
//   const ActionButton({
//     required this.text,
//     required this.icon,
//     required this.color,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       icon: Icon(icon, size: 16),
//       label: Text(text),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         foregroundColor: Colors.white,
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//       onPressed: onPressed,
//     );
//   }
// }