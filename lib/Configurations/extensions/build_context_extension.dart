import 'package:flutter/material.dart';

extension NavigationContext on BuildContext {
  get pop => Navigator.pop(this);

  void pushNamed<ARG>(String routeName, {dynamic arguments}) =>
      Navigator.pushNamed(this, routeName, arguments: arguments);

  void pushReplacementNamed<ARG>(String routeName) =>
      Navigator.pushReplacementNamed(this, routeName);

  void pushNamedAndRemoveUntil<ARG>(String routeName,{dynamic arguments}) =>
      Navigator.pushNamedAndRemoveUntil(this, routeName, (route) => false,arguments: arguments);

  void pushTo(Widget widget) =>
      Navigator.push(this, MaterialPageRoute(builder: (context) => Scaffold(body: widget)));
}
