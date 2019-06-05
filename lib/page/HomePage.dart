
import 'package:case_manager/common/redux/SysState.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/CommonUtils.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

/**
 * 首頁
 * Date: 2019-06-05
 */
class HomePage extends StatefulWidget {
  static final String sName = "home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with BaseWidget{
  
  var selectArea = '新北市';

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<SysState>(builder: (context, store) {
      return SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            actions: actions(),
          ),
          body: Container(
            color: Colors.white,
          ),
          bottomNavigationBar: Material(
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  height: 42,
                  child: autoTextSize('刷新', TextStyle(color: Colors.white), context),
                ),
                Container(
                  height: 42,
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  height: 42,
                  child: autoTextSize('案件分析', TextStyle(color: Colors.white), context),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  ///區域dialog, ios樣式
  _showAlertSheetController(BuildContext context) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (context) {
          var dialog = CupertinoActionSheet(
            title: Text('選擇區域'),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, 'cancel');
              },
              child: Text('取消'),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () {
                  setState(() {
                    selectArea = '新北市';
                  });
                  Navigator.pop(context);
                },
                child: Text('新北市'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  setState(() {
                    selectArea = '台北市';
                  });
                  Navigator.pop(context);
                },
                child: Text('台北市'),
              ),
            ],
          );
          return dialog;
        });
  }

  List<Widget> actions() {
    List<Widget> list = [
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                _showAlertSheetController(context);
              },
              child: Container(
                height: 38,
                alignment: Alignment.center,
                width: deviceWidth4(context),
                decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.white), color: Colors.yellow),
                child: Text(selectArea, style: TextStyle(color: Colors.white,)),
              ),
            ),
            Container(
              color: Colors.pink,
              height: 30,
              child: FlatButton.icon(
                icon: Image.asset('static/images/24.png'),
                color: Colors.transparent,
                label: Text(''),
                onPressed: (){
                  NavigatorUtils.goLogin(context);
                },
              ),
            ),
          ],
        ),
      )
    ];
    return list;
  }
}