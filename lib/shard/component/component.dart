import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social/shard/styles/icon_broken.dart';

import '../../modules/login/login_screen.dart';
import '../network/local/cache_helper.dart';

Widget defaultButton({
  Color color = Colors.blue,
  double width = double.infinity,
  Function? function,
  double height = 55,
  required String text,
}) =>
    Container(
      width: width,
      height: height,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        onPressed: () => function!(),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
void showToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARING:
      color = Colors.amber;
  }
  return color;
}

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (Route<dynamic> route) => false);

void signOut(context) {
  CacheHelper.removeData("uId").then((value) {
    if (value) {
      navigateAndFinish(context, SocialLoginScreen());
    }
  });
}

Widget defaultTextField({
  bool isPassword = false,
  required TextInputType? type,
  required TextEditingController? control,
  required String label,
  IconData? prefix,
  Function? suffixButtonPressed,
  IconData? suffix,
  onSubmitted,
  onTap,
  bool isClickable = true,
  Function? validator,
  onchange,
  required bool isBorder,
}) =>
    SizedBox(
      height: 60,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        obscureText: isPassword,
        keyboardType: type,
        controller: control,
        onFieldSubmitted: onSubmitted,
        onTap: onTap,
        validator: (value) {
          return validator!(value);
        },
        enabled: isClickable,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 52,
            ),
            prefixIconConstraints:
                const BoxConstraints(maxHeight: 20, minWidth: 50),
            labelText: label,
            prefixIcon: Icon(prefix),
            border: const OutlineInputBorder(),
            suffix: IconButton(
              onPressed: () {
                suffixButtonPressed!();
              },
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Icon(
                  suffix,
                  size: 20,
                ),
              ),
            )),
        onChanged: onchange,
      ),
    );
AppBar defaultAppBar(
        {required BuildContext context,
        required String title,
        List<Widget>? actions}) =>
    AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(IconBroken.Arrow___Left_2),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      actions: actions,
    );

TextButton buildTextButton({
  required BuildContext context,
  required String title,
  required Function function,
}) {
  return TextButton(
      onPressed: () {
        function();
      },
      child: Text(title));
}
