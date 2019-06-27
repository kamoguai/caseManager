

import 'package:case_manager/common/dao/AssignInfoDao.dart';
import 'package:case_manager/common/dao/MaintDao.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
///
///查詢條件dialog
///Date: 2019-06-26
class SearchDialog extends StatefulWidget {

  final userId;
  final deptId;
  final isDPCase;
  Function callApiDataExt;
  SearchDialog({this.userId, this.deptId, this.isDPCase, this.callApiDataExt});

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> with BaseWidget {

  ///所選案件狀態，新案:0,接案:1,結案:2,部門結案:4
  var selectCaseStatus = 0;
  var selectCSName = '';
  ///所選案件類別id
  var selectCaseTypeId = '';
  var selectCTName = '';
  ///所選接案人id
  var selectManId = '';
  var selectManName = '';
  ///輸入title
  var titleStr = "";
  ///輸入客編
  var custNoStr = "";
  ///輸入案件編號
  var caseIdStr = "";
  ///案件類型資料arr
  List<dynamic> caseArray = [];
  ///接案人資料arr
  List<dynamic> manArray = [];
  ///組裝所選資料
  Map<String, dynamic> pickData = {};

  @override
  void initState() {
    super.initState();
    initParam();
  }

  @override
  void dispose() {
    super.dispose();
  }
  ///初始化資料
  initParam() {
    getApiData();
  }
  ///呼叫api
  getApiData() async {
    ///案件類型api
    var res = await MaintDao.caseTypeSelect();
    if (res != null && res.result) {
      caseArray = res.data;
    }
    if (widget.isDPCase) {
      var res = await AssignInfoDao.getEmplSelect(widget.deptId);
      if (res != null && res.result) {
        manArray = res.data;
      }
    }
  }

  ///案件狀態action
  List<Widget> caseStatusListActions() {
    List<Widget> wList = [];
    var strArr = ["新案","接案","結案","部門結案"];
    for (var dic in strArr) {
      wList.add(
        CupertinoActionSheetAction(
          child: Text(dic, style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          onPressed: () {
            setState(() {
              selectCSName = dic;
              switch (dic) {
                case '新案':
                  selectCaseStatus = 0;
                  break;
                case '接案': 
                  selectCaseStatus = 1;
                  break;
                case '結案': 
                  selectCaseStatus = 2;
                  break;
                case '部門結案': 
                  selectCaseStatus = 4;
                  break;
              }
              pickData.addAll({'SearchStatus':selectCaseStatus});
              Navigator.pop(context);
            });
          },
        )
      );
    }
    return wList;
  }

  ///案件類別action
  List<Widget> caseTypeListActions() {
    List<Widget> wList = [];

    for (var dic in caseArray) {
      wList.add(
        CupertinoActionSheetAction(
          child: Text(dic['CaseTypeName'], style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          onPressed: () {
            setState(() {
              selectCaseTypeId = dic['CaseTypeID'];
              selectCTName = dic['CaseTypeName'];
              pickData.addAll({'SearchCaseType':selectCaseTypeId});
              Navigator.pop(context);
            });
          },
        )
      );
    }
    return wList;
  }

  ///接案人action
  List<Widget> manListActions() {
    List<Widget> wList = [];

    for (var dic in manArray) {
      wList.add(
        CupertinoActionSheetAction(
          child: Text(dic['Name'], style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          onPressed: () {
            setState(() {
              selectManId = dic['UserID'];
              selectManName = dic['Name'];
              pickData.addAll({'SearchPUser':selectManId});
              Navigator.pop(context);
            });
          },
        )
      );
    }
    return wList;
  }

  ///案件狀態選擇器
  showSelectorCaseStatusSheetController(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        var dialog = CupertinoActionSheet(
          title: Text('案件狀態', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: caseStatusListActions(),
        );
        return dialog;
      }
    );
  }

  ///案件狀態選擇器
  showSelectorCaseTypeSheetController(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        var dialog = CupertinoActionSheet(
          title: Text('案件類別', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: caseTypeListActions(),
        );
        return dialog;
      }
    );
  }

  ///接案人選擇器
  showSelectorManSheetController(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        var dialog = CupertinoActionSheet(
          title: Text('接案人', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: manListActions(),
        );
        return dialog;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    List<Widget> row = [];

    row.add(
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: autoTextSize('案件狀態:', TextStyle(color: Colors.black), context),
            ),
            Expanded(
              child: FlatButton(
                textColor: Colors.blue,
                child: autoTextSize(selectCSName == '' ? '請選擇' : selectCSName, TextStyle(color: Colors.blue), context),
                onPressed: () {
                  showSelectorCaseStatusSheetController(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
    row.add(
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: autoTextSize('案件類型:', TextStyle(color: Colors.black), context),
            ),
            Expanded(
              child: FlatButton(
                textColor: Colors.blue,
                child: autoTextSize(selectCTName == '' ? '請選擇' : selectCTName, TextStyle(color: Colors.blue), context),
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 50),(){
                    showSelectorCaseTypeSheetController(context);
                  });
                },
              )
            )
          ],
        ),
      ),
    );
    if (widget.isDPCase) {
      row.add(
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: autoTextSize('接案人:', TextStyle(color: Colors.black), context),
              ),
              Expanded(
                child: FlatButton(
                  textColor: Colors.blue,
                  child: autoTextSize(selectManName == '' ? '請選擇' : selectManName, TextStyle(color: Colors.blue), context),
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 50),(){
                      showSelectorManSheetController(context);
                    });
                  },
                )
              )
            ],
          ),
        )
      );
    }
    row.add(
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: autoTextSize('案件標題:', TextStyle(color: Colors.black), context),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0, style: BorderStyle.solid)
                    )
                  ),
                  onChanged: (String value) {
                    titleStr = value;
                    pickData.addAll({'SearchSubject':titleStr});
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
    row.add(
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: autoTextSize('客戶編號:', TextStyle(color: Colors.black), context),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0, style: BorderStyle.solid)
                    )
                  ),
                  onChanged: (String value) {
                    custNoStr = value;
                    pickData.addAll({'SearchCustNO':custNoStr});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
    row.add(
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: autoTextSize('案件編號:', TextStyle(color: Colors.black), context),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0, style: BorderStyle.solid)
                    )
                  ),
                  onChanged: (String value) {
                    caseIdStr = value;
                    pickData.addAll({'SearchSerial':caseIdStr});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
    row.add(
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              textColor: Colors.blue,
              child: Text('取消', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              textColor: Colors.blue,
              child: Text('確定', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
              onPressed: () {
                widget.callApiDataExt(pickData);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
    body = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: row
      ),
    );

    return body;
  }
}
