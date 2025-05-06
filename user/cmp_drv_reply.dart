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
      title: 'Driver Replies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const view_cmp_driver_reply(title: 'Driver Complaint Replies'),
    );
  }
}

class view_cmp_driver_reply extends StatefulWidget {
  const view_cmp_driver_reply({super.key, required this.title});
  final String title;

  @override
  State<view_cmp_driver_reply> createState() => _view_cmp_driver_replyState();
}

class _view_cmp_driver_replyState extends State<view_cmp_driver_reply> {
  _view_cmp_driver_replyState() {
    getdata();
  }

  List id_ = [], date_ = [], reply_ = [], status_ = [], complaint_ = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: id_.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: id_.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow("📅 Date", date_[index]),
                    const SizedBox(height: 8),
                    _buildRow("🗨️ Complaint", complaint_[index]),
                    const SizedBox(height: 8),
                    _buildRow("💬 Reply", reply_[index]),
                    const SizedBox(height: 8),
                    _buildStatusTag(status_[index]),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(value),
        ),
      ],
    );
  }

  Widget _buildStatusTag(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'replied':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  getdata() async {
    List id = [], date = [], reply = [], status = [], complaint = [];
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/u_view_reply_cmp_dev/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date'].toString());
        reply.add(arr[i]['reply'].toString());
        status.add(arr[i]['status'].toString());
        complaint.add(arr[i]['complaint'].toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        reply_ = reply;
        status_ = status;
        complaint_ = complaint;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }
}
