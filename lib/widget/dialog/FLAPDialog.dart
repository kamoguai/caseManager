
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:case_manager/common/style/MyStyle.dart';
/**
 * 詳情頁面裡面的 FLAP dialog
 * Date: 2019-06-17
 */
class FLAPDialog extends StatelessWidget with BaseWidget {
  final String custNo;
  final String custName;
  final Map<String,dynamic> data;
  final FlapViewModel defaultViewModel;
  final Function clearFlapFunc;
  FLAPDialog({this.custNo, this.custName, this.data, this.defaultViewModel, this.clearFlapFunc});

  @override
  deviceWidth2(context) {
    return super.deviceWidth2(context) - 4;
  }

  @override
  deviceWidth5(context) {
    return super.deviceWidth5(context) - 4;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(MyColors.hexFromStr('#fdfff7')),
      child: Column(
        children: <Widget>[
          Container(
            height: listHeight(context),
            padding: EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  child: autoTextSize('客編: ', TextStyle(color: Colors.black), context),
                ),
                Container(
                  child: autoTextSize(custNo, TextStyle(color: Colors.black), context),
                ),
                SizedBox(width: 10.0,),
                Container(
                  child: autoTextSize('姓名: ', TextStyle(color: Colors.black), context),
                ),
                Container(
                  child: autoTextSize(custName, TextStyle(color: Colors.black), context),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  width: deviceWidth5(context) - 1,
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize('U0', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize('U1', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize('U2', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context),
                  child: autoTextSize('U3', TextStyle(color: Colors.black), context),
                ),
                
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize('Ins', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u0I, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u1I, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u2I, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) ,
                  child: autoTextSize(defaultViewModel.u3I, TextStyle(color: Colors.black), context),
                ),
                
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize('Hit', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u0H, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u1H, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u2H, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) ,
                  child: autoTextSize(defaultViewModel.u3H, TextStyle(color: Colors.black), context),
                ),
                
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize('Miss', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u0M, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u1M, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u2M, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) ,
                  child: autoTextSize(defaultViewModel.u3M, TextStyle(color: Colors.black), context),
                ),
                
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize('CRC', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u0C, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u1C, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u2C, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) ,
                  child: autoTextSize(defaultViewModel.u3C, TextStyle(color: Colors.black), context),
                ),
                
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize('P-Adj', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u0P, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u1P, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u2P, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) ,
                  child: autoTextSize(defaultViewModel.u3P, TextStyle(color: Colors.black), context),
                ),
                
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize('Flap', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u0F, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u1F, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u2F, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) ,
                  child: autoTextSize(defaultViewModel.u3F, TextStyle(color: Colors.black), context),
                ),
                
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize('Time', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u0T, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u1T, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) - 1,
                  child: autoTextSize(defaultViewModel.u2T, TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth5(context) ,
                  child: autoTextSize(defaultViewModel.u3T, TextStyle(color: Colors.black), context),
                ),
               
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 5.0),
            height: listHeight(context),
            child: autoTextSize('清除記錄： ', TextStyle(color: Colors.black), context),
          ),
          buildLine(),
          Container(
            height: titleHeight(context),
            child: Row(
              children: <Widget>[
                Container(
                  width: deviceWidth2(context) - 1,
                  child: FlatButton(
                    textColor: Colors.red,
                    child: Text('清除', style: TextStyle(fontSize: MyScreen.appBarFontSize(context)),),
                    onPressed: (){
                      clearFlapFunc();
                    },
                  ),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth2(context),
                  child: FlatButton(
                    textColor: Colors.black,
                    child: Text('離開', style: TextStyle(fontSize: MyScreen.appBarFontSize(context)),),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
            
          )
        ],
      ),
    );
  }
}

class FlapViewModel {
  Map<String,dynamic> uMap = new Map<String,dynamic>();
  String u0I;
  String u0H;
  String u0M;
  String u0C;
  String u0P;
  String u0F;
  String u0T;
  String u0Line;
  String u1I;
  String u1H;
  String u1M;
  String u1C;
  String u1P;
  String u1F;
  String u1T;
  String u1Line;
  String u2I;
  String u2H;
  String u2M;
  String u2C;
  String u2P;
  String u2F;
  String u2T;
  String u2Line;
  String u3I;
  String u3H;
  String u3M;
  String u3C;
  String u3P;
  String u3F;
  String u3T;
  String u3Line;

  FlapViewModel();

  FlapViewModel.forMap(data) {
    uMap = data["U0"] == null ? null : data["U0"];
    u0I = uMap["I"] == null ? "" : uMap["I"];
    u0H = uMap["H"] == null ? "" : uMap["H"];
    u0M = uMap["M"] == null ? "" : uMap["M"];
    u0C = uMap["C"] == null ? "" : uMap["C"];
    u0P = uMap["P"] == null ? "" : uMap["P"];
    u0F = uMap["F"] == null ? "" : uMap["F"];
    u0T = uMap["T"] == null ? "" : uMap["T"];
    u0Line = uMap["LINE"];
    uMap = data["U1"] == null ? null : data["U1"];
    u1I = uMap["I"] == null ? "" : uMap["I"];
    u1H = uMap["H"] == null ? "" : uMap["H"];
    u1M = uMap["M"] == null ? "" : uMap["M"];
    u1C = uMap["C"] == null ? "" : uMap["C"];
    u1P = uMap["P"] == null ? "" : uMap["P"];
    u1F = uMap["F"] == null ? "" : uMap["F"];
    u1T = uMap["T"] == null ? "" : uMap["T"];
    u1Line = uMap["LINE"];
    uMap = data["U2"] == null ? null : data["U2"];
    u2I = uMap["I"] == null ? "" : uMap["I"];
    u2H = uMap["H"] == null ? "" : uMap["H"];
    u2M = uMap["M"] == null ? "" : uMap["M"];
    u2C = uMap["C"] == null ? "" : uMap["C"];
    u2P = uMap["P"] == null ? "" : uMap["P"];
    u2F = uMap["F"] == null ? "" : uMap["F"];
    u2T = uMap["T"] == null ? "" : uMap["T"];
    u2Line = uMap["LINE"];
    uMap = data["U3"] == null ? null : data["U3"];
    u3I = uMap["I"] == null ? "" : uMap["I"];
    u3H = uMap["H"] == null ? "" : uMap["H"];
    u3M = uMap["M"] == null ? "" : uMap["M"];
    u3C = uMap["C"] == null ? "" : uMap["C"];
    u3P = uMap["P"] == null ? "" : uMap["P"];
    u3F = uMap["F"] == null ? "" : uMap["F"];
    u3T = uMap["T"] == null ? "" : uMap["T"];
    u3Line = uMap["LINE"];
    
  }
}