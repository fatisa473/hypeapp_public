import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static Future initializeApp() async {
    //Push notifictions
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print(token);
    //
  }

  Future pruebaEnvio() async {
    await http.post(
        Uri.parse("https://hypeapp1.herokuapp.com/notificaciones.php"),
        body: {"token": token});
  }
}
