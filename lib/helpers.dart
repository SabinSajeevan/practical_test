import 'dart:math';
import 'dart:ui';

import 'package:http/http.dart' as http;

class Helpers {
  Future<String> fetchCustomers(url) async {
    String result = "";
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        result = response.body;
      }
      return result;
    } catch (e) {
      return e.toString();
    }
  }

  Color randomColor(index) {
    List<Color> colorsList = [
      Color(0xff097054),
      Color(0xffFF9900),
      Color(0xff217C7E),
      Color(0xff9A3334),
      Color(0xff666699)
    ];
    int colorIndex = index;
    if (index > 4) {
      colorIndex = index % 5;
    }
    return colorsList[colorIndex];
  }
}
