// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:public_transportation/user/userhome.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
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
//       home: const pre_booking(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class pre_booking extends StatefulWidget {
//   const pre_booking({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<pre_booking> createState() => _pre_bookingState();
// }
//
// class _pre_bookingState extends State<pre_booking> {
//   TextEditingController Date_controller = new TextEditingController();
//   TextEditingController Time_controller = new TextEditingController();
//   TextEditingController Location_Controller = new TextEditingController();
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
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: TextField(
//                controller:Date_controller,
//                decoration: InputDecoration(border:OutlineInputBorder(),label: Text("Date")) ),
//            ), Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: TextField(
//                controller:Time_controller,
//                decoration: InputDecoration(border:OutlineInputBorder(),label: Text("Time")) ),
//            ), Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: TextField(
//                controller:Location_Controller,
//                decoration: InputDecoration(border:OutlineInputBorder(),label: Text("Location")) ),
//            ),
//             ElevatedButton(onPressed: (){
//               sendata();
//             }, child: Text('Send'))
//
//           ],
//         ),
//       ),
//
//     );
//   }
//   sendata() async {
//     String date=Date_controller.text;
//     String time=Time_controller.text;
//     String location=Location_Controller.text;
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//
//     final urls = Uri.parse('$url/u_pre_book_cabs/');
//     try {
//       final response = await http.post(urls, body: {
//         'date':date,
//         'time':time,
//         'location':location,
//         'lid':lid,
//
//
//
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status=='ok') {
//           Navigator.push(context, MaterialPageRoute(
//             builder: (context) => UserHome(title: "Home"),));
//           Fluttertoast.showToast(msg: 'Booked Successfully');
//         }else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       }
//       else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     }
//     catch (e){
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_transportation/user/userhome.dart';
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
      title: 'Pre Booking',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const pre_booking(title: 'Pre Book a Ride'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class pre_booking extends StatefulWidget {
  const pre_booking({super.key, required this.title});
  final String title;

  @override
  State<pre_booking> createState() => _pre_bookingState();
}

class _pre_bookingState extends State<pre_booking> {
  TextEditingController Date_controller = TextEditingController();
  TextEditingController Time_controller = TextEditingController();
  TextEditingController Latitude_Controller = TextEditingController();
  TextEditingController Longitude_Controller = TextEditingController();
  TextEditingController Pickup_Latitude_Controller = TextEditingController();
  TextEditingController Pickup_Longitude_Controller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        Date_controller.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        Time_controller.text = pickedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              buildDateTimeField(
                controller: Date_controller,
                label: "Select Date",
                icon: Icons.calendar_today,
                onTap: () => _selectDate(context),
              ),
              buildDateTimeField(
                controller: Time_controller,
                label: "Select Time",
                icon: Icons.access_time,
                onTap: () => _selectTime(context),
              ),
              buildTextField("Destination Latitude", Latitude_Controller, Icons.my_location),
              buildTextField("Destination Longitude", Longitude_Controller, Icons.my_location_outlined),
              buildTextField("Pickup Latitude", Pickup_Latitude_Controller, Icons.location_on),
              buildTextField("Pickup Longitude", Pickup_Longitude_Controller, Icons.location_on_outlined),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  sendata();
                },
                icon: const Icon(Icons.send),
                label: const Text('Book'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Color(0xFF1A1A1A), // Almost black
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          labelText: label,
        ),
      ),
    );
  }

  Widget buildDateTimeField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          labelText: label,
        ),
      ),
    );
  }

  sendata() async {
    String date = Date_controller.text;
    String time = Time_controller.text;
    String latitude = Latitude_Controller.text;
    String longitude = Longitude_Controller.text;
    String pickup_latitude = Pickup_Latitude_Controller.text;
    String pickup_longitude = Pickup_Longitude_Controller.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String did = sh.getString('did').toString();

    final urls = Uri.parse('$url/u_pre_book_cabs/');
    try {
      final response = await http.post(urls, body: {
        'date': date,
        'time': time,
        'latitude': latitude,
        'longitude': longitude,
        'pickup_latitude': pickup_latitude,
        'pickup_longitude': pickup_longitude,
        'lid': lid,
        'did': did,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserHome(title: "Home")),
          );
          Fluttertoast.showToast(msg: 'Booked Successfully');
        }
        else if(status == 'exi'){
          Fluttertoast.showToast(msg: 'Booking Already Exist In');

        }
        else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
