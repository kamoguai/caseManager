

import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
/**
 * 詳情頁面裡面得 code word dialog
 * Date: 2019-06-17
 */
class CWDialog extends StatelessWidget with BaseWidget{

  final CWViewModel defaultViewModel;
  final Map<String,dynamic> data;
  CWDialog({this.defaultViewModel, this.data});

  @override
  deviceWidth7(BuildContext context) {
    
    return super.deviceWidth7(context) - 2;
  }

  @override
  Widget build(BuildContext context) {
   
    return Container(
      color: Color(MyColors.hexFromStr('#ffeef1')),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(width: deviceWidth7(context) - 1,),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2) - 1,
                  child: autoTextSize('正常', TextStyle(color: Colors.blue), context),
                ),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2) - 1,
                  child: autoTextSize('校正', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2),
                  child: autoTextSize('掉包', TextStyle(color: Colors.red), context),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(width: deviceWidth7(context) - 1, child: autoTextSize('U0', TextStyle(color: Colors.black), context),),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2) - 1,
                  child: autoTextSize(defaultViewModel.g0, TextStyle(color: Colors.blue), context),
                ),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2) - 1,
                  child: autoTextSize(defaultViewModel.c0, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2),
                  child: autoTextSize(defaultViewModel.u0, TextStyle(color: Colors.red), context),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(width: deviceWidth7(context) - 1, child: autoTextSize('U1', TextStyle(color: Colors.black), context),),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2) - 1,
                  child: autoTextSize(defaultViewModel.g1, TextStyle(color: Colors.blue), context),
                ),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2) - 1,
                  child: autoTextSize(defaultViewModel.c1, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2),
                  child: autoTextSize(defaultViewModel.u1, TextStyle(color: Colors.red), context),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(width: deviceWidth7(context) - 1, child: autoTextSize('U2', TextStyle(color: Colors.black), context),),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2) - 1,
                  child: autoTextSize(defaultViewModel.g2, TextStyle(color: Colors.blue), context),
                ),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2) - 1,
                  child: autoTextSize(defaultViewModel.c2, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2),
                  child: autoTextSize(defaultViewModel.u2, TextStyle(color: Colors.red), context),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(width: deviceWidth7(context) - 1, child: autoTextSize('U3', TextStyle(color: Colors.black), context),),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2) - 1,
                  child: autoTextSize(defaultViewModel.g3, TextStyle(color: Colors.blue), context),
                ),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2) - 1,
                  child: autoTextSize(defaultViewModel.c3, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: (deviceWidth7(context) * 2),
                  child: autoTextSize(defaultViewModel.u3, TextStyle(color: Colors.red), context),
                ),
              ],
            ),
          ),
          Container(
            height: titleHeight(context),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Center(
              child: FlatButton(
                child: autoTextSize('離開', TextStyle(color: Colors.red), context),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CWViewModel {
  
  Map<String,dynamic> codeWordMap = new Map<String,dynamic>();
  Map<String,dynamic> u0Map = new Map<String,dynamic>();
  Map<String,dynamic> u1Map = new Map<String,dynamic>();
  Map<String,dynamic> u2Map = new Map<String,dynamic>();
  Map<String,dynamic> u3Map = new Map<String,dynamic>();
  String g0;
  String u0;
  String c0;
  String g1;
  String u1;
  String c1;
  String g2;
  String u2;
  String c2;
  String g3;
  String u3;
  String c3;

  CWViewModel();

  CWViewModel.forMap(data) {
    u0Map = data["U0"] == null ? null : data["U0"];
    u1Map = data["U1"] == null ? null : data["U1"];
    u2Map = data["U2"] == null ? null : data["U2"];
    u3Map = data["U3"] == null ? null : data["U3"];
    g0 = u0Map["G"] == null ? "" : u0Map["G"];
    u0 = u0Map["U"] == null ? "" : u0Map["U"];
    c0 = u0Map["C"] == null ? "" : u0Map["C"];
    g1 = u1Map["G"] == null ? "" : u1Map["G"];
    u1 = u1Map["U"] == null ? "" : u1Map["U"];
    c1 = u1Map["C"] == null ? "" : u1Map["C"];
    g2 = u2Map["G"] == null ? "" : u2Map["G"];
    u2 = u2Map["U"] == null ? "" : u2Map["U"];
    c2 = u2Map["C"] == null ? "" : u2Map["C"];
    g3 = u3Map["G"] == null ? "" : u3Map["G"];
    u3 = u3Map["U"] == null ? "" : u3Map["U"];
    c3 = u3Map["C"] == null ? "" : u3Map["C"];

    
  }
  CWViewModel.forDummy(data) {
    codeWordMap = null;
    u0Map = null;
    u1Map = null;
    u2Map = null;
    u3Map = null;
    g0 = "";
    u0 = "";
    c0 = "";
    g1 = "";
    u1 = "";
    c1 = "";
    g2 = "";
    u2 = "";
    c2 = "";
    g3 = "";
    u3 = "";
    c3 = "";
  }
}