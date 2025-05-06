// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:public_transportation/login.dart';
// import 'package:public_transportation/user/change_password.dart';
// import 'package:public_transportation/user/cmp_drv_reply.dart';
// import 'package:public_transportation/user/logout.dart';
// import 'package:public_transportation/user/send_complaints.dart';
// import 'package:public_transportation/user/send_complaints_against_driv.dart';
// import 'package:public_transportation/user/send_feedback.dart';
// import 'package:public_transportation/user/update_profile.dart';
// import 'package:public_transportation/user/view_cabs.dart';
// import 'package:public_transportation/user/view_driver_details.dart';
// import 'package:public_transportation/user/view_pre_booking.dart';
// import 'package:public_transportation/user/view_profile.dart';
// import 'package:public_transportation/user/view_reply.dart';
// import 'package:public_transportation/user/view_spot_booking.dart';
// import 'package:shared_preferences/shared_preferences.dart';
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
//       home: const UserHome(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// void callbackDispatcher(String message) {
//   print("hiii");
//
//   // Workmanager().executeTask((task, inputData) {
//   // initialise the plugin of flutterlocalnotifications.
//   FlutterLocalNotificationsPlugin flip =
//   new FlutterLocalNotificationsPlugin();
//
//   // app_icon needs to be a added as a drawable
//   // resource to the Android head project.
//   var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
//   // var IOS = new IOSInitializationSettings();
//
//   // initialise settings for both Android and iOS device.
//   var settings = new InitializationSettings(android: android);
//   flip.initialize(settings);
//   _showNotificationWithDefaultSound(flip, message);
//   // return Future.value(true);
//   // });
// }
//
// Future _showNotificationWithDefaultSound(flip,String message) async {
// // Show a notification after every 15 minute with the first
// // appearance happening a minute after invoking the method
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'your channel id', 'your channel name',
//       importance: Importance.max, priority: Priority.high);
//
// // initialise channel platform for both Android and iOS device.
//   var platformChannelSpecifics =
//   new NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flip.show(
//       0,
//       'NOTIFICATION',
//       message,
//       platformChannelSpecifics,
//       payload: 'Default_Sound');
// }
//
// class UserHome extends StatefulWidget {
//   const UserHome({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<UserHome> createState() => _UserHomeState();
// }
//
// class _UserHomeState extends State<UserHome> {
//   _UserHomeState(){
//     view_profile();
//     Timer.periodic(Duration(seconds: 15), (timer) {
//       getdata();
//       getdata2();
//     });
//   }
//
//   String name = "";
//   String email = "";
//   String age = "";
//   String gender = "";
//   String place = "";
//   String pin = "";
//   String post = "";
//   String photo = "";
//   String mobileno = "";
//
//   view_profile() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//     String img_url = sh.getString('img_url').toString();
//
//     final urls = Uri.parse('$url/u_view_profile/');
//     try {
//       final response = await http.post(urls, body: {
//         'lid': lid,
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status == 'ok') {
//           setState(() {
//             name = jsonDecode(response.body)['name'].toString();
//             email = jsonDecode(response.body)['email'].toString();
//             age = jsonDecode(response.body)['age'].toString();
//             gender = jsonDecode(response.body)['gender'].toString();
//             place = jsonDecode(response.body)['place'].toString();
//             pin = jsonDecode(response.body)['pin'].toString();
//             post = jsonDecode(response.body)['post'].toString();
//             photo = img_url + jsonDecode(response.body)['photo'].toString();
//             mobileno = jsonDecode(response.body)['mobile_no'].toString();
//           });
//         } else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//
//
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
//       body: Center(
//
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//
//           ],
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             DrawerHeader(child: Column(
//               children: [
//                 CircleAvatar(backgroundImage: NetworkImage(photo),),
//                 Text(name)
//               ],
//             )),
//             ListTile(
//               title: Text("Home"),
//               onTap: (){
//
//               },
//             ),
//
//             ListTile(
//               title: Text("Change_Password"),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => change_password(title: 'Password',),));
//               },
//             ),
//             ListTile(
//               title: Text("Profile"),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) =>user_profile_page (title: 'Profile',),));
//               },
//             // ),
//             // ListTile(
//             //   title: Text("Update_Profile"),
//             //   onTap: (){
//             //     Navigator.push(context, MaterialPageRoute(builder: (context) => update_profile(title: 'Update_Profile', name: '',),));
//             //   },
//             ),
//             ListTile(
//               title: Text("View_Cabs"),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => view_cabs(title: 'View_Cabs',),));
//               }, ),
//             ListTile(
//               title: Text("View_Spot_Booking"),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => view_spot_booking(title: 'View_Spot_Booking',),));
//               }, ),
//             ListTile(
//               title: Text("View_pre_Booking"),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => view_pre_booking(title: 'View_pre_Booking',),));
//               },
//             ),
//             // ListTile(
//             //   title: Text("View_Driver_Details"),
//             //   onTap: (){
//             //     Navigator.push(context, MaterialPageRoute(builder: (context) => view_driver_details(title: 'View_Driver_Details',),));
//             //   },
//             // ),
//             ListTile(
//               title: Text("Send_Complaints"),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => send_complaints(title: 'Send_Complaints',),));
//               }, ),
//             ListTile(
//               title: Text("View_Reply"),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => view_reply(title: 'View_Reply',),));
//               },
//             ),
//             // ListTile(
//             //   title: Text("Send_Complaints_Driver"),
//             //   onTap: (){
//             //     Navigator.push(context, MaterialPageRoute(builder: (context) => send_complaints_against_driver(title: 'Send_Complaints_Against_Drivers',),));
//             //   },
//             // ),
//             ListTile(
//               title: Text("Send_Feedback"),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => send_feedback(title: 'Send_Feedback',),));
//               },
//             ),
//             ListTile(
//               title: Text("Reply_Against_Cmp_Drv"),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => view_cmp_driver_reply(title: 'Reply_Against_Cmp_Drv',),));
//               },
//             ),
//             ListTile(
//               title: Text("Logout"),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => login(title: 'Login',),));
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//   String Reminer = "", id = "", Date = "", Time = "";
//
//   Future<void> getdata() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     try {
//       // String url = "${sh.getString("url").toString()}/viewNotification/";
//
//
//       String url = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//
//       final urls = Uri.parse('$url/viewNotification/');
//
//       String nid="0";
//       if(sh.containsKey("nnid")==false) {}
//       else{
//         nid=sh.getString('nnid').toString();
//       }
//       Fluttertoast.showToast(msg:nid);
//
//       var datas = await http
//           .post(urls, body: {'nid': nid,'lid':lid });
//       var jsondata = json.decode(datas.body);
//       String status = jsondata['status'];
//       print(status);
//       if (status == "ok") {
//         String nid = jsondata['nid'];
//         String message = jsondata['message'];
//         sh.setString('nnid',nid);
//         callbackDispatcher(message);
//
//
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//       print("Error ------------------- " + e.toString());
//       //there is error during converting file image to base64 encoding.
//     }
//   }
//   Future<void> getdata2() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     try {
//       // String url = "${sh.getString("url").toString()}/viewNotification/";
//
//
//       String url = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//
//       final urls = Uri.parse('$url/p_viewNotification/');
//
//       String nid="0";
//       if(sh.containsKey("nnid1")==false) {}
//       else{
//         nid=sh.getString('nnid1').toString();
//       }
//       Fluttertoast.showToast(msg:nid);
//
//       var datas = await http
//           .post(urls, body: {'nid': nid,'lid':lid });
//       var jsondata = json.decode(datas.body);
//       String status = jsondata['status'];
//       print(status);
//       if (status == "ok") {
//         String nid = jsondata['nid'];
//         String message = jsondata['message'];
//         sh.setString('nnid1',nid);
//         callbackDispatcher(message);
//
//
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//       print("Error ------------------- " + e.toString());
//       //there is error during converting file image to base64 encoding.
//     }
//   }
// }
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:public_transportation/login.dart';
import 'package:public_transportation/user/change_password.dart';
import 'package:public_transportation/user/cmp_drv_reply.dart';
import 'package:public_transportation/user/logout.dart';
import 'package:public_transportation/user/send_complaints.dart';
import 'package:public_transportation/user/send_complaints_against_driv.dart';
import 'package:public_transportation/user/send_feedback.dart';
import 'package:public_transportation/user/update_profile.dart';
import 'package:public_transportation/user/view_cabs.dart';
import 'package:public_transportation/user/view_driver_details.dart';
import 'package:public_transportation/user/view_pre_booking.dart';
import 'package:public_transportation/user/view_profile.dart';
import 'package:public_transportation/user/view_reply.dart';
import 'package:public_transportation/user/view_spot_booking.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cabzy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserHome(title: 'Cabzy - Book Your Ride'),
    );
  }
}

void callbackDispatcher(String message) {
  print("hiii");

  FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

  var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var settings = InitializationSettings(android: android);
  flip.initialize(settings);
  _showNotificationWithDefaultSound(flip, message);
}

Future _showNotificationWithDefaultSound(flip, String message) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.max, priority: Priority.high);

  var platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flip.show(
      0,
      'NOTIFICATION',
      message,
      platformChannelSpecifics,
      payload: 'Default_Sound');
}

class UserHome extends StatefulWidget {
  const UserHome({super.key, required this.title});

  final String title;

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  _UserHomeState() {
    view_profile();
    Timer.periodic(const Duration(seconds: 15), (timer) {
      getdata();
      getdata2();
    });
  }

  String name = "";
  String email = "";
  String age = "";
  String gender = "";
  String place = "";
  String pin = "";
  String post = "";
  String photo = "";
  String mobileno = "";

  view_profile() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String img_url = sh.getString('img_url').toString();

    final urls = Uri.parse('$url/u_view_profile/');
    try {
      final response = await http.post(urls, body: {
        'lid': lid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          setState(() {
            name = jsonDecode(response.body)['name'].toString();
            email = jsonDecode(response.body)['email'].toString();
            age = jsonDecode(response.body)['age'].toString();
            gender = jsonDecode(response.body)['gender'].toString();
            place = jsonDecode(response.body)['place'].toString();
            pin = jsonDecode(response.body)['pin'].toString();
            post = jsonDecode(response.body)['post'].toString();
            photo = img_url + jsonDecode(response.body)['photo'].toString();
            mobileno = jsonDecode(response.body)['mobile_no'].toString();
          });
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  String Reminer = "", id = "", Date = "", Time = "";

  Future<void> getdata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    try {
      String url = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();

      final urls = Uri.parse('$url/viewNotification/');

      String nid = "0";
      if (sh.containsKey("nnid") == false) {} else {
        nid = sh.getString('nnid').toString();
      }
      Fluttertoast.showToast(msg: nid);

      var datas = await http.post(urls, body: {'nid': nid, 'lid': lid});
      var jsondata = json.decode(datas.body);
      String status = jsondata['status'];
      print(status);
      if (status == "ok") {
        String nid = jsondata['nid'];
        String message = jsondata['message'];
        sh.setString('nnid', nid);
        callbackDispatcher(message);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print("Error ------------------- " + e.toString());
    }
  }

  Future<void> getdata2() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    try {
      String url = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();

      final urls = Uri.parse('$url/p_viewNotification/');

      String nid = "0";
      if (sh.containsKey("nnid1") == false) {} else {
        nid = sh.getString('nnid1').toString();
      }
      Fluttertoast.showToast(msg: nid);

      var datas = await http.post(urls, body: {'nid': nid, 'lid': lid});
      var jsondata = json.decode(datas.body);
      String status = jsondata['status'];
      print(status);
      if (status == "ok") {
        String nid = jsondata['nid'];
        String message = jsondata['message'];
        sh.setString('nnid1', nid);
        callbackDispatcher(message);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Cabzy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => login(title: 'Login')),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.deepPurple[50],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                accountEmail: Text(email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(photo),
                  backgroundColor: Colors.white,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
              ),
              _buildDrawerItem(
                icon: Icons.home,
                title: "Home",
                onTap: () => Navigator.pop(context),
              ),
              _buildDrawerItem(
                icon: Icons.lock,
                title: "Change Password",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => change_password(title: 'Password'),
                  ),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.person,
                title: "Profile",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => user_profile_page(title: 'Profile'),
                  ),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.directions_car,
                title: "View Cabs",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => view_cabs(title: 'View_Cabs'),
                  ),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.calendar_today,
                title: "View Spot Booking",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => view_spot_booking(title: 'View_Spot_Booking'),
                  ),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.book_online,
                title: "View Pre Booking",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => view_pre_booking(title: 'View_pre_Booking'),
                  ),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.report,
                title: "Send Complaints",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => send_complaints(title: 'Send_Complaints'),
                  ),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.email,
                title: "View Reply",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => view_reply(title: 'View_Reply'),
                  ),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.feedback,
                title: "Send Feedback",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => send_feedback(title: 'Send_Feedback'),
                  ),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.reply,
                title: "Reply Against Cmp Drv",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => view_cmp_driver_reply(title: 'Reply_Against_Cmp_Drv'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              SizedBox(height: 30),
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 15),
              _buildQuickActionsGrid(),
              SizedBox(height: 30),
              Text(
                'Available Vehicles',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 15),
              _buildVehicleGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title, style: TextStyle(color: Colors.deepPurple[800])),
      onTap: onTap,
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
    child: Row(
    children: [
    CircleAvatar(
    radius: 30,
    backgroundImage: NetworkImage(photo),
    backgroundColor: Colors.white,
    ),
    SizedBox(width: 15),
    Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $name!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Book your ride with just a few taps',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
          ],
        ),
    ),
    ],
    ),
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    List<Map<String, dynamic>> actions = [
      {'icon': Icons.directions_car, 'name': 'Book Now', 'page': view_cabs(title: 'View Cabs')},
      {'icon': Icons.calendar_today, 'name': 'Spot Booking', 'page': view_spot_booking(title: 'Spot Booking')},
      {'icon': Icons.book_online, 'name': 'Pre Booking', 'page': view_pre_booking(title: 'Pre Booking')},
      {'icon': Icons.person, 'name': 'My Profile', 'page': user_profile_page(title: 'Profile')},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.3,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return _buildActionCard(
          icon: actions[index]['icon'],
          name: actions[index]['name'],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => actions[index]['page']),
          ),
        );
      },
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String name,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: Colors.deepPurple),
              ),
              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleGrid() {
    List<Map<String, dynamic>> vehicles = [
      {'icon': Icons.directions_car, 'name': 'Car', 'color': Colors.blue},
      {'icon': Icons.motorcycle, 'name': 'Bike', 'color': Colors.green},
      {'icon': Icons.local_taxi, 'name': 'Taxi', 'color': Colors.orange},
      {'icon': Icons.directions_bus, 'name': 'Auto', 'color': Colors.red},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.2,
      ),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        return _buildVehicleCard(
          icon: vehicles[index]['icon'],
          name: vehicles[index]['name'],
          color: vehicles[index]['color'],
        );
      },
    );
  }

  Widget _buildVehicleCard({
    required IconData icon,
    required String name,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.8), color],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}