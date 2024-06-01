import 'package:comprehenzone_mobile/screens/home_screen.dart';
import 'package:comprehenzone_mobile/screens/login_screen.dart';
import 'package:comprehenzone_mobile/screens/register_screen.dart';
import 'package:flutter/material.dart';

class NavigatorRoutes {
  static const login = 'login';
  static const register = 'register';
  static const home = 'home';
}

final Map<String, WidgetBuilder> routes = {
  NavigatorRoutes.login: (context) => const LoginScreen(),
  NavigatorRoutes.register: (context) => const RegisterScreen(),
  NavigatorRoutes.home: (context) => const HomeScreen()
};
