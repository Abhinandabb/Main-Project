
import 'dart:async';
import 'dart:convert';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:public_transportation/driver/change_password.dart';
import 'package:public_transportation/driver/logout.dart';
import 'package:public_transportation/driver/send_complaints.dart';
import 'package:public_transportation/driver/send_complaints_against_user.dart';
import 'package:public_transportation/driver/send_review.dart';
import 'package:public_transportation/driver/spotqr.dart';
import 'package:public_transportation/driver/update_profile.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:public_transportation/driver/view_alert.dart';
import 'package:public_transportation/driver/view_complaints_against_drv.dart';
import 'package:public_transportation/driver/view_emergency_no.dart';
import 'package:public_transportation/driver/view_payment.dart';
import 'package:public_transportation/driver/view_pre_booking.dart';
import 'package:public_transportation/driver/view_profile.dart';
import 'package:public_transportation/driver/view_reply.dart';
import 'package:public_transportation/driver/view_reply_against_user.dart';
import 'package:public_transportation/driver/view_spot_booking.dart';
import 'package:public_transportation/driver/view_spot_payment.dart';
import 'package:public_transportation/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cabzy Driver',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          elevation: 4,
        ),
      ),
      home: const DriverHome(title: 'Cabzy - Driver Dashboard'),
    );
  }
}

class DriverHome extends StatefulWidget {
  const DriverHome({super.key, required this.title});

  final String title;

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  static const platform = MethodChannel('com.example.volumeButton');

  Timer? _timer;
  String name = "";
  String photo = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler((call) async {
      if (call.method == 'volumeButtonPressed') {
        print("pressed");
        sendSmsInBackground();

      }
    });    v();
    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      getdata();
    });
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      updateloc();
    });
  }

  v() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String img_url = sh.getString('img_url').toString();

    final urls = Uri.parse('$url/d_view_profile/');
    try {
      final response = await http.post(urls, body: {
        'lid': lid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          setState(() {
            name = jsonDecode(response.body)['name'].toString();
            photo = img_url + jsonDecode(response.body)['photo'].toString();
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

  void callbackDispatcher(String message) {
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var settings = InitializationSettings(android: android);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip, message);
  }

  Future _showNotificationWithDefaultSound(flip, String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);

    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flip.show(
        0,
        'REMINDER',
        message,
        platformChannelSpecifics,
        payload: 'Default_Sound');
  }

  Future<void> getdata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    try {
      String url = sh.getString('url').toString();

      final urls = Uri.parse('$url/d_view_notification/');

      String nid = "0";
      if (sh.containsKey("nid") == false) {
      } else {
        nid = sh.getString('nid').toString();
      }

      var datas = await http.post(urls, body: {'nid': nid, 'lid': sh.getString("lid")});
      var jsondata = json.decode(datas.body);
      String status = jsondata['status'];
      print(status);
      if (status == "ok") {
        String nid = jsondata['nid'];
        String message = jsondata['message'];
        sh.setString('nid', nid);
        callbackDispatcher(message);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print("Error ------------------- " + e.toString());
    }
  }
  String dis="";
  String lat_="";
  String lon_="";

  Future<void> _getLocationDetails(double latitude, double longitude) async {
    try {
      // Fetch the list of placemarks (addresses) from the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      // You can print or display various details like:
      Placemark place = placemarks[0];
      String details = '''
      Name: ${place.name}
      Street: ${place.street}
      SubLocality: ${place.subLocality}
      City: ${place.locality}
      State: ${place.administrativeArea}
      Country: ${place.country}
      Postal Code: ${place.postalCode}
      ''';
      setState(() {
        dis=place.locality.toString();
      });


    } catch (e) {

    }
  }
  String nu_="";
  updateloc() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    String lat = position.latitude.toString();
    String lon = position.longitude.toString();

    _getLocationDetails(double.parse(lat),double.parse(lon));


    final urls = Uri.parse('$url/updateloc/');
    try {
      final response = await http.post(urls, body: {
        'latitude': lat,
        'longitude': lon,
        'dis':dis,
        'lid': lid,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          String nu = jsonDecode(response.body)['num'].toString();
          setState(() {
            nu_=nu;
            lat_=lat;
            lon_=lon;
          });
          print(nu_);
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  Future<void> sendSmsInBackground() async {
    await BackgroundSms.sendMessage(
      phoneNumber: nu_, // Recipient phone number
      message: "Alert Criminal Detected\nhttps://maps.google.com/?q=${lat_},${lon_}", // Message to send
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cabzy Driver', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        )),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.notifications, color: Colors.white),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ViewAlert(title: 'View Alerts'),
          //       ),
          //     );
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            SizedBox(height: 20),
            _buildQuickActions(),
            SizedBox(height: 20),
            _buildAlertsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScanner()),
          );
        },
        child: Icon(Icons.qr_code_scanner, size: 28, color: Colors.white),
        backgroundColor: Colors.deepPurple,
        tooltip: 'Scan QR Code',
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple[100]!, Colors.deepPurple[50]!],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(photo),
                backgroundColor: Colors.white,
                radius: 30,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            _buildDrawerItem(Icons.home, "Home", () => Navigator.pop(context)),
            _buildDrawerItem(Icons.lock, "Change Password", () => _navigateTo(changepassword(title: 'Password'))),
            _buildDrawerItem(Icons.person, "Profile", () => _navigateTo(view_profile(title: 'View_Profile'))),
            _buildDrawerItem(Icons.directions_car, "Spot Bookings", () => _navigateTo(view_spot_bookings(title: 'View_Spot_Bookings'))),
            _buildDrawerItem(Icons.calendar_today, "Pre Bookings", () => _navigateTo(view_pre_bookings(title: 'View_Pre_Bookings'))),
            _buildDrawerItem(Icons.report, "Send Complaints", () => _navigateTo(send_complaints(title: 'Send_complaints'))),
            _buildDrawerItem(Icons.email, "View Reply", () => _navigateTo(view_reply(title: 'view_reply'))),
            _buildDrawerItem(Icons.email, "View Reply User Cmp", () => _navigateTo(ViewReplyAgainstUser(title: 'View_reply_User_Cmp'))),
            _buildDrawerItem(Icons.report_problem, "View Complaints", () => _navigateTo(view_cmp_against_drivers(title: 'View_Cmp_Against_Drivers'))),
            _buildDrawerItem(Icons.feedback, "Send Review", () => _navigateTo(send_review(title: 'Send_Review'))),
            _buildDrawerItem(Icons.dangerous, "View Emergency", () => _navigateTo(view_emergency_number(title: 'Emergency_No'))),
            _buildDrawerItem(Icons.payment, "View Pre Payment", () => _navigateTo(view_payment(title: 'View Pre Payment'))),
            _buildDrawerItem(Icons.payment, "View Spot Payment", () => _navigateTo(view_spot_payment(title: 'View Spot Payment'))),
            Divider(color: Colors.deepPurple[200]),
            // _buildDrawerItem(Icons.exit_to_app, "Logout", () => _navigateTo(login(title: 'Login'))),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title, style: TextStyle(color: Colors.deepPurple[800], fontSize: 16)),
      onTap: onTap,
      hoverColor: Colors.deepPurple[100],
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Ready to accept new rides?',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
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

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[800],
          ),
        ),
        SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.3,
          children: [
            _buildActionButton(Icons.directions_car, 'Spot Bookings', Colors.blue, () {
              _navigateTo(view_spot_bookings(title: 'View_Spot_Bookings'));
            }),
            _buildActionButton(Icons.calendar_today, 'Pre Bookings', Colors.green, () {
              _navigateTo(view_pre_bookings(title: 'View_Pre_Bookings'));
            }),
            _buildActionButton(Icons.report, 'Complaints', Colors.orange, () {
              _navigateTo(send_complaints(title: 'Send_complaints'));
            }),
            _buildActionButton(Icons.feedback, 'Reviews', Colors.purple, () {
              _navigateTo(send_review(title: 'Send_Review'));
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: color),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.deepPurple[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alerts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[800],
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewAlert(title: 'View Alerts'),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.notifications_active, size: 30, color: Colors.deepPurple),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'View All Alerts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => login(title: 'Login')),
    );
  }
}