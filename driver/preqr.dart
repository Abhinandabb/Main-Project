import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(home: MyHome()));

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const qr(),
            ));
          },
          child: const Text('qrView'),
        ),
      ),
    );
  }
}

class qr extends StatefulWidget {
  const qr({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _qrState();
}

class _qrState extends State<qr> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isProcessing = false; // Flag to prevent multiple scans

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
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!isProcessing) {
        setState(() {
          isProcessing = true;
          result = scanData;
        });
        qrBus();
      }
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


  List<String> id_ = <String>[];
  List<String> itemname_= <String>[];
  List<String> price_= <String>[];
  List<String> details_= <String>[];
  List<String> photo_= <String>[];


  Future<void> qrBus() async {
    if (isProcessing) return; // Prevent duplicate scans
    setState(() => isProcessing = true);

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';
    String cid = sh.getString('cid') ?? '';
    String imgurl = sh.getString('imgurl') ?? '';
    String scan_id = result?.code.toString() ?? '';

    if (scan_id.isEmpty) {
      Fluttertoast.showToast(msg: "Invalid QR Code", backgroundColor: Colors.red);
      setState(() => isProcessing = false);
      return;
    }

    final Uri apiUrl = Uri.parse('$url/d_pre_qr/');
    try {
      await controller?.stopCamera();
      final response = await http.post(apiUrl, body: {
        'lid': lid,
        'scan_id': scan_id,
        // 'cid':cid

      });

      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'ok') {
        var arr = jsonData["data"];

        setState(() {
          id_ = arr.map<String>((item) => item['id'].toString()).toList();
          itemname_ = arr.map<String>((item) => item['item_name'].toString()).toList();
          price_ = arr.map<String>((item) => item['price'].toString()).toList();
          details_ = arr.map<String>((item) => item['details'].toString()).toList();
          photo_ = arr.map<String>((item) => imgurl + item['photo'].toString()).toList();
        });

        Fluttertoast.showToast(msg: "Scan Successful!", backgroundColor: Colors.green);
      } else {
        Fluttertoast.showToast(msg: "No Data Found", backgroundColor: Colors.orange);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e", backgroundColor: Colors.red);
    } finally {
      setState(() => isProcessing = false);
    }
  }
}

