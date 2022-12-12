import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;

  switchMode() async {
    // print("SWITCH MODE");
    isDark = !isDark;
    getMode();
    setMode(isDark);
    notifyListeners();
  }

  getMode() async {
    // print("GET MODE");

    final prefs = await SharedPreferences.getInstance();
    bool? val = prefs.getBool('isDark');
    if (val != null) {
      isDark = val;
      notifyListeners();
    } else {
      isDark = false;
      notifyListeners();
    }
  }

  setMode(bool mode) async {
    // print("SET MODE");

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', mode);
    isDark = mode;
    notifyListeners();
  }
}
