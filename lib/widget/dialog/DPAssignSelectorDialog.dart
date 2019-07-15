import 'package:auto_size_text/auto_size_text.dart';
import 'package:case_manager/common/dao/AssignInfoDao.dart';
import 'package:case_manager/common/dao/DPAssignDao.dart';
import 'package:case_manager/common/dao/DeptInfoDao.dart';
import 'package:case_manager/common/dao/FileDao.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
///
///單位指派dialog
class DPAssignSelectorDialog extends StatefulWidget {

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
  ///由前頁傳入來自功能
  final String fromFunc;
  ///由前頁傳入userInfo
  final UserInfo userInfo;
  DPAssignSelectorDialog({this.deptName, this.takeName, this.userId, this.caseId, this.statusName, this.fromFunc, this.userInfo});

  @override
  _DPAssignSelectorDialogState createState() => _DPAssignSelectorDialogState();
}

class _DPAssignSelectorDialogState extends State<DPAssignSelectorDialog> with BaseWidget {

  ///選取資料
  Map<String, dynamic> pickData = {};

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
    getDeptListApiData();
  }
  ///取得部門列表
  getDeptListApiData() async {
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
  }
  ///取得指派人員列表
  getAssignEmplListApiData(deptId) async {
    var res = await AssignInfoDao.getEmplSelect(deptId);
    if (mounted) {
      setState(() {
        pUserArray = res.data;
      });
    }
  }
  ///post指派api
  postDPAssignApi(userId, inputField, caseId, pUserId, pDeptId) async {
    await DPAssignDao.didDPAssignCase(userId: userId, caseId: caseId, funit: pDeptId, pUserId: pUserId);
  }
  ///post歸檔api
  postFileApi(userId, caseId) async {
    await FileDao.postFile(userId: userId, caseId: caseId);
  }
  ///送出按鈕action
  sendAction(userId, inputField, caseId, pUserId, pDeptId) {
    
    postDPAssignApi(userId, inputField, caseId, pUserId, pDeptId);
   
  }
  ///送出歸檔指令
  sendFile(userId, caseId) {

    postFileApi(userId, caseId);

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
              getAssignEmplListApiData(selectDeptId);
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

    Widget body;
    List<Widget> columnList = [];
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = deviceWidth3(context);
    if (deviceHeight < 590) {
      deviceWidth = deviceWidth3(context) * 1.2;
    }
    columnList.add(
      Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            autoTextSize('指派處理', TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context) * 1.5), context),
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
                      child: autoTextSize('指派部門:', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: autoTextSize('${selectDeptName == '' ? '請選擇' : selectDeptName}', TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)), context),
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
                      child: autoTextSize('指派人員:', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: autoTextSize('${selectPuserName == '' ? '請選擇' : selectPuserName}', TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)), context),
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
    columnList.add(
      Container(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
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
                  sendAction(widget.userId, inputText, widget.caseId, selectPuserId, selectDeptId);
                },
              ),
            ),
            Container(
              width: deviceWidth,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: RaisedButton(
                textColor: Colors.red,
                color: Colors.blue,
                child: autoTextSize('直接歸檔', TextStyle(fontSize: MyScreen.homePageFontSize(context)),context),
                onPressed: () {
                  sendFile(widget.userId, widget.caseId);
                },
              ),
            ),
          ],
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