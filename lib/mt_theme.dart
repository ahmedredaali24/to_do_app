import 'package:flutter/material.dart';

class MyTheme {
  static Color primaryColor = const Color(0xff5D9CEC);
  static Color whiteColor = const Color(0xffFFFFFF);
  static Color blackColor = const Color(0xff383838);
  static Color greenColor = const Color(0xff61E757);
  static Color redColor = const Color(0xffEC4B4B);
  static Color grayColor = const Color(0xff707070);
  static Color backGroundLightColor = const Color(0xffDFECDB);
  static Color backGroundDarkColor = const Color(0xff060E1E);
  static Color blackDarkColor = const Color(0xff141922);

  static ThemeData lightTheme = ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backGroundLightColor,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      textTheme: TextTheme(
        titleSmall: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: blackColor),
        titleMedium: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: blackColor),
        titleLarge: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: whiteColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          unselectedItemColor: grayColor,
          backgroundColor: Colors.transparent,
          elevation: 0
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          shape: StadiumBorder(
            side: BorderSide(color: whiteColor, width: 3),

            //       RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(40),
            //     side: BorderSide(color: whiteColor,width: 5)
            // )
          )),
      bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: primaryColor, width: 4))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))));

  static ThemeData darkMode = ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backGroundDarkColor,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      textTheme: TextTheme(
        titleSmall: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: whiteColor),
        titleMedium: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: whiteColor),
        titleLarge: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: blackColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          unselectedItemColor: grayColor,
          backgroundColor: Colors.transparent,
          elevation: 0),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          shape: StadiumBorder(
            side: BorderSide(color: blackColor, width: 3),

            //       RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(40),
            //     side: BorderSide(color: whiteColor,width: 5)
            // )
          )),
      bottomSheetTheme: BottomSheetThemeData(

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: primaryColor, width: 4))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))));
}
