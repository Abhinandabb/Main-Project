import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        qrBooking();
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void qrBooking() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String img_url = sh.getString('img_url') ?? '';
    String scanId = result!.code.toString();

    if (url.isEmpty || scanId.isEmpty) {
      Fluttertoast.showToast(msg: 'Scan ID or URL not found');
      return;
    }

    final urls = Uri.parse(url + "/u_qr_scanning/");
    try {
      final response = await http.post(urls, body: {'scan_id': scanId});
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String status = responseData['status'];

        if (status == 'ok') {
          String type = responseData['type'].toString();
          Fluttertoast.showToast(msg: 'Check In');
          Fluttertoast.showToast(msg: type);

          if (type == "spot" || type == "pre") {
            _showBookingDetails(responseData, type, img_url);
          }
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
      Fluttertoast.showToast(msg: 'An error occurred');
    }
  }

  void _showBookingDetails(Map<String, dynamic> data, String type, String img_url) {
    String name = data['name'].toString();
    String photo = img_url + data['photo'].toString();
    String mobileNo = data['Mobile_no'].toString();
    String location = data['Location'].toString();
    String amount = data['Amount'].toString();
    String date = data['date'].toString();

    String additionalInfo = '';
    if (type == 'pre') {
      String bookingDate = data['Booking_date'].toString();
      String time = data['Time'].toString();
      additionalInfo = 'Travel Date: $bookingDate\nTime: $time';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("$type Booking Details"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(photo),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Name: $name', style: const TextStyle(fontSize: 16)),
                Text('Mobile No: $mobileNo', style: const TextStyle(fontSize: 16)),
                additionalInfo.isEmpty?Text('Location: $location', style: const TextStyle(fontSize: 16)):Text(""),
                Text('Amount: ₹$amount', style: const TextStyle(fontSize: 16)),
                Text('Date: $date', style: const TextStyle(fontSize: 16)),
                if (additionalInfo.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(additionalInfo, style: const TextStyle(fontSize: 16)),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
