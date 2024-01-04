// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/model/notification_info.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController implements GetxService {
  NotificationInfo? notificationInfo;
  bool isLoading = false;
  getNotificationData() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
      };
      Uri uri = Uri.parse(Config.path + Config.notification);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        notificationInfo = NotificationInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
