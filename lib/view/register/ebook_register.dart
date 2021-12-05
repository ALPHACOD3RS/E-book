//import 'dart:html';
import 'dart:io';

import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/view/login/ebook_login.dart';
import 'package:ebookapp/view/login/ebook_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class EbookRegister extends StatefulWidget {
  @override
  _EbookRegisterState createState() => _EbookRegisterState();
}

class _EbookRegisterState extends State<EbookRegister> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  File _file = File('');
  final picker = ImagePicker();
  bool visibleLoading = false;

  Future register(
      {required TextEditingController name,
      required TextEditingController email,
      required TextEditingController password,
      required BuildContext context,
      required Widget widget}) async {
    setState(() {
      visibleLoading = true;
    });

    String getName = name.text;
    String getEmail = email.text;
    String getPassword = password.text;

    var req = http.MultipartRequest(
        'POST', Uri.parse(ApiConstant().baseUrl + ApiConstant().register));
    var photo = await http.MultipartFile.fromPath('photo', _file.path);
    req.fields['name'] = getName;
    req.fields['email'] = getEmail;
    req.fields['password'] = getPassword;
    req.files.add(photo);

    var response = await req.send();

    if (response.statusCode == 200) {
      setState(() {
        visibleLoading = false;
      });
      //add back to login page
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EbookLogin()));
    } else {
      setState(() {
        visibleLoading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Nae or Email already on Database',
                style: TextStyle(color: Colors.blue),
              ),
              actions: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text('okay'),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 17.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Create Your Account Right Now!',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              SizedBox(
                height: 3.h,
              ),
              GestureDetector(
                onTap: () {
                  imagePicker(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      right: 20, left: 20, bottom: 10, top: 2.h),
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _file.path == ''
                          ? Image.asset(
                              'assets/image/noimage.jpg',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _file,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            )),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 20, left: 20, bottom: 5, top: 3.h),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: name,
                  decoration: InputDecoration(
                      hintText: 'Enter your name',
                      prefixIcon: Icon(
                        Icons.account_circle_outlined,
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.white70,
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20, bottom: 5, top: 5),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: email,
                  decoration: InputDecoration(
                      hintText: 'Enter your Email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.white70,
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20, bottom: 5, top: 5),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  autofocus: false,
                  controller: password,
                  decoration: InputDecoration(
                      hintText: 'Enter your Password',
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.white70,
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_file.path != "") {
                    if (name.text != "") {
                      if (email.text != "") {
                        if (password.text != "") {
                          register(
                              name: name,
                              email: email,
                              password: password,
                              context: context,
                              widget: widget);
                        } else {
                          msgError('No Password', 'Please enter your password');
                        }
                      } else {
                        msgError('No Email', 'Please enter your email');
                      }
                    } else {
                      msgError('No Name', 'Please enter your Name');
                    }
                  } else {
                    msgError('No Photo', 'Please choose your photo');
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(
                        right: 20, left: 20, bottom: 5, top: 17),
                    padding: EdgeInsets.only(
                        top: 1.2.h, bottom: 1.2.h, right: 1.5.w, left: 1.5.w),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: MediaQuery.of(context).size.width,
                    child: !visibleLoading
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              'Create Account',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Visibility(
                            visible: visibleLoading,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Container(
                                  width: 19,
                                  height: 19,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin:
                      EdgeInsets.only(right: 20, left: 20, bottom: 5, top: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an Account?',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.blue, fontSize: 17),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  imageFromGallery() async {
    var imgFromGallery = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 100,
        maxWidth: 100);
    setState(() {
      if (imgFromGallery != null) {
        _file = File(imgFromGallery.path);
      } else {
        print("This file don't have any data");
      }
    });
  }

  imageFromCamera() async {
    var imageFromCamera = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 100,
        maxWidth: 100);
    setState(() {
      if (imageFromCamera != null) {
        _file = File(imageFromCamera.path);
      } else {
        print("This file don't have any data");
      }
    });
  }

  void imagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.library_add,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Sellect photo fro Gallery',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    imageFromGallery();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Photo from camera',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    imageFromCamera();
                  },
                )
              ],
            ),
          );
        });
  }

  Future msgError(String title, String description) {
    return Alert(
        context: context,
        type: AlertType.success,
        onWillPopActive: true,
        title: '$title',
        desc: '$description',
        style: AlertStyle(
            animationType: AnimationType.fromBottom,
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black),
            descStyle: TextStyle(color: Colors.black54)),
        buttons: [
          DialogButton(
            padding: EdgeInsets.all(1),
            child: Container(
              height: 45,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 0.7)),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ]).show();
  }
}
