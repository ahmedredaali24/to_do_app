import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppConfigProvider extends ChangeNotifier {
  //data
  String appLanguage = "en";
  ThemeMode appTheme = ThemeMode.light;

  void changeLanguage(String newLanguage) async {
    if (appLanguage == newLanguage) {
      return;
    }
    appLanguage = newLanguage;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", newLanguage);
    notifyListeners();
  }

  void changThemeMode(ThemeMode newMode) async {
    if (appTheme == newMode) {
      return;
    }
    appTheme = newMode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("mode", newMode.name);
    notifyListeners();
  }

  bool isDarkMode() {
    return appTheme == ThemeMode.dark;
  }

  getSaveDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('language');
    if (lang == "en") {
      appLanguage = "en";
    } else {
      appLanguage = "ar";
    }

    String? mode = prefs.getString('mode');
    if (mode == "dark") {
      appTheme = ThemeMode.dark;
    } else {
      appTheme = ThemeMode.light;
    }
    notifyListeners();
  }
}
