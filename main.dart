// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'login.dart';
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
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController textcontroller = new TextEditingController();
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
//             TextField(
//               controller: textcontroller,
//               decoration: InputDecoration(border: OutlineInputBorder(),label: Text("text")),),
//             ElevatedButton(onPressed: (){
//               senddata();
//             }, child: Text('send'))
//
//           ],
//         ),
//       ),
//
//     );
//
//   }
//   senddata() async{
//     String text=textcontroller.text;
//
//     SharedPreferences sh=await SharedPreferences.getInstance();
//     sh.setString("url", "http://" + text + ":8000/Myapp");
//     sh.setString("img_url", "http://" + text + ":8000");
//
//     Navigator.push(context, MaterialPageRoute(
//       builder: (context) => login(title: "Home"),));
//
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Server Configuration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
      home: const ServerConfigPage(title: 'Server Configuration'),
    );
  }
}

class ServerConfigPage extends StatefulWidget {
  const ServerConfigPage({super.key, required this.title});

  final String title;

  @override
  State<ServerConfigPage> createState() => _ServerConfigPageState();
}

class _ServerConfigPageState extends State<ServerConfigPage> {
  final TextEditingController _ipController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Illustration or logo
              Icon(
                Icons.dns_rounded,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Enter Server IP Address',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please enter the IP address of your server to connect to the application services',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'Server IP Address',
                  prefixIcon: Icon(Icons.computer),
                  hintText: '192.168.1.100',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an IP address';
                  }
                  if (!RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid IP address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Example format helper
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Example: 192.168.1.100',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _connectToServer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Connect to Server',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              // TextButton(
              //   onPressed: () {
              //     // Add functionality for localhost or default IP
              //     _ipController.text = '10.0.2.2'; // Common Android emulator IP
              //     _connectToServer();
              //   },
              //   child: const Text('Use default localhost (for testing)'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _connectToServer() async {
    if (_formKey.currentState!.validate()) {
      final ipAddress = _ipController.text.trim();
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString("url", "http://$ipAddress:8000/Myapp");
      await prefs.setString("img_url", "http://$ipAddress:8000");

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => login(title: "Login"),
        ),
      );
    }
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }
}