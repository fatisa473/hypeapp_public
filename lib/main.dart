import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';
import 'package:hypeapp/routes/routes.dart';
import 'package:get/get.dart';

void main() async {
  await GetStorage.init();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    navigatorKey: Get.key,
    getPages: routes(),
  ));
}
