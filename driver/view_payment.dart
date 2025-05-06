// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
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
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const view_payment(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class view_payment extends StatefulWidget {
//   const view_payment({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<view_payment> createState() => _view_paymentState();
// }
//
// class _view_paymentState extends State<view_payment> {
// _view_paymentState(){
//   getdata();
// }
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
//       body: ListView.builder(
//         itemCount: id_.length,
//         itemBuilder: (context, index) {
//           return Card(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("date"),
//                       Text(date_[index]),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("amount"),
//                       Text(amount_[index]),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("user"),
//                       Text(user_[index]),
//                     ],
//                   ),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //     children: [
//                 //       Text("bookingtype"),
//                 //       Text(bookingtype_[index]),
//                 //     ],
//                 //   ),
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("status"),
//                       Text(status_[index]),
//                     ],
//                   ),
//                 ), Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Type"),
//                       Text(type_[index]),
//                     ],
//                   ),
//                 ),Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Booking_Date"),
//                       Text(booking_date_[index]),
//                     ],
//                   ),
//                 ),
//
//               ],
//             ),
//           );
//         },)
//
//     );
//   }
//   List id_=[],date_=[],amount_=[],booking_date_=[],status_=[],user_=[],type_=[];
//   getdata() async {
//     List id=[],date=[],amount=[],booking_date=[],status=[],user=[],type=[];
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/d_view_payment/';
//
//       var data = await http.post(Uri.parse(url), body: {
//
//         'lid':lid
//
//       });
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//
//       var arr = jsondata["data"];
//
//       print(arr.length);
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         date.add(arr[i]['date'].toString());
//         amount.add(arr[i]['amount'].toString());
//         type.add(arr[i]['Type'].toString());
//         user.add(arr[i]['user'].toString());
//         booking_date.add(arr[i]['Booking_date'].toString());
//         status.add(arr[i]['Status'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         date_ = date;
//         amount_ = amount;
//         booking_date_ = booking_date;
//         type_=type;
//         user_ = user;
//         status_=status;
//       });
//
//       print(statuss);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//       //there is error during converting file image to base64 encoding.
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
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
      title: 'Payment History',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade800,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const view_payment(title: 'Payment History'),
    );
  }
}

class view_payment extends StatefulWidget {
  const view_payment({super.key, required this.title});

  final String title;

  @override
  State<view_payment> createState() => _view_paymentState();
}

class _view_paymentState extends State<view_payment> {
  _view_paymentState() {
    getdata();
  }

  List id_ = [], date_ = [], amount_ = [], booking_date_ = [], status_ = [], user_ = [], type_ = [];
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : id_.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.payment_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No payments available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have not made any payments yet',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isLoading = true;
          });
          await getdata();
        },
        child: ListView.builder(
          itemCount: id_.length,
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _buildPaymentCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildPaymentCard(int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date_[index],
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
            const SizedBox(height: 16),
            _buildDetailRow('Amount', '₹${amount_[index]}', isAmount: true),
            _buildDetailRow('User', user_[index]),
            _buildDetailRow('Type', type_[index]),
            _buildDetailRow('Booking Date', booking_date_[index]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isAmount ? Colors.green.shade700 : Colors.blue.shade800,
              fontWeight: isAmount ? FontWeight.bold : FontWeight.normal,
              fontSize: isAmount ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  getdata() async {
    List id = [], date = [], amount = [], booking_date = [], status = [], user = [], type = [];
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/d_view_payment/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date'].toString());
        amount.add(arr[i]['amount'].toString());
        type.add(arr[i]['Type'].toString());
        user.add(arr[i]['user'].toString());
        booking_date.add(arr[i]['Booking_date'].toString());
        status.add(arr[i]['Status'].toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        amount_ = amount;
        booking_date_ = booking_date;
        type_ = type;
        user_ = user;
        status_ = status;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error ------------------- " + e.toString());
    }
  }
}