//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
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
//       home: const ViewAlert(title: 'Alerts'),
//     );
//   }
// }
//
// class ViewAlert extends StatefulWidget {
//   const ViewAlert({super.key, required this.title});
//   final String title;
//
//   @override
//   State<ViewAlert> createState() => _ViewAlertState();
// }
//
// class _ViewAlertState extends State<ViewAlert> {
//   List id_ = [], date_ = [], time_ = [], title_ = [], description_ = [], image_ = [];
//   String imgUrl = "";
//
//   _ViewAlertState() {
//     getAlertData();
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
//             child: Column(
//               children: [
//                 image_[index].isNotEmpty
//                     ? Image.network(
//                   imgUrl + image_[index],
//                   height: 100,
//                   width: 100,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Icon(Icons.broken_image, size: 100, color: Colors.grey);
//                   },
//                 )
//                     : Container(),
//                 _buildRow("Date", date_[index]),
//                 _buildRow("Title", title_[index]),
//                 _buildRow("Descriptions", description_[index]),
//                 _buildRow("Time", time_[index]),
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
//   getAlertData() async {
//     List id = [], date = [], time = [], title = [], description = [], image = [];
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       imgUrl = sh.getString('img_url').toString();
//       if (!imgUrl.endsWith('/')) {
//         imgUrl += '/';
//       }
//       String url = '$urls/d_alert/';
//
//       var data = await http.post(Uri.parse(url), body: {'lid': lid});
//       var jsondata = json.decode(data.body);
//       var arr = jsondata["data"];
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         date.add(arr[i]['Date'].toString());
//         time.add(arr[i]['Time'].toString());
//         title.add(arr[i]['Title'].toString());
//         description.add(arr[i]['Descriptions'].toString());
//         image.add(arr[i]['Image'].toString());
//       }
//
//       setState(() {
//         id_ = id;
//         date_ = date;
//         time_ = time;
//         title_ = title;
//         description_ = description;
//         image_ = image;
//       });
//     } catch (e) {
//       print("Error: \${e.toString()}");
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
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
      title: 'Flutter Alerts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ViewAlert(title: 'Alerts'),
    );
  }
}

class ViewAlert extends StatefulWidget {
  const ViewAlert({super.key, required this.title});
  final String title;

  @override
  State<ViewAlert> createState() => _ViewAlertState();
}

class _ViewAlertState extends State<ViewAlert> {
  List id_ = [], date_ = [], time_ = [], title_ = [], description_ = [], image_ = [];
  String imgUrl = "";
  bool _isLoading = true;

  _ViewAlertState() {
    getAlertData();
  }

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
              'No alerts available',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'You have not received any alerts yet',
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
          await getAlertData();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: id_.length,
          itemBuilder: (context, index) {
            return _buildAlertCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildAlertCard(int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image_[index].isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imgUrl + image_[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 150, color: Colors.grey);
                    },
                  ),
                ),
              ),
            const SizedBox(height: 12),
            _buildSection('Date', date_[index]),
            const SizedBox(height: 8),
            _buildSection('Title', title_[index]),
            const SizedBox(height: 8),
            _buildSection('Description', description_[index]),
            const SizedBox(height: 8),
            _buildSection('Time', time_[index]),
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
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Future<void> getAlertData() async {
    List id = [], date = [], time = [], title = [], description = [], image = [];
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      imgUrl = sh.getString('img_url').toString();
      if (!imgUrl.endsWith('/')) {
        imgUrl += '/';
      }
      String url = '$urls/d_alert/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['Date'].toString());
        time.add(arr[i]['Time'].toString());
        title.add(arr[i]['Title'].toString());
        description.add(arr[i]['Descriptions'].toString());
        image.add(arr[i]['Image'].toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        time_ = time;
        title_ = title;
        description_ = description;
        image_ = image;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: ${e.toString()}");
    }
  }
}