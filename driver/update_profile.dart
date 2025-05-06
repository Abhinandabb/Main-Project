// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:public_transportation/driver/driverhome.dart';
// import 'package:public_transportation/driver/view_profile.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
//
//
// class update_profile extends StatefulWidget {
//   const update_profile({super.key, required this.title, required this.name, required this.age, required this.mobileno, required this.email, required this.photo,required this.vehiclephoto, required this.place, required this.pin, required this.post, required this.experience, required this.vehicle, required this.license, required this.rcno,required this.astatus});
//
//
//   final String title;
//   final String name;
//   final String age;
//   final String mobileno;
//   final String email;
//   final String photo;
//   final String vehiclephoto;
//   final String place;
//   final String pin;
//   final String post;
//   final String experience;
//   final String vehicle;
//   final String license;
//   final String rcno;
//   final String astatus;
//
//
//
//   @override
//   State<update_profile> createState() => _update_profileState();
// }
//
// class _update_profileState extends State<update_profile> {
//
//   TextEditingController Name_controller = new TextEditingController();
//   TextEditingController Age_controller = new TextEditingController();
//   TextEditingController Mobile_no_controller = new TextEditingController();
//   TextEditingController Email_controller = new TextEditingController();
//   TextEditingController Photo_controller = new TextEditingController();
//   TextEditingController Vehicle_Photo_controller=new TextEditingController();
//   TextEditingController Place_controller = new TextEditingController();
//   TextEditingController Pin_controller = new TextEditingController();
//   TextEditingController Post_controller = new TextEditingController();
//   TextEditingController Experience_controller = new TextEditingController();
//   TextEditingController License_controller = new TextEditingController();
//   TextEditingController Vehicle_controller = new TextEditingController();
//   TextEditingController Rc_no_controller = new TextEditingController();
//   String uphoto="";
//   String ulic="";
//   String uvehicle="";
//   String astatus="";
//
//   a(){
//     setState(() {
//       Name_controller.text=widget.name;
//       Age_controller.text=widget.age;
//       Mobile_no_controller.text=widget.mobileno;
//       Email_controller.text=widget.email;
//       uphoto=widget.photo;
//       uvehicle=widget.vehiclephoto;
//       Place_controller.text=widget.place;
//       Pin_controller.text=widget.pin;
//       Post_controller.text=widget.post;
//       Experience_controller.text=widget.experience;
//       ulic=widget.license;
//       Vehicle_controller.text=widget.vehicle;
//       Rc_no_controller.text=widget.rcno;
//       astatus=widget.astatus;
//     });
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     a();
//     super.initState();
//   }
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
//         child: SingleChildScrollView(
//           child: Column(
//
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   if (_selectedImage != null) ...{
//                     InkWell(
//                       child:
//                       Image.file(_selectedImage!, height: 200,width: 200),
//                       radius: 399,
//                       onTap: _checkPermissionAndChooseImage,
//                       // borderRadius: BorderRadius.all(Radius.circular(200)),
//                     ),
//                   } else ...{
//                     // Image(image: NetworkImage(),height: 100, width: 70,fit: BoxFit.cover,),
//                     InkWell(
//                       onTap: _checkPermissionAndChooseImage,
//                       child:Column(
//                         children: [
//                           Image(image: NetworkImage(uphoto),height: 200,width: 200,),
//                           Text('Select Image',style: TextStyle(color: Colors.cyan))
//                         ],
//                       ),
//                     ),
//                   },
//                   if (_selectedImage1 != null) ...{
//                     InkWell(
//                       child:
//                       Image.file(_selectedImage1!, height: 200,width: 200),
//                       radius: 399,
//                       onTap: _checkPermissionAndChooseImage1,
//                       // borderRadius: BorderRadius.all(Radius.circular(200)),
//                     ),
//                   } else ...{
//                     // Image(image: NetworkImage(),height: 100, width: 70,fit: BoxFit.cover,),
//                     InkWell(
//                       onTap: _checkPermissionAndChooseImage1,
//                       child:Column(
//                         children: [
//                           Image(image: NetworkImage(ulic),height: 200,width: 200,),
//                           Text('Select proof',style: TextStyle(color: Colors.cyan))
//                         ],
//                       ),
//                     ),
//
//                   },
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   if (_selectedImage2 != null) ...{
//                     InkWell(
//                       child:
//                       Image.file(_selectedImage2!, height: 200,width: 200),
//                       radius: 399,
//                       onTap: _checkPermissionAndChooseImage2,
//                       // borderRadius: BorderRadius.all(Radius.circular(200)),
//                     ),
//                   } else ...{
//                     // Image(image: NetworkImage(),height: 100, width: 70,fit: BoxFit.cover,),
//                     InkWell(
//                       onTap: _checkPermissionAndChooseImage2,
//                       child:Column(
//                         children: [
//                           Image(image: NetworkImage(uvehicle),height: 200,width: 200,),
//                           Text('Select Vehcile Photo',style: TextStyle(color: Colors.cyan))
//                         ],
//                       ),
//                     ),
//                   },
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: Name_controller,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Name")),),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: Age_controller,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Age")),),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: Mobile_no_controller,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Mobile_no")),),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: Email_controller,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Email")),),
//               ),
//               // Padding(
//               //   padding: const EdgeInsets.all(8.0),
//               //   child: TextField(
//               //     controller: Photo_controller,
//               //     decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Photo")),),
//               // ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: Place_controller,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Place")),),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: Pin_controller,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Pin")),),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: Post_controller,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Post")),),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: Experience_controller,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Experience")),),
//               ),
//               // Padding(
//               //   padding: const EdgeInsets.all(8.0),
//               //   child: TextField(
//               //     controller: License_controller,
//               //     decoration: InputDecoration(border: OutlineInputBorder(),label: Text("License")),),
//               // ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: Vehicle_controller,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Vehicle")),),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: Rc_no_controller,
//                   decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Rc_no")),),
//               ),
//               RadioListTile(value: "Active", groupValue: astatus, onChanged: (value){setState(() {astatus="Active";});},title: Text("Active")),
//               RadioListTile(value: "In work", groupValue: astatus, onChanged: (value){setState(() {astatus="In work";});},title: Text("In work")),
//
//               ElevatedButton(onPressed: (){
//                 senddata();
//               }, child: Text('Update'))
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
//   senddata() async {
//     String name=Name_controller.text;
//     String age=Age_controller.text;
//     String mobileno=Mobile_no_controller.text;
//     String email=Email_controller.text;
//     // String photo=Photo_controller.text;
//     String place=Place_controller.text;
//     String pin=Pin_controller.text;
//     String post=Post_controller.text;
//     String experience=Experience_controller.text;
//     // String license=License_controller.text;
//     String vehicle=Vehicle_controller.text;
//     String rcno=Rc_no_controller.text;
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//
//
//     final urls = Uri.parse('$url/d_update_profile/');
//     try {
//       final response = await http.post(urls, body: {
//         'name':name,
//         'age':age,
//         'mobileno':mobileno,
//         'email':email,
//         'photo':photo,
//         'vehiclephoto':vehicle_photo,
//         'place':place,
//         'pin':pin,
//         'post':post,
//         'experience':experience,
//         'license':license,
//         'vehicle':vehicle,
//         'rcno':rcno,
//         'lid':lid,
//         'active_status':astatus,
//
//
//
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status=='ok') {
//           Fluttertoast.showToast(msg: ' Updated Successfully');
//           Navigator.push(context, MaterialPageRoute(builder: (context) => view_profile(title: 'home',),));
//
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
//   File? _selectedImage;
//   String? _encodedImage;
//   Future<void> _chooseAndUploadImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//         _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
//         photo = _encodedImage.toString();
//       });
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage() async {
//     final PermissionStatus status = await Permission.mediaLibrary.request();
//     if (status.isGranted) {
//       _chooseAndUploadImage();
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: const Text('Permission Denied'),
//           content: const Text(
//             'Please go to app settings and grant permission to choose an image.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   String photo = '';
//
//   File? _selectedImage1;
//   String? _encodedImage1;
//   Future<void> _chooseAndUploadImage1() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage1 = File(pickedImage.path);
//         _encodedImage1 = base64Encode(_selectedImage1!.readAsBytesSync());
//         license = _encodedImage1.toString();
//       });
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage1() async {
//     final PermissionStatus status = await Permission.mediaLibrary.request();
//     if (status.isGranted) {
//       _chooseAndUploadImage1();
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: const Text('Permission Denied'),
//           content: const Text(
//             'Please go to app settings and grant permission to choose an image.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   String license = '';
//
//   File? _selectedImage2;
//   String? _encodedImage2;
//   Future<void> _chooseAndUploadImage2() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage2 = File(pickedImage.path);
//         _encodedImage2 = base64Encode(_selectedImage2!.readAsBytesSync());
//         vehicle_photo = _encodedImage2.toString();
//       });
//     }
//   }
//
//   Future<void> _checkPermissionAndChooseImage2() async {
//     final PermissionStatus status = await Permission.mediaLibrary.request();
//     if (status.isGranted) {
//       _chooseAndUploadImage2();
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           title: const Text('Permission Denied'),
//           content: const Text(
//             'Please go to app settings and grant permission to choose an image.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   String vehicle_photo = '';
//
// }
//
//
//
//

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:public_transportation/driver/driverhome.dart';
import 'package:public_transportation/driver/view_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class update_profile extends StatefulWidget {
  const update_profile({
    super.key,
    required this.title,
    required this.name,
    required this.age,
    required this.mobileno,
    required this.email,
    required this.photo,
    required this.vehiclephoto,
    required this.place,
    required this.pin,
    required this.post,
    required this.experience,
    required this.vehicle,
    required this.license,
    required this.rcno,
    required this.astatus,
    required this.f_amount,
  });

  final String title;
  final String name;
  final String age;
  final String mobileno;
  final String email;
  final String photo;
  final String vehiclephoto;
  final String place;
  final String pin;
  final String post;
  final String experience;
  final String vehicle;
  final String license;
  final String rcno;
  final String astatus;
  final String f_amount;

  @override
  State<update_profile> createState() => _update_profileState();
}

class _update_profileState extends State<update_profile> {
  TextEditingController Name_controller = TextEditingController();
  TextEditingController Age_controller = TextEditingController();
  TextEditingController Mobile_no_controller = TextEditingController();
  TextEditingController Email_controller = TextEditingController();
  TextEditingController Photo_controller = TextEditingController();
  TextEditingController Vehicle_Photo_controller = TextEditingController();
  TextEditingController Place_controller = TextEditingController();
  TextEditingController Pin_controller = TextEditingController();
  TextEditingController Post_controller = TextEditingController();
  TextEditingController Experience_controller = TextEditingController();
  TextEditingController License_controller = TextEditingController();
  TextEditingController Vehicle_controller = TextEditingController();
  TextEditingController Rc_no_controller = TextEditingController();
  TextEditingController fAmountController = TextEditingController();

  String uphoto = "";
  String ulic = "";
  String uvehicle = "";
  String astatus = "";
  String f_amount = "";
  String photo = '';
  String license = '';
  String vehicle_photo = '';

  File? _selectedImage;
  File? _selectedImage1;
  File? _selectedImage2;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    a();
    super.initState();
  }

  a() {
    setState(() {
      Name_controller.text = widget.name;
      Age_controller.text = widget.age;
      Mobile_no_controller.text = widget.mobileno;
      Email_controller.text = widget.email;
      uphoto = widget.photo;
      uvehicle = widget.vehiclephoto;
      Place_controller.text = widget.place;
      Pin_controller.text = widget.pin;
      Post_controller.text = widget.post;
      Experience_controller.text = widget.experience;
      ulic = widget.license;
      Vehicle_controller.text = widget.vehicle;
      Rc_no_controller.text = widget.rcno;
      astatus = widget.astatus;
      fAmountController.text = widget.f_amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Images Section
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Upload Documents',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildImageSelector(_selectedImage, uphoto, "Driver Photo", _checkPermissionAndChooseImage),
                        _buildImageSelector(_selectedImage1, ulic, "License Proof", _checkPermissionAndChooseImage1),
                        _buildImageSelector(_selectedImage2, uvehicle, "Vehicle Photo", _checkPermissionAndChooseImage2),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Personal Information Section
            _buildSectionCard(
              title: 'Personal Information',
              children: [
                _buildInputField(Icons.person, "Name", Name_controller),
                _buildInputField(Icons.calendar_today, "Age", Age_controller, keyboardType: TextInputType.number),
                _buildInputField(Icons.phone, "Mobile No", Mobile_no_controller, keyboardType: TextInputType.phone),
                _buildInputField(Icons.email, "Email", Email_controller, keyboardType: TextInputType.emailAddress),
              ],
            ),

            // Address Information Section
            _buildSectionCard(
              title: 'Address Information',
              children: [
                _buildInputField(Icons.location_city, "Place", Place_controller),
                _buildInputField(Icons.pin_drop, "PIN Code", Pin_controller, keyboardType: TextInputType.number),
                _buildInputField(Icons.map, "Post Office", Post_controller),
              ],
            ),

            // Driver Information Section
            _buildSectionCard(
              title: 'Driver Information',
              children: [
                _buildInputField(Icons.work, "Experience", Experience_controller, keyboardType: TextInputType.number),
                _buildInputField(Icons.directions_car, "Vehicle", Vehicle_controller),
                _buildInputField(Icons.confirmation_number, "RC No", Rc_no_controller),
                _buildInputField(Icons.money_rounded, "Km Amount", fAmountController),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            //   child: TextFormField(
            //     controller: fAmountController,
            //     keyboardType: TextInputType.number,
            //     decoration: InputDecoration(
            //       labelText: 'Km Amount',
            //       prefixIcon: Icon(Icons.attach_money),
            //       border: OutlineInputBorder(),
            //     ),
            //   ),
            // ),


            // Status Section
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Driver Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: "Active",
                            groupValue: astatus,
                            onChanged: (value) {
                              setState(() {
                                astatus = "Active";
                              });
                            },
                            title: Text("Active"),
                            activeColor: Colors.deepPurple,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: "In work",
                            groupValue: astatus,
                            onChanged: (value) {
                              setState(() {
                                astatus = "In work";
                              });
                            },
                            title: Text("In work"),
                            activeColor: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Update Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                ),
                onPressed: senddata,
                child: Text(
                  'UPDATE PROFILE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildImageSelector(File? selectedImage, String networkImage, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.5)),
            ),
            child: selectedImage != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(selectedImage, fit: BoxFit.cover),
            )
                : networkImage.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(networkImage, fit: BoxFit.cover),
            )
                : Icon(Icons.add_a_photo, size: 30, color: Colors.deepPurple),
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.deepPurple),
        ),
      ],
    );
  }

  Widget _buildInputField(IconData icon, String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  // All your original functions remain unchanged below this point
  senddata() async {
    String name = Name_controller.text;
    String age = Age_controller.text;
    String mobileno = Mobile_no_controller.text;
    String email = Email_controller.text;
    String place = Place_controller.text;
    String pin = Pin_controller.text;
    String post = Post_controller.text;
    String experience = Experience_controller.text;
    String vehicle = Vehicle_controller.text;
    String rcno = Rc_no_controller.text;
    String f_amount = fAmountController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/d_update_profile/');
    try {
      final response = await http.post(urls, body: {
        'name': name,
        'age': age,
        'mobileno': mobileno,
        'email': email,
        'photo': photo,
        'vehiclephoto': vehicle_photo,
        'place': place,
        'pin': pin,
        'post': post,
        'experience': experience,
        'license': license,
        'vehicle': vehicle,
        'rcno': rcno,
        'lid': lid,
        'active_status': astatus,
        'f_amount': f_amount,

      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(
            msg: 'Updated Successfully',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => view_profile(title: 'Profile'),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Update Failed',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Network Error',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _chooseAndUploadImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        photo = base64Encode(_selectedImage!.readAsBytesSync());
      });
    }
  }

  Future<void> _checkPermissionAndChooseImage() async {
    final PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseAndUploadImage();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Please go to app settings and grant permission to choose an image.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _chooseAndUploadImage1() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage1 = File(pickedImage.path);
        license = base64Encode(_selectedImage1!.readAsBytesSync());
      });
    }
  }

  Future<void> _checkPermissionAndChooseImage1() async {
    final PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseAndUploadImage1();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Please go to app settings and grant permission to choose an image.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _chooseAndUploadImage2() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage2 = File(pickedImage.path);
        vehicle_photo = base64Encode(_selectedImage2!.readAsBytesSync());
      });
    }
  }

  Future<void> _checkPermissionAndChooseImage2() async {
    final PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseAndUploadImage2();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Please go to app settings and grant permission to choose an image.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}