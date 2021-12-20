//import 'dart:html';

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/view/bottom_view/bottom_view.dart';
import 'package:ebookapp/view/register/ebook_register.dart';
import 'package:ebookapp/widget/common_pref.dart';
import 'package:ebookapp/widget/ebook_routers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EbookLogin extends StatefulWidget {
  @override
  _EbookLoginState createState() => _EbookLoginState();
}

class _EbookLoginState extends State<EbookLogin> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool visibleLoading = false;

  Future login(
      {required TextEditingController email,
      required TextEditingController password,
      required BuildContext context,
      required Widget widget}) async {
    String getEmail = email.text;
    String getPassword = password.text;

    setState(() {
      visibleLoading = true;
    });

    var data = {'email': getEmail, 'password': getPassword};
    var req = await Dio()
        .post(ApiConstant().baseUrl + ApiConstant().login, data: data);

    var decode = jsonDecode(req.data);

    if (decode[4] == "Successfully login") {
      setState(() {
        visibleLoading = false;
      });
      //this is shared prefrence to save data
      saveLogin(id: decode[0], name: decode[1], email: decode[2], photo: '');
      pushAndRemove(context, BottomView());
    } else {
      setState(() {
        visibleLoading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Please double check your email or password',
                style: TextStyle(color: Colors.blue),
              ),
              actions: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text('Okay'),
                )
              ],
            );
          });
      // pushAndRemove(context, BottomView());

    }
  }

  @override
  void initState() {
    super.initState();
    loadLogin().then((value) {
      setState(() {
        if (value != null) {
          pushAndRemove(context, BottomView());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 90),
        child: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/image/login.png',
                  width: 125,
                  height: 125,
                ),
                Text(
                  'Hello, Welcome back !',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Container(
                  margin:
                      EdgeInsets.only(right: 20, left: 20, bottom: 5, top: 7.h),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: email,
                    decoration: InputDecoration(
                        hintText: 'Enetr your email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.black,
                        ),
                        filled: true,
                        isDense: true,
                        fillColor: Colors.white54,
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
                  margin:
                      EdgeInsets.only(right: 20, left: 20, bottom: 5, top: 17),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: password,
                    obscureText: true,
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: 'Enetr your password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.black,
                        ),
                        filled: true,
                        isDense: true,
                        fillColor: Colors.white54,
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
                    login(
                        email: email,
                        password: password,
                        context: context,
                        widget: widget);
                  },
                  child: Container(
                      margin: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 5, top: 17),
                      padding: EdgeInsets.only(
                          top: 1.2.h, bottom: 1.2.h, right: 1.5.w, left: 1.5.w),
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: MediaQuery.of(context).size.width,
                      child: !visibleLoading
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
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
                    margin: EdgeInsets.only(
                        right: 20, left: 20, bottom: 5, top: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Dont have an Account?',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EbookRegister()),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.blue, fontSize: 17),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
