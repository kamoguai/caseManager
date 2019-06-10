
import 'package:case_manager/page/HomePage.dart';
import 'package:case_manager/page/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 導航欄
 * Date: 2019-06-04
 */
class NavigatorUtils {
  ///替換
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  ///切換無參數頁面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
  ///一般跳轉頁面
  static NavigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(context, new CupertinoPageRoute(builder: (context) => widget));
  }
  ///跳轉至頁面並移除上一頁
  static NavigatorRemoveRouter(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(context, new CupertinoPageRoute(builder: (context) => widget), null);
  }
  ///登入頁
  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.sName);
  }
  ///跳回登入頁
  static goTopLogin(BuildContext context) {
    NavigatorRemoveRouter(context, LoginPage());
  }
  ///首頁
  ///pushReplacementNamed需要由main.dart做導航
  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.sName);
  }
}