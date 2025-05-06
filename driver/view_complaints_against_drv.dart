// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
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
//       home: const view_cmp_against_drivers(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class view_cmp_against_drivers extends StatefulWidget {
//   const view_cmp_against_drivers({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<view_cmp_against_drivers> createState() => _view_cmp_against_driversState();
// }
//
// class _view_cmp_against_driversState extends State<view_cmp_against_drivers> {
//   _view_cmp_against_driversState() {
//     getdata();
//   }
//
//   List id_ = [], date_ = [], complaint_ = [], type_ = [], from_ = [], status_ = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: id_.length,
//         itemBuilder: (context, index) {
//           return Card(
//             elevation: 3,
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   buildRow("Date", date_[index]),
//                   buildRow("Complaint", complaint_[index]),
//                   buildRow("Type", type_[index]),
//                   buildRow("From", from_[index]),
//                   // Uncomment if you want to include status
//                   // buildRow("Status", status_[index]),
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
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
//     List id = [], date = [], complaint = [], type = [], from = [], status = [];
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/d_view_cmp_against_driver/';
//
//       var data = await http.post(Uri.parse(url), body: {'lid': lid});
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
//         complaint.add(arr[i]['complaint'].toString());
//         type.add(arr[i]['type'].toString());
//         status.add(arr[i]['status'].toString());
//         from.add(arr[i]['from'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         date_ = date;
//         complaint_ = complaint;
//         type_ = type;
//         status_ = status;
//         from_ = from;
//       });
//
//       print(statuss);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Complaints',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade800,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const view_cmp_against_drivers(title: 'Complaints'),
    );
  }
}

class view_cmp_against_drivers extends StatefulWidget {
  const view_cmp_against_drivers({super.key, required this.title});

  final String title;

  @override
  State<view_cmp_against_drivers> createState() => _view_cmp_against_driversState();
}

class _view_cmp_against_driversState extends State<view_cmp_against_drivers> {
  _view_cmp_against_driversState() {
    getdata();
  }

  List id_ = [], date_ = [], complaint_ = [], type_ = [], from_ = [], status_ = [];
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
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
              'No complaints available',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'There are no complaints against drivers yet',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
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
          padding: const EdgeInsets.all(16),
          itemCount: id_.length,
          itemBuilder: (context, index) {
            return _buildComplaintCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildComplaintCard(int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                //   decoration: BoxDecoration(
                //     color: _getStatusColor(status_[index]),
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Text(
                //     status_[index],
                //     style: const TextStyle(color: Colors.white, fontSize: 12),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSection('Complaint', complaint_[index]),
            const SizedBox(height: 16),
            _buildSection('Type', type_[index]),
            const SizedBox(height: 16),
            _buildSection('From', from_[index]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
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
    List id = [], date = [], complaint = [], type = [], from = [], status = [];
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/d_view_cmp_against_driver/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date'].toString());
        complaint.add(arr[i]['complaint'].toString());
        type.add(arr[i]['type'].toString());
        // status.add(arr[i]['status'].toString());
        from.add(arr[i]['from'].toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        complaint_ = complaint;
        type_ = type;
        status_ = status;
        from_ = from;
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