
import 'package:auto_size_text/auto_size_text.dart';
import 'package:case_manager/common/dao/AssignInfoDao.dart';
import 'package:case_manager/common/dao/DPMaintDao.dart';
import 'package:case_manager/common/dao/DeptInfoDao.dart';
import 'package:case_manager/common/dao/MaintDao.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
///
///詳情頁回覆dialog
///Date:2019-06-24
class DetailReportDialog extends StatefulWidget {
  ///由前頁傳入部門名
  final String deptName;
  ///由前頁傳入接案人
  final String takeName;
  ///由前頁傳入使用者id
  final String userId;
  ///由前頁傳入案件id
  final String caseId;
  ///由前頁傳入案件狀態名
  final String statusName;
  ///由前頁傳入案件caseTypeName
  final String caseTypeName;
  ///由前頁傳入來自功能
  final String fromFunc;
  ///由前頁傳入userInfo
  final UserInfo userInfo;
  ///由前頁傳入accName
  final String accName;
  ///由前頁傳入deptId
  final String deptId;
  
  DetailReportDialog({this.deptName, this.takeName, this.userId, this.caseId, this.statusName, this.caseTypeName, this.fromFunc, this.userInfo, this.accName, this.deptId});

  @override
  _DetailReportDialogState createState() => _DetailReportDialogState();
}

class _DetailReportDialogState extends State<DetailReportDialog> with BaseWidget {
  
  ///選取資料
  Map<String, dynamic> pickData = {};

  ///案件狀態，0: 新案，1: 接案，2: 結案，4: 部門結案
  int statusType = 0;
  ///輸入內文
  String inputText = '';
  ///部門選單
  List<dynamic> deptArray = [];
  var selectDeptId = '';
  var selectDeptName = '';
  ///pUser選單
  List<dynamic> pUserArray = [];
  var selectPuserId = '';
  var selectPuserName = '';
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
        statusType = 0;
        break;
      case '接案':
        statusType = 1;
        break;
      case '結案': 
        statusType = 2;
        break;
      case '單位結案':
        statusType = 4;
        break;
    }
    if (widget.fromFunc == "DPMaint") {
      getApiData();
    }
    else if (widget.fromFunc == "FixInsert") {
      getAssignEmplData("4");
    } 
  }

  getApiData() async {
    if (widget.userInfo.userData.Position == '2') {
        var res = await DeptInfoDao.getDeptSelect(null);
        deptArray = res.data;
      }
      else if (widget.userInfo.userData.Position == '3') {
        var res = await DeptInfoDao.getUserDeptSelect(widget.userInfo.userData.UserID);
        deptArray = res.data;
      } 
      else {
        var res = await DeptInfoDao.getDeptSelect(widget.userInfo.userData.UserID);
        deptArray = res.data;
      }
    var res = await AssignInfoDao.getEmplSelect(widget.userInfo.userData.DeptID);
    pUserArray = res.data;
  }

  ///取得指派人員資料
  getAssignEmplData(deptId) async {
    var res = await AssignInfoDao.getEmplSelect(deptId);
    if (mounted) {
      setState(() {
        pUserArray = res.data;
      });
    }
  }

  ///送出按鈕action
  sendAction(inputField, caseId, newStatus, pUserId, pDeptId) async {
    ///0:新案，1:接案，2:結案
    if (newStatus == 2) {
      if (inputField == '') {
        Fluttertoast.showToast(msg: '輸入內容無資料!');
        return;
      }
    }
    switch (widget.fromFunc) {
      case 'Maint':
       
        var res = await MaintDao.didMaint(userId: widget.userId, caseId: caseId, newStatus: newStatus, newAData: inputField);
        if(res.result) {
          if (this.statusType == 2) {
            if (widget.caseTypeName == "裝機未完工" && (this.selectDeptName == "工程-裝機" || this.selectDeptName == "工程-裝鋪")) {
              showChoiceCloseCaseController(context);
            }
          }
           else {
              new Future.delayed(const Duration(seconds: 1),() {
                NavigatorUtils.goMaint(context, widget.accName, deptId: widget.deptId);
              });
            }
        }
        break;
      case 'DPMaint':
      
        var res = await DPMaintDao.didDPMaint(userId: widget.userId, caseId: caseId, newStatus: newStatus, newAData: inputField, deptId: pDeptId, pUserId: pUserId);
        if(res.result) {
          new Future.delayed(const Duration(seconds: 1),() {
            NavigatorUtils.goDPMaint(context, widget.accName, deptId: widget.deptId);
          });
        }
        break;
      case 'FixInsert':
        var res = await MaintDao.didMaint(userId: widget.userId, caseId: caseId, newStatus: newStatus, newAData: inputField);
        if(res.result) {
          if (this.statusType == 2) {
            if (widget.caseTypeName == "裝機未完工" && (this.selectDeptName == "工程-裝機" || this.selectDeptName == "工程-裝鋪")) {
              showChoiceCloseCaseController(context);
            }           
          }
          else {
            new Future.delayed(const Duration(seconds: 1),() {
              NavigatorUtils.goFixInsert(context, widget.accName, deptId: widget.deptId);
            });
          }
        }
        break;
    }
  }
  ///choiceCloseCaseAction
  List<Widget> choiceCloseCaseAction() {
    List<Widget> wList = [];
    var actionTitle = ["已安裝完成","可約裝","請撤銷"];
    for (var dic in actionTitle) {
      wList.add(
         CupertinoActionSheetAction(
          child: Text(dic, style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          onPressed: () async {
            switch (dic) {
              case '已安裝完成':
                await MaintDao.didToSalesOk(widget.userId, widget.caseId, "0");
                break;
              case '可約裝':
                await MaintDao.didToSalesOk(widget.userId, widget.caseId, "1");
                break;
              case '請撤銷':
                await MaintDao.didToSalesOk(widget.userId, widget.caseId, "2");
                break;
            }
            Navigator.pop(context);
          },
        )
      );
    }
    return wList;
  }
  ///只有業務可以選的項目, 沒有取消按鈕，必選三擇一
  void showChoiceCloseCaseController(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        var dialog = CupertinoActionSheet(
          title: Text('業務通知', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          actions: choiceCloseCaseAction(),
        );
        return dialog;
      }
    );
  }

  ///部門選擇Actions
  List<Widget> deptListActions() {
    List<Widget> wList = [];
    for (var dic in deptArray) {
      wList.add(
        CupertinoActionSheetAction(
          child: Text(dic['DeptName'], style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          onPressed: () {
            
            setState(() {
              selectDeptId = dic['DeptID'];
              selectDeptName = dic['DeptName'];
              selectPuserName = '請選擇';
              selectPuserId = '';
              pickData.addAll({'PDeptID':selectDeptId});
              getAssignEmplData(selectDeptId);
              Navigator.pop(context);
            });
          },
        )
      );
    }
    return wList;
  }
  ///接案人選擇Action
  List<Widget> pUserActions() {
    List<Widget> wList = [];
    for (var dic in pUserArray) {
      wList.add(
        CupertinoActionSheetAction(
          child: Text(dic['Name'], style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          onPressed: () {
            setState(() {
              selectPuserId = dic['UserID'];
              selectPuserName = dic['Name'];
              pickData.addAll({'PUserID':selectPuserId});
              Navigator.pop(context);
            });
          },
        )
      );
    }
    return wList;
  }
  ///部門選擇器
  showSelectorDeptSheetController(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        var dialog = CupertinoActionSheet(
          title: Text('選擇部門', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: deptListActions(),
        );
        return dialog;
      }
    );
  }
  ///接案人選擇器
  showSelectorPuserSheetController(BuildContext context) {
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
          actions: pUserActions(),
        );
        return dialog;
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    ///按鈕顏色
    List<dynamic> bntArr = [Colors.grey, Colors.grey, Colors.grey,];
    switch (widget.fromFunc) {
      case 'Maint' :
        bntArr = [Colors.grey, Colors.grey, Colors.grey,];
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
        break;
      case 'DPMaint':
        bntArr = [Colors.grey, Colors.grey, Colors.grey, Colors.grey];
        switch(statusType) {
          case 0:
            bntArr[0] = Colors.pink[200];
            bntArr[1] = Colors.grey;
            bntArr[2] = Colors.grey;
            bntArr[3] = Colors.grey;
            break;
          case 1:
            bntArr[0] = Colors.grey;
            bntArr[1] = Colors.pink[200];
            bntArr[2] = Colors.grey;
            bntArr[3] = Colors.grey;
            break;
          case 2:
            bntArr[0] = Colors.grey;
            bntArr[1] = Colors.grey;
            bntArr[2] = Colors.pink[200];
            bntArr[3] = Colors.grey;
            break;
          case 4:
            bntArr[0] = Colors.grey;
            bntArr[1] = Colors.grey;
            bntArr[2] = Colors.grey;
            bntArr[3] = Colors.pink[200];
            break;
        }
        break;
      case 'FixInsert' :
      bntArr = [Colors.grey, Colors.grey, Colors.grey,];
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
      break;
    }
    Widget body;
    List<Widget> columnList = [];

    columnList.add(
      Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            autoTextSize('回覆處理', TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context) * 1.5), context),
            GestureDetector(
              child: Icon(Icons.cancel, color: Colors.blue, size: titleHeight(context) * 1.3,),
              onTap: () {
                Navigator.pop(context);
              },
            )
            
          ],
        ),
      ),
    );
    columnList.add(
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
    );
   
    switch (widget.fromFunc) {
      case 'Maint':
         columnList.add(
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
                          child: autoTextSize('接案單位:', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
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
                          child: autoTextSize('接案人:', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
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
        );
        columnList.add(
          Container(
            height: titleHeight(context) * 2,
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(4),
                  child: RaisedButton(
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
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: RaisedButton(
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
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: RaisedButton(
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
                ),
              ],
            ),
          ),
        );
        break;
      case 'DPMaint':
        columnList.add(
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
                          child: autoTextSize('接案單位:', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: autoTextSize('${selectDeptName == '' ? widget.deptName : selectDeptName}', TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)), context),
                          ),
                          onTap: () {
                            showSelectorDeptSheetController(context);
                          },
                        )
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
                          child: autoTextSize('接案人:', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: autoTextSize('${selectPuserName == '' ? widget.takeName : selectPuserName}', TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)), context),
                          ),
                          onTap: () async {
                            showSelectorPuserSheetController(context);
                          },
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        columnList.add(
          Container(
            height: titleHeight(context) * 2,
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5, right: 5),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton(
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
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton(
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
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton(
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
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: bntArr[3],
                    highlightColor: Colors.pink[100],
                    child: autoTextSize('單位結案', TextStyle(fontSize: MyScreen.homePageFontSize(context)),context),
                    onPressed: () {
                      setState(() {
                        statusType = 4;
                      });
                    },
                  ),
                ),
              ],
            ),
           
          ),
        );
        break;
      case 'FixInsert':
        columnList.add(
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
                        child: autoTextSize('接案單位:', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
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
                        child: autoTextSize('接案人:', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
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
      );
      columnList.add(
        Container(
          height: titleHeight(context) * 2,
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(4),
                child: RaisedButton(
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
              ),
              Container(
                padding: EdgeInsets.all(4),
                child: RaisedButton(
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
              ),
              Container(
                padding: EdgeInsets.all(4),
                child: RaisedButton(
                textColor: Colors.white,
                color: bntArr[2],
                highlightColor: Colors.pink[100],
                child: autoTextSize('單位結案', TextStyle(fontSize: MyScreen.homePageFontSize(context)),context),
                onPressed: () {
                  setState(() {
                    statusType = 4;
                  });
                },
              ),
              ),
            ],
          ),
        ),
      );
      break;
    }
    columnList.add(
      Center(
        child: Container(
          width: deviceWidth3(context),
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: RaisedButton(
            textColor: Colors.white,
            color: Colors.blue,
            child: autoTextSize('送出', TextStyle(fontSize: MyScreen.homePageFontSize(context)),context),
            onPressed: () {
              if (selectPuserName == '請選擇') {
                Fluttertoast.showToast(msg: '請選擇接案人');
                return;
              }
              if (selectPuserId == '') {
                selectPuserId = widget.userId;
              }
              if (selectDeptId == '') {
                selectDeptId = widget.userInfo.userData.DeptID;
              }
              sendAction(inputText, widget.caseId, statusType, selectPuserId, selectDeptId);
            },
          ),
        ),
      )
    );

    body = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: columnList
      ),
    );
    return body;
  }
}
