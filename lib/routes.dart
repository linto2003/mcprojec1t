import 'package:flutter/material.dart';
import 'package:mcproj/auth/logIn.dart';
import 'package:mcproj/auth/signUp.dart';
import 'package:mcproj/pages/home.dart';

Route getRoutes({required RouteSettings routeSettings}) {
  switch (routeSettings.name) {
    case LoginPage.route:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) {
            return LoginPage();
          });

    case SignupPage.route:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) {
            return SignupPage();
          });

    case HomePage.route:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) {
            return HomePage();
          });

    default:
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          body: Center(
            child: Text('Route does\'nt exist'),
          ),
        );
      });
  }
}
