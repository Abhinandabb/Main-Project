//
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../login.dart';
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
//       title: 'Driver Signup',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const signup(title: 'Driver Signup'),
//     );
//   }
// }
//
// class signup extends StatefulWidget {
//   const signup({super.key, required this.title});
//   final String title;
//
//   @override
//   State<signup> createState() => _signupState();
// }
//
// class _signupState extends State<signup> {
//   TextEditingController Name_controller = TextEditingController();
//   TextEditingController Age_controller = TextEditingController();
//   TextEditingController Mobile_no_controller = TextEditingController();
//   TextEditingController Email_controller = TextEditingController();
//   TextEditingController Place_controller = TextEditingController();
//   TextEditingController Pin_controller = TextEditingController();
//   TextEditingController Post_controller = TextEditingController();
//   TextEditingController Experience_controller = TextEditingController();
//   TextEditingController License_controller = TextEditingController();
//   TextEditingController Vehicle_controller = TextEditingController();
//   TextEditingController Rc_no_controller = TextEditingController();
//   TextEditingController Password_controller = TextEditingController();
//   TextEditingController Confirm_password_controller = TextEditingController();
//
//   File? _selectedImage;
//   String photo = '';
//   File? _selectedImage1;
//   String license = '';
//   File? _selectedImage2;
//   String vehicle_photo = '';
//
//   final List<String> vehicleTypes = ['Car', 'Autotaxi', 'Autorickshaw', 'Bike'];
//   String? selectedVehicle;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title, style: const TextStyle(color: Colors.white)),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             buildImageSelector(_selectedImage, "Driver Photo", _checkPermissionAndChooseImage),
//             const SizedBox(height: 10),
//             buildImageSelector(_selectedImage1, "License Proof", _checkPermissionAndChooseImage1),
//             const SizedBox(height: 10),
//             buildImageSelector(_selectedImage2, "Vehicle Photo", _checkPermissionAndChooseImage2),
//             const SizedBox(height: 20),
//
//             buildInputField(Icons.person, "Name", Name_controller),
//             buildInputField(Icons.calendar_today, "Age", Age_controller),
//             buildInputField(Icons.phone, "Mobile No", Mobile_no_controller),
//             buildInputField(Icons.email, "Email", Email_controller),
//             buildInputField(Icons.location_city, "Place", Place_controller),
//             buildInputField(Icons.pin_drop, "Pin", Pin_controller),
//             buildInputField(Icons.map, "Post", Post_controller),
//             buildInputField(Icons.work, "Experience", Experience_controller),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 6),
//               child: DropdownButtonFormField<String>(
//                 value: selectedVehicle,
//                 decoration: InputDecoration(
//                   labelText: 'Vehicle Type',
//                   prefixIcon: const Icon(Icons.directions_car, color: Colors.deepPurple),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 items: vehicleTypes.map((type) {
//                   return DropdownMenuItem(
//                     value: type,
//                     child: Text(type),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedVehicle = value;
//                     Vehicle_controller.text = value!;
//                   });
//                 },
//               ),
//             ),
//
//             buildInputField(Icons.confirmation_number, "RC No", Rc_no_controller),
//             buildInputField(Icons.lock, "Password", Password_controller, obscure: true),
//             buildInputField(Icons.lock_outline, "Confirm Password", Confirm_password_controller, obscure: true),
//
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
//               icon: const Icon(Icons.send, color: Colors.white),
//               label: const Text('Submit', style: TextStyle(color: Colors.white)),
//               onPressed: () {
//                 senddata();
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildInputField(IconData icon, String label, TextEditingController controller, {bool obscure = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: TextField(
//         controller: controller,
//         obscureText: obscure,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.deepPurple),
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
//
//   Widget buildImageSelector(File? selectedFile, String label, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: selectedFile != null
//           ? ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Image.file(selectedFile, width: 150, height: 150, fit: BoxFit.cover),
//       )
//           : Column(
//         children: [
//           Image.network(
//             'https://cdn.pixabay.com/photo/2017/11/10/05/24/select-2935439_1280.png',
//             height: 150,
//             width: 150,
//           ),
//           const SizedBox(height: 5),
//           Text("Select $label", style: const TextStyle(color: Colors.cyan)),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _chooseAndUploadImage() async {
//     final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//         photo = base64Encode(_selectedImage!.readAsBytesSync());
//       });
//     }
//   }
//
//   Future<void> _chooseAndUploadImage1() async {
//     final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage1 = File(pickedImage.path);
//         license = base64Encode(_selectedImage1!.readAsBytesSync());
//       });
//     }
//   }
//
//   Future<void> _chooseAndUploadImage2() async {
//     final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage2 = File(pickedImage.path);
//         vehicle_photo = base64Encode(_selectedImage2!.readAsBytesSync());
//       });
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage() async {
//     final status = await Permission.mediaLibrary.request();
//     if (status.isGranted) {
//       _chooseAndUploadImage();
//     } else {
//       _showPermissionDialog();
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage1() async {
//     final status = await Permission.mediaLibrary.request();
//     if (status.isGranted) {
//       _chooseAndUploadImage1();
//     } else {
//       _showPermissionDialog();
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage2() async {
//     final status = await Permission.mediaLibrary.request();
//     if (status.isGranted) {
//       _chooseAndUploadImage2();
//     } else {
//       _showPermissionDialog();
//     }
//   }
//
//   void _showPermissionDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text('Permission Denied'),
//         content: const Text('Please go to app settings and grant permission to choose an image.'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
//         ],
//       ),
//     );
//   }
//
//   Future<void> senddata() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     final urls = Uri.parse('$url/d_register/');
//
//     final response = await http.post(urls, body: {
//       'name': Name_controller.text,
//       'age': Age_controller.text,
//       'mobileno': Mobile_no_controller.text,
//       'email': Email_controller.text,
//       'photo': photo,
//       'vehicle_photo': vehicle_photo,
//       'place': Place_controller.text,
//       'pin': Pin_controller.text,
//       'post': Post_controller.text,
//       'experience': Experience_controller.text,
//       'license': license,
//       'vehicle': Vehicle_controller.text,
//       'rcno': Rc_no_controller.text,
//       'password': Password_controller.text,
//       'confirmpassw': Confirm_password_controller.text,
//     });
//
//     if (response.statusCode == 200) {
//       final status = jsonDecode(response.body)['status'];
//       if (status == 'ok') {
//         Fluttertoast.showToast(msg: 'Registration Successful');
//         Navigator.push(context, MaterialPageRoute(builder: (context) => login(title: "Login")));
//       } else {
//         Fluttertoast.showToast(msg: 'Registration Failed');
//       }
//     } else {
//       Fluttertoast.showToast(msg: 'Network Error');
//     }
//   }
// }
//
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../login.dart';
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
//       title: 'Driver Signup',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const signup(title: 'Driver Signup'),
//     );
//   }
// }
//
// class signup extends StatefulWidget {
//   const signup({super.key, required this.title});
//   final String title;
//
//   @override
//   State<signup> createState() => _signupState();
// }
//
// class _signupState extends State<signup> {
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController Name_controller = TextEditingController();
//   TextEditingController Age_controller = TextEditingController();
//   TextEditingController Mobile_no_controller = TextEditingController();
//   TextEditingController Email_controller = TextEditingController();
//   TextEditingController Place_controller = TextEditingController();
//   TextEditingController Pin_controller = TextEditingController();
//   TextEditingController Post_controller = TextEditingController();
//   TextEditingController Experience_controller = TextEditingController();
//   TextEditingController License_controller = TextEditingController();
//   TextEditingController Vehicle_controller = TextEditingController();
//   TextEditingController Rc_no_controller = TextEditingController();
//   TextEditingController Password_controller = TextEditingController();
//   TextEditingController Confirm_password_controller = TextEditingController();
//
//   File? _selectedImage;
//   String photo = '';
//   File? _selectedImage1;
//   String license = '';
//   File? _selectedImage2;
//   String vehicle_photo = '';
//
//   final List<String> vehicleTypes = ['Car', 'Autotaxi', 'Autorickshaw', 'Bike'];
//   String? selectedVehicle;
//
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title, style: const TextStyle(color: Colors.white)),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Image Selectors Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   buildImageSelector(_selectedImage, "Driver Photo", _checkPermissionAndChooseImage),
//                   buildImageSelector(_selectedImage1, "License Proof", _checkPermissionAndChooseImage1),
//                   buildImageSelector(_selectedImage2, "Vehicle Photo", _checkPermissionAndChooseImage2),
//                 ],
//               ),
//               const SizedBox(height: 20),
//
//               // Personal Information
//               buildInputField(Icons.person, "Name", Name_controller, validator: _validateName),
//               buildInputField(Icons.calendar_today, "Age", Age_controller,
//                   keyboardType: TextInputType.number, validator: _validateAge),
//               buildInputField(Icons.phone, "Mobile No", Mobile_no_controller,
//                   keyboardType: TextInputType.phone, validator: _validateMobile),
//               buildInputField(Icons.email, "Email", Email_controller,
//                   keyboardType: TextInputType.emailAddress, validator: _validateEmail),
//               buildInputField(Icons.location_city, "Place", Place_controller, validator: _validatePlace),
//               buildInputField(Icons.pin_drop, "Pin", Pin_controller,
//                   keyboardType: TextInputType.number, validator: _validatePin),
//               buildInputField(Icons.map, "Post", Post_controller, validator: _validatePost),
//               buildInputField(Icons.work, "Experience", Experience_controller,
//                   keyboardType: TextInputType.number, validator: _validateExperience),
//               buildInputField(Icons.confirmation_number, "License No", License_controller,
//                   validator: _validateLicense),
//
//               // Vehicle Dropdown
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: DropdownButtonFormField<String>(
//                   value: selectedVehicle,
//                   decoration: InputDecoration(
//                     labelText: 'Vehicle Type',
//                     prefixIcon: const Icon(Icons.directions_car, color: Colors.deepPurple),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   items: vehicleTypes.map((type) {
//                     return DropdownMenuItem(
//                       value: type,
//                       child: Text(type),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedVehicle = value;
//                       Vehicle_controller.text = value!;
//                     });
//                   },
//                   validator: (value) => value == null ? 'Please select vehicle type' : null,
//                 ),
//               ),
//
//               buildInputField(Icons.confirmation_number, "RC No", Rc_no_controller,
//                   validator: _validateRcNumber),
//
//               // Password Fields
//               buildPasswordField(Icons.lock, "Password", Password_controller,
//                   obscure: _obscurePassword, toggleVisibility: _togglePasswordVisibility),
//               buildPasswordField(Icons.lock_outline, "Confirm Password", Confirm_password_controller,
//                   obscure: _obscureConfirmPassword, toggleVisibility: _toggleConfirmPasswordVisibility),
//
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                   onPressed: _isLoading ? null : senddata,
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text('Submit', style: TextStyle(color: Colors.white)),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildInputField(
//       IconData icon,
//       String label,
//       TextEditingController controller, {
//         TextInputType keyboardType = TextInputType.text,
//         String? Function(String?)? validator,
//       }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.deepPurple),
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         validator: validator,
//       ),
//     );
//   }
//
//   Widget buildPasswordField(
//       IconData icon,
//       String label,
//       TextEditingController controller, {
//         required bool obscure,
//         required VoidCallback toggleVisibility,
//       }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscure,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.deepPurple),
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//           suffixIcon: IconButton(
//             icon: Icon(
//               obscure ? Icons.visibility : Icons.visibility_off,
//               color: Colors.deepPurple,
//             ),
//             onPressed: toggleVisibility,
//           ),
//         ),
//         validator: _validatePassword,
//       ),
//     );
//   }
//
//   Widget buildImageSelector(File? selectedFile, String label, VoidCallback onTap) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.deepPurple.withOpacity(0.5)),
//             ),
//             child: selectedFile != null
//                 ? ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.file(selectedFile, fit: BoxFit.cover),
//             )
//                 : const Icon(Icons.add_a_photo, color: Colors.deepPurple, size: 30),
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 12, color: Colors.deepPurple),
//         ),
//       ],
//     );
//   }
//
//
//   // Validation functions
//   String? _validateName(String? value) {
//     if (value == null || value.isEmpty) return 'Please enter name';
//     if (value.length < 3) return 'Name too short';
//     return null;
//   }
//
//   String? _validateAge(String? value) {
//     if (value == null || value.isEmpty) return 'Please enter age';
//     final age = int.tryParse(value);
//     if (age == null) return 'Invalid age';
//     if (age < 18 || age > 100) return 'Age must be 18-100';
//     return null;
//   }
//
//   String? _validateMobile(String? value) {
//     if (value == null || value.isEmpty) return 'Please enter mobile';
//     if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) return 'Invalid mobile';
//     return null;
//   }
//
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) return 'Please enter email';
//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Invalid email';
//     return null;
//   }
//
//   String? _validatePlace(String? value) {
//     if (value == null || value.isEmpty) return 'Please enter place';
//     return null;
//   }
//
//   String? _validatePin(String? value) {
//     if (value == null || value.isEmpty) return 'Please enter PIN';
//     if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) return 'Invalid PIN';
//     return null;
//   }
//
//   String? _validatePost(String? value) {
//     if (value == null || value.isEmpty) return 'Please enter post';
//     return null;
//   }
//
//   String? _validateExperience(String? value) {
//     if (value == null || value.isEmpty) return 'Please enter experience';
//     final exp = int.tryParse(value);
//     if (exp == null) return 'Invalid number';
//     if (exp < 0 || exp > 50) return 'Invalid experience';
//     return null;
//   }
//
//   String? _validateLicense(String? value) {
//     if (value == null || value.isEmpty) return 'Please enter license';
//     return null;
//   }
//
//   String? _validateRcNumber(String? value) {
//     if (value == null || value.isEmpty) return 'Please enter RC number';
//     return null;
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) return 'Please enter password';
//     if (value.length < 6) return 'Password too short';
//     if (Password_controller.text != Confirm_password_controller.text) return 'Passwords don\'t match';
//     return null;
//   }
//
//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscurePassword = !_obscurePassword;
//     });
//   }
//
//   void _toggleConfirmPasswordVisibility() {
//     setState(() {
//       _obscureConfirmPassword = !_obscureConfirmPassword;
//     });
//   }
//
//   Future<void> senddata() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     if (_selectedImage == null) {
//       Fluttertoast.showToast(msg: 'Please upload driver photo');
//       return;
//     }
//
//     if (_selectedImage1 == null) {
//       Fluttertoast.showToast(msg: 'Please upload license proof');
//       return;
//     }
//
//     if (_selectedImage2 == null) {
//       Fluttertoast.showToast(msg: 'Please upload vehicle photo');
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url').toString();
//       final urls = Uri.parse('$url/d_register/');
//
//       final response = await http.post(urls, body: {
//         'name': Name_controller.text,
//         'age': Age_controller.text,
//         'mobileno': Mobile_no_controller.text,
//         'email': Email_controller.text,
//         'photo': photo,
//         'vehicle_photo': vehicle_photo,
//         'place': Place_controller.text,
//         'pin': Pin_controller.text,
//         'post': Post_controller.text,
//         'experience': Experience_controller.text,
//         'license': license,
//         'vehicle': Vehicle_controller.text,
//         'rcno': Rc_no_controller.text,
//         'password': Password_controller.text,
//         'confirmpassw': Confirm_password_controller.text,
//       }).timeout(const Duration(seconds: 30));
//
//       if (response.statusCode == 200) {
//         final status = jsonDecode(response.body)['status'];
//         if (status == 'ok') {
//           Fluttertoast.showToast(
//             msg: 'Registration Successful',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.green,
//             textColor: Colors.white,
//           );
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => login(title: "Login")),
//           );
//         } else {
//           Fluttertoast.showToast(
//             msg: 'Registration Failed: ${jsonDecode(response.body)['message'] ?? 'Unknown error'}',
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//           );
//         }
//       } else {
//         Fluttertoast.showToast(
//           msg: 'Server Error: ${response.statusCode}',
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'Error: ${e.toString()}',
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   Future<void> _chooseAndUploadImage() async {
//     final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//         photo = base64Encode(_selectedImage!.readAsBytesSync());
//       });
//     }
//   }
//
//   Future<void> _chooseAndUploadImage1() async {
//     final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage1 = File(pickedImage.path);
//         license = base64Encode(_selectedImage1!.readAsBytesSync());
//       });
//     }
//   }
//
//   Future<void> _chooseAndUploadImage2() async {
//     final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage2 = File(pickedImage.path);
//         vehicle_photo = base64Encode(_selectedImage2!.readAsBytesSync());
//       });
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage() async {
//     final status = await Permission.photos.request();
//     if (status.isGranted) {
//       await _chooseAndUploadImage();
//     } else {
//       _showPermissionDialog();
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage1() async {
//     final status = await Permission.photos.request();
//     if (status.isGranted) {
//       await _chooseAndUploadImage1();
//     } else {
//       _showPermissionDialog();
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage2() async {
//     final status = await Permission.photos.request();
//     if (status.isGranted) {
//       await _chooseAndUploadImage2();
//     } else {
//       _showPermissionDialog();
//     }
//   }
//
//   void _showPermissionDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text('Permission Required'),
//         content: const Text('Please grant photo access to upload images'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               openAppSettings();
//             },
//             child: const Text('Open Settings'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../login.dart';
//
// class signup extends StatefulWidget {
//   const signup({super.key, required this.title});
//   final String title;
//
//   @override
//   State<signup> createState() => _signupState();
// }
//
// class _signupState extends State<signup> {
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController Name_controller = TextEditingController();
//   TextEditingController Age_controller = TextEditingController();
//   TextEditingController Mobile_no_controller = TextEditingController();
//   TextEditingController Email_controller = TextEditingController();
//   TextEditingController Place_controller = TextEditingController();
//   TextEditingController Pin_controller = TextEditingController();
//   TextEditingController Post_controller = TextEditingController();
//   TextEditingController Experience_controller = TextEditingController();
//   TextEditingController License_controller = TextEditingController();
//   TextEditingController Vehicle_controller = TextEditingController();
//   TextEditingController Rc_no_controller = TextEditingController();
//   TextEditingController Password_controller = TextEditingController();
//   TextEditingController Confirm_password_controller = TextEditingController();
//
//   File? _selectedImage;
//   File? _selectedImage1;
//   File? _selectedImage2;
//
//   final List<String> vehicleTypes = ['Car', 'Autotaxi', 'Autorickshaw', 'Bike'];
//   String? selectedVehicle;
//
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//
//   final ImagePicker picker = ImagePicker();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title, style: const TextStyle(color: Colors.white)),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   buildImageSelector(_selectedImage, "Driver Photo", _checkPermissionAndChooseImage),
//                   buildImageSelector(_selectedImage1, "License Proof", _checkPermissionAndChooseImage1),
//                   buildImageSelector(_selectedImage2, "Vehicle Photo", _checkPermissionAndChooseImage2),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               buildInputField(Icons.person, "Name", Name_controller, validator: _validateName),
//               buildInputField(Icons.calendar_today, "Age", Age_controller, keyboardType: TextInputType.number, validator: _validateAge),
//               buildInputField(Icons.phone, "Mobile No", Mobile_no_controller, keyboardType: TextInputType.phone, validator: _validateMobile),
//               buildInputField(Icons.email, "Email", Email_controller, keyboardType: TextInputType.emailAddress, validator: _validateEmail),
//               buildInputField(Icons.location_city, "Place", Place_controller, validator: _validatePlace),
//               buildInputField(Icons.pin_drop, "Pin", Pin_controller, keyboardType: TextInputType.number, validator: _validatePin),
//               buildInputField(Icons.map, "Post", Post_controller, validator: _validatePost),
//               buildInputField(Icons.work, "Experience", Experience_controller, keyboardType: TextInputType.number, validator: _validateExperience),
//               buildInputField(Icons.confirmation_number, "License No", License_controller, validator: _validateLicense),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: DropdownButtonFormField<String>(
//                   value: selectedVehicle,
//                   decoration: InputDecoration(
//                     labelText: 'Vehicle Type',
//                     prefixIcon: const Icon(Icons.directions_car, color: Colors.deepPurple),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   items: vehicleTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedVehicle = value;
//                       Vehicle_controller.text = value!;
//                     });
//                   },
//                   validator: (value) => value == null ? 'Please select vehicle type' : null,
//                 ),
//               ),
//               buildInputField(Icons.confirmation_number, "RC No", Rc_no_controller, validator: _validateRcNumber),
//               buildPasswordField(Icons.lock, "Password", Password_controller, obscure: _obscurePassword, toggleVisibility: _togglePasswordVisibility),
//               buildPasswordField(Icons.lock_outline, "Confirm Password", Confirm_password_controller, obscure: _obscureConfirmPassword, toggleVisibility: _toggleConfirmPasswordVisibility),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//                   onPressed: _isLoading ? null : senddata,
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text('Submit', style: TextStyle(color: Colors.white)),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildImageSelector(File? image, String label, VoidCallback onTap) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: CircleAvatar(
//             radius: 40,
//             backgroundColor: Colors.grey.shade300,
//             backgroundImage: image != null ? FileImage(image) : null,
//             child: image == null ? const Icon(Icons.camera_alt, color: Colors.white) : null,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(label, style: const TextStyle(fontSize: 12))
//       ],
//     );
//   }
//
//   Widget buildInputField(IconData icon, String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         validator: validator,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.deepPurple),
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
//
//   Widget buildPasswordField(IconData icon, String label, TextEditingController controller, {required bool obscure, required VoidCallback toggleVisibility}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscure,
//         validator: _validatePassword,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.deepPurple),
//           suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility : Icons.visibility_off), onPressed: toggleVisibility),
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
//
//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscurePassword = !_obscurePassword;
//     });
//   }
//
//   void _toggleConfirmPasswordVisibility() {
//     setState(() {
//       _obscureConfirmPassword = !_obscureConfirmPassword;
//     });
//   }
//
//   Future<void> _checkPermissionAndChooseImage() async {
//     if (await Permission.photos.request().isGranted) {
//       final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setState(() => _selectedImage = File(image.path));
//       }
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage1() async {
//     if (await Permission.photos.request().isGranted) {
//       final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setState(() => _selectedImage1 = File(image.path));
//       }
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage2() async {
//     if (await Permission.photos.request().isGranted) {
//       final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setState(() => _selectedImage2 = File(image.path));
//       }
//     }
//   }
//
//   // =============== VALIDATIONS =================
//
//   String? _validateName(String? value) => value == null || value.isEmpty ? 'Name is required' : null;
//   String? _validateAge(String? value) => value == null || value.isEmpty ? 'Age is required' : null;
//   String? _validateMobile(String? value) => value != null && RegExp(r'^\d{10}$').hasMatch(value) ? null : 'Enter a valid 10-digit mobile number';
//   String? _validatePlace(String? value) => value == null || value.isEmpty ? 'Place is required' : null;
//   String? _validatePin(String? value) => value != null && value.length == 6 ? null : 'Enter valid 6-digit PIN';
//   String? _validatePost(String? value) => value == null || value.isEmpty ? 'Post is required' : null;
//   String? _validateExperience(String? value) => value == null || value.isEmpty ? 'Experience is required' : null;
//   String? _validateLicense(String? value) => value == null || value.isEmpty ? 'License number is required' : null;
//   String? _validateRcNumber(String? value) => value == null || value.isEmpty ? 'RC number is required' : null;
//
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) return 'Email is required';
//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) return 'Invalid email format';
//     return null;
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) return 'Password is required';
//     if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$').hasMatch(value)) {
//       return 'Password must contain upper, lower, digit, and be at least 6 characters';
//     }
//     if (value != Confirm_password_controller.text) return 'Passwords do not match';
//     return null;
//   }
//
//   // =============== SUBMIT =================
//
//   Future<void> senddata() async {
//     if (_formKey.currentState?.validate() != true) return;
//
//     final response = await http.post(
//       Uri.parse("http://YOUR_BACKEND_API/check_email.php"), // Replace with your email-check endpoint
//       body: {'email': Email_controller.text},
//     );
//
//     final result = json.decode(response.body);
//     if (result['exists']) {
//       Fluttertoast.showToast(msg: "Email already registered");
//       return;
//     }
//
//     Fluttertoast.showToast(msg: "All validations passed. Submitting...");
//
//     // Call your actual registration logic here (upload images, data, etc.)
//   }
// }
//
//
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login.dart';

class signup extends StatefulWidget {
  const signup({super.key, required this.title});
  final String title;

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController Name_controller = TextEditingController();
  TextEditingController Age_controller = TextEditingController();
  TextEditingController Mobile_no_controller = TextEditingController();
  TextEditingController Email_controller = TextEditingController();
  TextEditingController Place_controller = TextEditingController();
  TextEditingController Pin_controller = TextEditingController();
  TextEditingController Post_controller = TextEditingController();
  TextEditingController Experience_controller = TextEditingController();
  TextEditingController Vehicle_controller = TextEditingController();
  TextEditingController Rc_no_controller = TextEditingController();
  TextEditingController Password_controller = TextEditingController();
  TextEditingController Confirm_password_controller = TextEditingController();

  File? _selectedImage;
  File? _selectedImage1;
  File? _selectedImage2;
  String? _driverPhotoBase64;
  String? _licensePhotoBase64;
  String? _vehiclePhotoBase64;

  final List<String> vehicleTypes = ['Car', 'Autotaxi', 'Autorickshaw', 'Bike'];
  String? selectedVehicle;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildImageSelector(_selectedImage, "Driver Photo", _checkPermissionAndChooseImage),
                  buildImageSelector(_selectedImage1, "License Proof", _checkPermissionAndChooseImage1),
                  buildImageSelector(_selectedImage2, "Vehicle Photo", _checkPermissionAndChooseImage2),
                ],
              ),
              const SizedBox(height: 20),
              buildInputField(Icons.person, "Name", Name_controller, validator: _validateName),
              buildInputField(Icons.calendar_today, "Age", Age_controller, keyboardType: TextInputType.number, validator: _validateAge),
              buildInputField(Icons.phone, "Mobile No", Mobile_no_controller, keyboardType: TextInputType.phone, validator: _validateMobile),
              buildInputField(Icons.email, "Email", Email_controller, keyboardType: TextInputType.emailAddress, validator: _validateEmail),
              buildInputField(Icons.location_city, "Place", Place_controller, validator: _validatePlace),
              buildInputField(Icons.pin_drop, "Pin", Pin_controller, keyboardType: TextInputType.number, validator: _validatePin),
              buildInputField(Icons.map, "Post", Post_controller, validator: _validatePost),
              buildInputField(Icons.work, "Experience", Experience_controller, keyboardType: TextInputType.number, validator: _validateExperience),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DropdownButtonFormField<String>(
                  value: selectedVehicle,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Type',
                    prefixIcon: const Icon(Icons.directions_car, color: Colors.deepPurple),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: vehicleTypes.map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedVehicle = value;
                      Vehicle_controller.text = value!;
                    });
                  },
                  validator: (value) => value == null ? 'Please select vehicle type' : null,
                ),
              ),
              buildInputField(Icons.confirmation_number, "RC No", Rc_no_controller, validator: _validateRcNumber),
              buildPasswordField(Icons.lock, "Password", Password_controller, obscure: _obscurePassword, toggleVisibility: _togglePasswordVisibility),
              buildPasswordField(Icons.lock_outline, "Confirm Password", Confirm_password_controller, obscure: _obscureConfirmPassword, toggleVisibility: _toggleConfirmPasswordVisibility),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : senddata,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageSelector(File? image, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: image != null ? FileImage(image) : null,
            child: image == null ? const Icon(Icons.camera_alt, color: Colors.white) : null,
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12))
      ],
    );
  }

  Widget buildInputField(IconData icon, String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget buildPasswordField(IconData icon, String label, TextEditingController controller,
      {required bool obscure, required VoidCallback toggleVisibility}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: _validatePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
            onPressed: toggleVisibility,
          ),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }




  Future<void> _checkPermissionAndChooseImage() async {
    if (await Permission.photos.request().isGranted) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        setState(() {
          _selectedImage = File(image.path);
          _driverPhotoBase64 = base64Encode(bytes);
        });
      }
    }
  }

  Future<void> _checkPermissionAndChooseImage1() async {
    if (await Permission.photos.request().isGranted) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        setState(() {
          _selectedImage1 = File(image.path);
          _licensePhotoBase64 = base64Encode(bytes);
        });
      }
    }
  }

  Future<void> _checkPermissionAndChooseImage2() async {
    if (await Permission.photos.request().isGranted) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        setState(() {
          _selectedImage2 = File(image.path);
          _vehiclePhotoBase64 = base64Encode(bytes);
        });
      }
    }
  }

  // Validation functions
  String? _validateName(String? value) => value == null || value.isEmpty ? 'Name is required' : null;
  String? _validateAge(String? value) => value == null || value.isEmpty ? 'Age is required' :
  int.tryParse(value!) == null ? 'Enter valid age' : null;
  String? _validateMobile(String? value) => value == null || value.isEmpty ? 'Mobile number is required' :
  RegExp(r'^[0-9]{10}$').hasMatch(value) ? null : 'Enter valid 10-digit mobile number';
  String? _validateEmail(String? value) => value == null || value.isEmpty ? 'Email is required' :
  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value) ? null : 'Enter valid email';
  String? _validatePlace(String? value) => value == null || value.isEmpty ? 'Place is required' : null;
  String? _validatePin(String? value) => value == null || value.isEmpty ? 'PIN code is required' :
  RegExp(r'^[0-9]{6}$').hasMatch(value) ? null : 'Enter valid 6-digit PIN';
  String? _validatePost(String? value) => value == null || value.isEmpty ? 'Post is required' : null;
  String? _validateExperience(String? value) => value == null || value.isEmpty ? 'Experience is required' :
  int.tryParse(value!) == null ? 'Enter valid experience' : null;
  String? _validateRcNumber(String? value) => value == null || value.isEmpty ? 'RC number is required' : null;
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Must contain an uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Must contain a lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Must contain a digit';
    return null;
  }

  Future<void> senddata() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate password match
    if (Password_controller.text != Confirm_password_controller.text) {
      Fluttertoast.showToast(msg: 'Passwords do not match');
      return;
    }

    // Validate image selections
    if (_selectedImage == null || _selectedImage1 == null || _selectedImage2 == null) {
      Fluttertoast.showToast(msg: 'Please upload all required images');
      return;
    }

    setState(() => _isLoading = true);

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url').toString();

      final response = await http.post(
        Uri.parse('$url/d_register/'),
        body: {
          'name': Name_controller.text,
          'age': Age_controller.text,
          'mobileno': Mobile_no_controller.text,
          'email': Email_controller.text,
          'photo': _driverPhotoBase64!,
          'vehicle_photo': _vehiclePhotoBase64!,
          'place': Place_controller.text,
          'pin': Pin_controller.text,
          'post': Post_controller.text,
          'experience': Experience_controller.text,
          'license': _licensePhotoBase64!,
          'vehicle': Vehicle_controller.text,
          'rcno': Rc_no_controller.text,
          'password': Password_controller.text,
          'confirmpassw': Confirm_password_controller.text,
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: 'Registration Successful',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => login(title: "Login")),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Registration Failed: ${jsonResponse['message'] ?? 'Unknown error'}',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Server Error: ${response.statusCode}',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}