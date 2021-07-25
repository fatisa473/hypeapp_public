import 'package:get/route_manager.dart';
//
import 'package:hypeapp/views/login.dart';
import 'package:hypeapp/views/organizer.dart';
import 'package:hypeapp/views/home.dart';
import 'package:hypeapp/views/signup.dart';
import 'package:hypeapp/views/supplier.dart';
//

routes() => [
      GetPage(name: "/home", page: () => HomePage()),
      GetPage(name: "/login", page: () => LoginPage()),
      GetPage(name: "/registro", page: () => SignupPage()),
      GetPage(name: "/supplier", page: () => SupplierPage()),
      GetPage(name: "/organizer", page: () => OrganizerPage()),
    ];
