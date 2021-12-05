import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void pushPage(BuildContext context, Widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Widget));
}

void pushAndRemove(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false);
}
