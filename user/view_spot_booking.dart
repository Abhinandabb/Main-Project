//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:public_transportation/user/send_complaints_against_driv.dart';
// import 'package:public_transportation/user/track_cab.dart';
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
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const view_spot_booking(title: 'My Bookings'),
//     );
//   }
// }
//
// class view_spot_booking extends StatefulWidget {
//   const view_spot_booking({super.key, required this.title});
//   final String title;
//
//   @override
//   State<view_spot_booking> createState() => _view_spot_bookingState();
// }
//
// class _view_spot_bookingState extends State<view_spot_booking> {
//   _view_spot_bookingState() {
//     getdata();
//   }
//
//   late Razorpay _razorpay;
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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
//       final Uri uri = Uri.parse('$url/pay_booking/');
//       var response = await http.post(uri, body: {'id': spid});
//       var jsonResponse = json.decode(response.body);
//
//       if (jsonResponse['status'] == 'ok') {
//         Fluttertoast.showToast(msg: 'Payment Successfully');
//         getdata();
//       } else {
//         Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
//     }
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     print("Error in Payment: ${response.code} - ${response.message}");
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print("External Wallet: ${response.walletName}");
//   }
//
//   void _openCheckout() {
//     var options = {
//       'key': 'rzp_test_HKCAwYtLt0rwQe',
//       'amount': 2000,
//       'name': 'Flutter Razorpay Example',
//       'description': 'Payment for the product',
//       'prefill': {'contact': '9747360170', 'email': 'tlikhil@gmail.com'},
//       'external': {'wallets': ['paytm']}
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
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: ListView.builder(
//         itemCount: id_.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   buildRow(Icons.person, "Driver", driver_[index]),
//                   buildRow(Icons.attach_money, "Amount", amount_[index]),
//                   buildRow(Icons.calendar_today, "Date", date_[index]),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: const [
//                           Icon(Icons.qr_code, color: Colors.blueGrey),
//                           SizedBox(width: 8),
//                           Text("QR Code", style: TextStyle(fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                       InkWell(
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               content: Image.network(qr_[index]),
//                             ),
//                           );
//                         },
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(qr_[index], height: 60, width: 60),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   buildRow(Icons.info_outline, "Status", status_[index]),
//                   const SizedBox(height: 12),
//                   Wrap(
//                     spacing: 8,
//                     children: [
//                       if (status_[index] != "Cancelled" && status_[index] != "Rejected")
//                         ElevatedButton(
//                           onPressed: () async {
//                             SharedPreferences sh = await SharedPreferences.getInstance();
//                             String url = sh.getString('url').toString();
//                             final Uri uri = Uri.parse('$url/u_cancel_booking/');
//                             var response = await http.post(uri, body: {'id': id_[index]});
//                             var jsonResponse = json.decode(response.body);
//
//                             if (jsonResponse['status'] == 'ok') {
//                               Fluttertoast.showToast(msg: 'Booking Canceled Successfully');
//                               getdata();
//                             } else {
//                               Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
//                             }
//                           },
//                           child: const Text("Cancel"),
//                         ),
//                       if (["paid", "verified", "Accepted"].contains(status_[index]))
//                         ElevatedButton(
//                           onPressed: () async {
//                             SharedPreferences sh = await SharedPreferences.getInstance();
//                             sh.setString('did', did_[index]);
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => user_drv_view_profile(title: 'User_View_Driver_Details'),
//                               ),
//                             );
//                           },
//                           child: const Text("Driver Details"),
//                         ),
//                       if (["Accepted", "verified"].contains(status_[index]))
//                         ElevatedButton(
//                           onPressed: () async {
//                             SharedPreferences sh = await SharedPreferences.getInstance();
//                             sh.setString('spid', id_[index]);
//                             _openCheckout();
//                           },
//                           child: const Text("Pay"),
//                         ),
//                       if (status_[index] == "paid")
//                         ElevatedButton(
//                           onPressed: () async {
//                             SharedPreferences sh = await SharedPreferences.getInstance();
//                             sh.setString('did', did_[index]);
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => send_complaints_against_driver(title: 'Complaints'),
//                               ),
//                             );
//                           },
//                           child: const Text("Complaint"),
//                         ),
//                       if (["paid", "verified"].contains(status_[index]))
//                         ElevatedButton(
//                           onPressed: () async {
//                             final Uri mapUrl = Uri.parse("https://maps.google.com/?q=${lat_[index]},${long_[index]}");
//                             if (!await launchUrl(mapUrl)) {
//                               throw Exception('Could not launch map');
//                             }
//                           },
//                           child: const Text("Locate"),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   List id_ = [], driver_ = [], date_ = [], amount_ = [], qr_ = [], status_ = [], did_ = [], bookingid_ = [], lat_ = [], long_ = [];
//
//   getdata() async {
//     List id = [], driver = [], date = [], amount = [], qr = [], status = [], did = [], bookingid = [], lat = [], long = [];
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String img = sh.getString('img_url').toString();
//       String url = '$urls/u_view_spot_booking/';
//
//       var data = await http.post(Uri.parse(url), body: {'lid': lid});
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//
//       var arr = jsondata["data"];
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         did.add(arr[i]['did'].toString());
//         driver.add(arr[i]['driver'].toString());
//         date.add(arr[i]['date'].toString());
//         amount.add(arr[i]['amount'].toString());
//         qr.add(img + arr[i]['qr'].toString());
//         status.add(arr[i]['status'].toString());
//         lat.add(arr[i]['lat'].toString());
//         long.add(arr[i]['long'].toString());
//         bookingid.add(arr[i]['booking_id'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         did_ = did;
//         driver_ = driver;
//         date_ = date;
//         amount_ = amount;
//         qr_ = qr;
//         lat_ = lat;
//         long_ = long;
//         status_ = status;
//       });
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//     }
//   }
//
//   Widget buildRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: Colors.deepPurple),
//           const SizedBox(width: 10),
//           Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
//           Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:public_transportation/user/send_complaints_against_driv.dart';
import 'package:public_transportation/user/track_cab.dart';
import 'package:public_transportation/user/user_driv_view_profile.dart';
import 'package:public_transportation/user/view_pre_booking.dart';
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
      title: 'My Bookings',
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
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      home: const view_spot_booking(title: 'My Bookings'),
    );
  }
}

class view_spot_booking extends StatefulWidget {
  const view_spot_booking({super.key, required this.title});
  final String title;

  @override
  State<view_spot_booking> createState() => _view_spot_bookingState();
}

class _view_spot_bookingState extends State<view_spot_booking> {
  _view_spot_bookingState() {
    getdata();
  }

  late Razorpay _razorpay;

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
  Future<void> _addRazorpayListeners(String status, int index, [int? customAmountInPaise]) async {
    _razorpay.clear();

    if (status == "Accepted") {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

      _openCheckout(2000); // Flat ₹20 (in paise)
    } else if (status == "paid" && customAmountInPaise != null) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleCustomPaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

      SharedPreferences sh = await SharedPreferences.getInstance();
      sh.setString('spid', id_[index]);

      _openCheckout(customAmountInPaise); // Use calculated amount
    }
  }

  // Future<void> _addRazorpayListeners(String status, int index) async {
  //   _razorpay.clear();
  //
  //   if (status == "Accepted") {
  //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  //     _openCheckout(2000); // ₹20 (in paise)
  //   } else if (status == "paid") {
  //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleCustomPaymentSuccess);
  //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  //
  //     double amount = double.tryParse(p_amount_[index]) ?? 0;
  //     int amountInPaise = (amount * 100).toInt();
  //
  //     SharedPreferences sh = await SharedPreferences.getInstance();
  //     sh.setString('s_amount', amount.toString()); // Store amount in rupees for backend
  //     sh.setString('spid', id_[index]);
  //     String lid=sh.getString('lid').toString();
  //     // sh.setString('lid', did_[index]);
  //
  //     _openCheckout(amountInPaise); // Custom amount
  //   }
  // }
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

  Future<void> _handleCustomPaymentSuccess(PaymentSuccessResponse response) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String spid = sh.getString('sbid') ?? '';
      String lid = sh.getString('lid') ?? '';
      String amnt = sh.getString('s_amount') ?? '0';

      final Uri uri = Uri.parse('$urls/pay_spotbooking/');
      var res = await http.post(uri, body: {
        'id': spid,
        'lid': lid,
        's_amount': amnt,
      });

      var jsonResponse = json.decode(res.body);

      if (jsonResponse['status'] == 'ok') {
        Fluttertoast.showToast(msg: 'Custom Payment Successful');
        getdata();
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


  // void _openCheckout(int amountInPaise) {
  //   var options = {
  //     'key': 'rzp_test_HKCAwYtLt0rwQe',
  //     'amount': amountInPaise,
  //     'name': 'Cab Booking Payment',
  //     'description': 'Payment for pre-booked cab',
  //     'prefill': {'contact': '9747360170', 'email': 'tlikhil@gmail.com'},
  //     'external': {'wallets': ['paytm']},
  //   };
  //
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint('Error: ${e.toString()}');
  //   }
  // }
  //
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String spid = sh.getString('sbid').toString();
      // String samount=sh.getString('s_amount').toString();
      // String lid=sh.getString('lid').toString();


      final Uri uri = Uri.parse('$urls/pay_booking/');
      var response = await http.post(uri, body: {'id': spid,});
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'ok') {
        Fluttertoast.showToast(msg: 'Payment Successful');
        getdata();
      } else {
        Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
    }
    print("Payment Successful: ${response.paymentId}");
  }

  // Future<void> _handleCustomPaymentSuccess(PaymentSuccessResponse response) async {
  //   try {
  //     SharedPreferences sh = await SharedPreferences.getInstance();
  //     String urls = sh.getString('url').toString();
  //     String spid = sh.getString('sbid') ?? '';
  //     String lid = sh.getString('lid').toString();
  //     String amnt = sh.getString('s_amount') ?? '0'; // amount in rupees as string
  //
  //     final Uri uri = Uri.parse('$urls/pay_spotbooking/');
  //     var res = await http.post(uri, body: {
  //       'id': spid,
  //       'lid': lid,
  //       's_amount': amnt,
  //     });
  //
  //     var jsonResponse = json.decode(res.body);
  //
  //     if (jsonResponse['status'] == 'ok') {
  //       Fluttertoast.showToast(msg: 'Custom Payment Successful');
  //       getdata();
  //     } else {
  //       Fluttertoast.showToast(msg: 'Error: ${jsonResponse['message']}');
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Network Error: ${e.toString()}');
  //   }
  //   print("Custom Payment Successful: ${response.paymentId}");
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   print("Error in Payment: ${response.code} - ${response.message}");
  //   Fluttertoast.showToast(msg: 'Payment Failed: ${response.message}');
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   print("External Wallet: ${response.walletName}");
  // }

  // Future<void> _cancelBooking(String bookingId) async {
  //   try {
  //     SharedPreferences sh = await SharedPreferences.getInstance();
  //     String url = sh.getString('url').toString();
  //
  //     final Uri uri = Uri.parse('$url/u_cancel_booking/');
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
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: id_.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: id_.length,
        itemBuilder: (context, index) {
          Color statusColor = _getStatusColor(status_[index]);
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Booking",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A47A3),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          status_[index],
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  buildRow(Icons.person, "Driver", driver_[index],
                      Colors.deepPurple),
                  const SizedBox(height: 12),
                  buildRow(Icons.location_city, "Location", location_[index],
                      Colors.deepPurple),
                  // buildRow(
                  //   Icons.attach_money,
                  //   "Amount",
                  //   status_[index] == "Completed" ? p_amount_[index] : amount_[index],
                  //   Colors.green,
                  // ),
                  if (status_[index] !="Completed")...{
                    buildRow(Icons.attach_money, "Amount", p_amount_[index],
                        Colors.green),
                  }
                else...{
                  buildRow(Icons.attach_money, "Amount", amount_[index],
                  Colors.green),
                  },




                  buildRow(Icons.calendar_today, "Date", date_[index],
                      Colors.blue),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.qr_code,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary),
                          const SizedBox(width: 8),
                          Text(
                            "QR Code",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Booking QR Code",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Image.network(qr_[index]),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Close",
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.grey[100],
                            child: Image.network(
                              qr_[index],
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  buildRow(Icons.info_outline, "Status", status_[index],
                      _getStatusColor(status_[index])),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (status_[index] != "Cancelled" &&
                          status_[index] != "Rejected" && status_[index]!="Completed")
                        _buildActionButton(
                          context,
                          "Cancel",
                          Icons.cancel,
                          Colors.red,
                              () async {
                            await _cancelBooking(id_[index]);
                          },
                        ),
                      if (["paid", "verified", "Accepted","Completed"]
                          .contains(status_[index]))
                        _buildActionButton(
                          context,
                          "Driver",
                          Icons.person,
                          const Color(0xFF6C63FF),
                              () async {
                            SharedPreferences sh =
                            await SharedPreferences.getInstance();
                            sh.setString('did', did_[index]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    user_drv_view_profile(
                                        title: 'Driver Details'),
                              ),
                            );
                          },
                        ),
                      ...[
                        if (status_[index] == "Accepted" )
                          ActionButton(
                            text: "Pay ₹20",
                            icon: Icons.payment,
                            color: Colors.purple,
                            onPressed: () async {
                              SharedPreferences sh = await SharedPreferences.getInstance();
                              sh.setString('sbid', id_[index]);
                              await _addRazorpayListeners("Accepted", index);
                            },
                          ),
                        if (status_[index] == "paid" || status_[index] == "verified")
                          ActionButton(
                            text: "Pay Custom",
                            icon: Icons.payment,
                            color: Colors.green,
                            onPressed: () async {
                              SharedPreferences sh = await SharedPreferences.getInstance();
                              sh.setString('sbid', id_[index]);
                              sh.setString('pamount', p_amount_[index]);

                              try {
                                Position position = await _getCurrentLocation();
                                double currentLat = position.latitude;
                                double currentLong = position.longitude;
                                double destLat = double.parse(latitude_[index]);
                                double destLong = double.parse(longitude_[index]);

                                double distance = _calculateDistance(currentLat, currentLong, destLat, destLong);
                                print("Distance: $distance");

                                double ratePerKm = double.parse(p_amount_[index]);
                                double amount = (distance * ratePerKm)-20;
                                int amountInPaise = (amount * 100).round();

                                print("Custom Amount (₹): $amount");
                                print("Custom Amount (paise): $amountInPaise");

                                sh.setString('s_amount', amount.toStringAsFixed(2));
                                Fluttertoast.showToast(msg: "Distance: ${distance.toStringAsFixed(2)} km, Amount: ₹${amount.toStringAsFixed(2)}");

                                await _addRazorpayListeners("paid", index, amountInPaise);
                              } catch (e) {
                                Fluttertoast.showToast(msg: "Location error: ${e.toString()}");
                              }
                            },
                          ),

                        // ActionButton(
                          //   text: "Pay Custom",
                          //   icon: Icons.payment,
                          //   color: Colors.green,
                          //   onPressed: () async {
                          //     SharedPreferences sh = await SharedPreferences.getInstance();
                          //     sh.setString('sbid', id_[index]);
                          //     sh.setString('pamount', p_amount_[index]);
                          //
                          //     try {
                          //       Position position = await _getCurrentLocation();
                          //       double currentLat = position.latitude;
                          //       double currentLong = position.longitude;
                          //       double destLat = double.parse(latitude_[index]);
                          //       double destLong = double.parse(longitude_[index]);
                          //       // double an=sh.getString("pamount").toString();
                          //
                          //       double distance = _calculateDistance(currentLat, currentLong, destLat, destLong);
                          //       print("bbbbbbbbbbbbbbbbbbbbb");
                          //       print(distance);
                          //       print("bbbbbbbbbbbbbbbbbbbbb");
                          //
                          //       double ratePerKm = double.parse(p_amount_[index]);
                          //       // double ratePerKm = 10;
                          //       double amount = distance * ratePerKm;
                          //       int amountInPaise = (amount * 100).round();
                          //       print(amountInPaise);
                          //
                          //       sh.setString('s_amount', amount.toStringAsFixed(2));
                          //       Fluttertoast.showToast(msg: "Distance: ${distance.toStringAsFixed(2)} km, Amount: ₹${amount.toStringAsFixed(2)}");
                          //
                          //       await _addRazorpayListeners("paid", index);
                          //     } catch (e) {
                          //       Fluttertoast.showToast(msg: "Location error: ${e.toString()}");
                          //     }
                          //   },
                          // ),
                      ],

                      if (status_[index] == "paid"||status_[index]=="Completed")
                        _buildActionButton(
                          context,
                          "Complaint",
                          Icons.report,
                          Colors.orange,
                              () async {
                            SharedPreferences sh =
                            await SharedPreferences.getInstance();
                            sh.setString('did', did_[index]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    send_complaints_against_driver(
                                        title: 'Complaints'),
                              ),
                            );
                          },
                        ),
                      if (["paid", "verified"]
                          .contains(status_[index]))
                        _buildActionButton(
                          context,
                          "Locate",
                          Icons.location_on,
                          Colors.blue,
                              () async {
                            final Uri mapUrl = Uri.parse(
                                "https://maps.google.com/?q=${lat_[index]},${long_[index]}");
                            if (!await launchUrl(mapUrl)) {
                              throw Exception('Could not launch map');
                            }
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'verified':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget buildRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String text, IconData icon,
      Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(text),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Future<void> _cancelBooking(String bookingId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Cancellation"),
        content: const Text("Are you sure you want to cancel this booking?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        SharedPreferences sh = await SharedPreferences.getInstance();
        String url = sh.getString('url').toString();
        final Uri uri = Uri.parse('$url/u_cancel_booking/');
        var response = await http.post(uri, body: {'id': bookingId});
        var jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: 'Booking Canceled Successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          getdata();
        } else {
          Fluttertoast.showToast(
            msg: 'Error: ${jsonResponse['message']}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Network Error: ${e.toString()}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  List id_ = [],
      driver_ = [],
      date_ = [],
      amount_ = [],
     location_=[],
      qr_ = [],
      status_ = [],
      did_ = [],
      bookingid_ = [],
      lat_ = [],
      long_ = [],
      p_amount_=[],
      latitude_=[],
      longitude_=[];

  getdata() async {
    List id = [],
        driver = [],
        date = [],
        amount = [],
        qr = [],
        pstatus = [],
        location=[],
        did = [],
        bookingid = [],
        lat = [],
        long = [],
         p_amount=[],
         latitude=[],
         longitude=[];
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String img = sh.getString('img_url').toString();
      String url = '$urls/u_view_spot_booking/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        did.add(arr[i]['did'].toString());
        driver.add(arr[i]['driver'].toString());
        date.add(arr[i]['date'].toString());
        amount.add(arr[i]['amount'].toString());
        location.add(arr[i]['location'].toString());
        qr.add(img + arr[i]['qr'].toString());
        pstatus.add(arr[i]['status'].toString());
        lat.add(arr[i]['lat'].toString());
        long.add(arr[i]['long'].toString());
        bookingid.add(arr[i]['booking_id'].toString());
        p_amount.add(arr[i]['p_amount'].toString());
        latitude.add(arr[i]['latitude'].toString());
        longitude.add(arr[i]['longitude'].toString());
      }

      setState(() {
        id_ = id;
        did_ = did;
        driver_ = driver;
        date_ = date;
        amount_ = amount;
        location_=location;
        qr_ = qr;
        lat_ = lat;
        long_ = long;
        status_ = pstatus;
        bookingid_ = bookingid;
        p_amount_=p_amount;
        latitude_=latitude;
        longitude_=longitude;
      });
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // KM
    double dLat = _deg2rad(lat2 - lat1);
    double dLon = _deg2rad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    print(distance);
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");


    return distance;
  }

  double _deg2rad(double deg) {
    return deg * (pi / 180);
  }

}