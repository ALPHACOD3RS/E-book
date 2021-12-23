import 'dart:ffi';
import 'dart:io';

import 'package:ebookapp/view/bottom_view/bottom_view.dart';
import 'package:ebookapp/view/bottom_view/home.dart';
import 'package:ebookapp/view/login/ebook_login.dart';
import 'package:ebookapp/view/register/ebook_register.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter app',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: EbookLogin());
      },
    );
  }
}
