
import 'package:auto_size_text/auto_size_text.dart';
import 'package:case_manager/common/dao/MaintDao.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:case_manager/widget/MyInputWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
///
///詳情頁回覆dialog
///Date:2019-06-24
class DetailReportDialog extends StatefulWidget {

  

  final String deptName;
  final String takeName;
  final String userId;
  final String caseId;
  final String statusName;
  DetailReportDialog({this.deptName, this.takeName, this.userId, this.caseId, this.statusName});

  @override
  _DetailReportDialogState createState() => _DetailReportDialogState();
}

class _DetailReportDialogState extends State<DetailReportDialog> with BaseWidget {
  
  ///選取資料
  Map<String, dynamic> pickData = {};
  ///userInfo model
  UserInfo userInfo;
  ///案件狀態，0: 新案，1: 接案，2: 結案，4: 部門結案
  int statusType = 0;
  int old_statusType = 0;
  ///輸入內文
  String inputText = '';
  @override
  void initState() {
    super.initState();
    initParam();
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  autoTextSize(text, style, context) {
    var fontSize = MyScreen.homePageFontSize(context);
    var fontStyle = TextStyle(fontSize: fontSize);
    return AutoSizeText(
      text,
      style: style.merge(fontStyle),
      minFontSize: 5.0,
    );
  }

  ///初始化資料
  initParam() {
    switch (widget.statusName) {
      case '新案':
        // setState(() {
          statusType = 0;
        // });
        break;
      case '接案':
        // setState(() {
          statusType = 1;
        // });
        break;
      case '結案': 
        // setState(() {
          statusType = 2;
        // });
        break;
    }
  }

  ///送出按鈕action
  sendAction(inputField, caseId, newStatus) async {
    print(inputField);
    ///舊按為新案，轉接案
    if (!(widget.statusName == '新案' && widget.statusName == '接案')) {
      if (inputField == '') {
        Fluttertoast.showToast(msg: '輸入內容無資料!');
        return;
      }
    }
    Fluttertoast.showToast(msg: 'userId: ${widget.userId}, caseId: $caseId, newStatus: $newStatus, newAData: $inputField');
    // var res = await MaintDao.didMaint(userId: widget.userId, caseId: caseId, newStatus: newStatus, newAData: inputField );
    // if (res != null && res.result) {
    //   Fluttertoast.showToast(msg: res.data);
    // }
  }

  @override
  Widget build(BuildContext context) {
    ///按鈕顏色
    List<dynamic> bntArr = [Colors.grey, Colors.grey, Colors.grey,];

    switch(statusType) {
      case 0:
        bntArr[0] = Colors.pink[200];
        bntArr[1] = Colors.grey;
        bntArr[2] = Colors.grey;
        break;
      case 1:
        bntArr[0] = Colors.grey;
        bntArr[1] = Colors.pink[200];
        bntArr[2] = Colors.grey;
        break;
      case 2:
         bntArr[0] = Colors.grey;
         bntArr[1] = Colors.grey;
         bntArr[2] = Colors.pink[200];
        break;
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                autoTextSize('回覆處理', TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context) * 1.5), context),
                GestureDetector(
                  child: autoTextSize('X', TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: MyScreen.normalPageFontSize(context) * 2 ), context),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
                
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
            child: TextField(
              textInputAction: TextInputAction.done,
              maxLines: 4,
              style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: '回覆內容',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                )
              ),
              onChanged: (String value) {
                inputText = value;
                print(inputText);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
            color: Color(MyColors.hexFromStr('d0e1f3')),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: autoTextSize('接案單位', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: autoTextSize('${widget.deptName}', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: autoTextSize('接案人', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: autoTextSize('${widget.takeName}', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  textColor: Colors.white,
                  color: bntArr[0],
                  highlightColor: Colors.pink[200],
                  animationDuration: Duration(milliseconds: 300),
                  child: autoTextSize('新案', TextStyle(fontSize: MyScreen.homePageFontSize(context)),context),
                  onPressed: () {
                    setState(() {
                      statusType = 0;
                    });
                  },
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: bntArr[1],
                  highlightColor: Colors.pink[100],
                  child: autoTextSize('接案', TextStyle(fontSize: MyScreen.homePageFontSize(context)),context),
                  onPressed: () {
                    setState(() {
                      statusType = 1;
                    });
                  },
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: bntArr[2],
                  highlightColor: Colors.pink[100],
                  child: autoTextSize('結案', TextStyle(fontSize: MyScreen.homePageFontSize(context)),context),
                  onPressed: () {
                    setState(() {
                      statusType = 2;
                    });
                  },
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              width: deviceWidth3(context),
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: autoTextSize('送出', TextStyle(fontSize: MyScreen.homePageFontSize(context)),context),
                onPressed: () {
                  print("inputText: $inputText");
                  sendAction(inputText, widget.caseId, statusType);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
