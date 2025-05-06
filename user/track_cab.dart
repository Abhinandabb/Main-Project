import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CabTracker extends StatefulWidget {
  final String bookingId; // Used to identify which cab to track

  const CabTracker({required this.bookingId, super.key});

  @override
  State<CabTracker> createState() => _CabTrackerState();
}

class _CabTrackerState extends State<CabTracker> {
  GoogleMapController? _mapController;
  LatLng? userLocation;
  LatLng? cabLocation;
  Timer? _timer;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    initNotifications();
    getUserLocation();
    startTracking();
  }

  void initNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);
    flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> showArrivalNotification() async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails("cab_channel", "Cab Updates",
        importance: Importance.max, priority: Priority.high);

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      "Cab Arrived",
      "Your cab has arrived at your location!",
      notificationDetails,
    );
  }

  Future<void> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void startTracking() {
    _timer = Timer.periodic(Duration(seconds: 5), (_) => fetchCabLocation());
  }

  Future<void> fetchCabLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url') ?? '';
    String trackUrl = '$url/track_cab/';

    final response = await http.post(Uri.parse(trackUrl), body: {
      'booking_id': widget.bookingId,
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'ok') {
        double lat = double.parse(json['latitude']);
        double lon = double.parse(json['longitude']);
        setState(() {
          cabLocation = LatLng(lat, lon);
        });

        if (userLocation != null) {
          double distance = Geolocator.distanceBetween(
              userLocation!.latitude, userLocation!.longitude, lat, lon);

          if (distance <= 100) {
            showArrivalNotification();
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    if (userLocation != null) {
      markers.add(Marker(
          markerId: MarkerId("user"), position: userLocation!, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
    }
    if (cabLocation != null) {
      markers.add(Marker(
          markerId: MarkerId("cab"), position: cabLocation!, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Track Cab")),
      body: userLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: userLocation!,
          zoom: 15,
        ),
        markers: markers,
      ),
    );
  }
}
