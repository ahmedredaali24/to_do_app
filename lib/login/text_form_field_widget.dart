import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/mt_theme.dart';
import '../providers/app_config_provider.dart';

typedef MyValidator = String? Function(String?);

class TextFormFieldWidgets extends StatelessWidget {
  String label;
  TextInputType keyboardType;
  TextEditingController controller;
  bool obscureText;

  // String? Function(String?) validator;
  MyValidator validator;

  TextFormFieldWidgets({required this.label,
    this.keyboardType = TextInputType.text,
    required this.controller,
    required this.validator, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        style: TextStyle(color: provider.isDarkMode() ?
        MyTheme.whiteColor :
        Colors.black,),
        decoration: InputDecoration(

          label: Text(label, style: TextStyle(color: provider.isDarkMode() ?
          MyTheme.whiteColor :
          MyTheme.backGroundDarkColor,),),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: MyTheme.primaryColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: MyTheme.primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: MyTheme.redColor, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: MyTheme.redColor, width: 2),
          ),
        ),

        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        obscureText:obscureText,
      ),
    );
  }
}
