// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:public_transportation/driver/send_complaints.dart';
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
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const view_emergency_number(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class view_emergency_number extends StatefulWidget {
//   const view_emergency_number({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<view_emergency_number> createState() => _view_emergency_numberState();
// }
//
// class _view_emergency_numberState extends State<view_emergency_number> {
//   _view_emergency_numberState() {
//     getdata();
//   }
//
//   List id_ = [], date_ = [], reply_ = [], status_ = [], complaint_ = [];
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
//         padding: const EdgeInsets.all(12),
//         itemBuilder: (context, index) {
//           return Card(
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   buildRow("Date", date_[index]),
//                   buildRow("Reply", reply_[index]),
//                   buildRow("Status", status_[index]),
//                   buildRow("Complaint", complaint_[index]),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget buildRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "$label: ",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   getdata() async {
//     List id = [], date = [], reply = [], status = [], complaint = [];
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/d_view_emergency_number/';
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
//         date.add(arr[i]['Date'].toString());
//         reply.add(arr[i]['Reply'].toString());
//         status.add(arr[i]['Status'].toString());
//         complaint.add(arr[i]['Complaint'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         date_ = date;
//         reply_ = reply;
//         status_ = status;
//         complaint_ = complaint;
//       });
//
//       print(statuss);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:public_transportation/driver/send_complaints.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complaint Replies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade800,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const view_emergency_number(title: 'Complaint Replies'),
    );
  }
}

class view_emergency_number extends StatefulWidget {
  const view_emergency_number({super.key, required this.title});

  final String title;

  @override
  State<view_emergency_number> createState() => _view_emergency_numberState();
}

class _view_emergency_numberState extends State<view_emergency_number> {
  _view_emergency_numberState() {
    getdata();
  }

  List id_ = [], emergency_no_=[],district_=[];
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
              Icons.inbox_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No numbers',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '',
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
            return _buildReplyCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildReplyCard(int index) {
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
                // // Text(
                // //   emergency_no_[index],
                // //   style: TextStyle(
                // //     color: Colors.grey.shade700,
                // //     fontWeight: FontWeight.w500,
                // //   ),
                // // ),
                // // Container(
                // //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                // //   decoration: BoxDecoration(
                // //     color: _getStatusColor(district_[index]),
                // //     borderRadius: BorderRadius.circular(12),
                // //   ),
                // //   child: Text(
                // //     district_[index],
                // //     style: const TextStyle(
                // //       color: Colors.white,
                // //       fontSize: 12,
                // //     ),
                // //   ),
                // ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSection('Emergency_no', emergency_no_[index]),
            const SizedBox(height: 16),
            _buildSection(' District', district_[index], isReply: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, {bool isReply = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isReply ? Colors.green.shade700 : Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> getdata() async {
    List id = [], emergency_no=[],district=[];
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/d_view_emergency_no/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        emergency_no.add(arr[i]['emergency_no'].toString());
        district.add(arr[i]['district'].toString());

      }

      setState(() {
        id_ = id;
        emergency_no_=emergency_no;
        district_=district;
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