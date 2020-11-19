import 'package:case_manager/common/model/MaintTableCell.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///
///個人案件處理item
///Date: 2019-06-11
///
class MaintListItem extends StatelessWidget with BaseWidget {
  ///set, get
  final MaintListModel model;

  ///使用者id
  final userId;

  ///使用者名稱
  final accName;

  ///由前頁傳入部門id
  final deptId;

  ///來自功能
  final fromFunc;

  ///callApi
  final Function callApiData;

  ///call add caseId func
  final Function addCaseIdFunc;

  ///裝填所選caseId
  final List<String> pickCaseIdArray;
  MaintListItem(
      {this.model,
      this.userId,
      this.accName,
      this.deptId,
      this.fromFunc,
      this.callApiData,
      this.pickCaseIdArray,
      this.addCaseIdFunc});

  ///選定check改變icon圖示
  Icon changeCheckIcon(context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var iconSize = 20.0;
    if (deviceHeight < 590) {
      iconSize = titleHeight(context) * 1.2;
    } else if (deviceHeight < 600) {
      iconSize = titleHeight(context) * 1.1;
    } else {
      iconSize = listHeight(context) * 0.9;
    }
    if (pickCaseIdArray.contains(model.caseID)) {
      return Icon(
        Icons.check_box,
        color: Colors.blue,
        size: iconSize,
      );
    } else {
      return Icon(Icons.check_box_outline_blank,
          color: Colors.grey, size: iconSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    ///案件狀態
    Color statusColor;
    switch (model.statusName) {
      case '新案':
        statusColor = Colors.red;
        break;
      case '接案':
        statusColor = Colors.blue;
        break;
      case '結案':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.white;
        break;
    }

    ///第一條row
    List<Widget> firstRowView() {
      List<Widget> row = [];
      var createTime = '${model.dataTime} ${model.dataTime2}';
      final dft = new DateFormat('yyyy/MM/dd HH:mm');
      final dft2 = new DateFormat('yy/MM/dd HH:mm');
      var cTime = dft.parse(createTime);
      var cTimeStr = dft2.format(cTime);
      row.add(
        Expanded(
          // flex: 6,
          child: Row(
            children: <Widget>[
              autoTextSize('立案:', TextStyle(color: Colors.black), context),
              autoTextSize(
                  '$cTimeStr', TextStyle(color: Colors.grey[600]), context),
            ],
          ),
        ),
      );
      // row.add(
      //   Expanded(
      //     flex: 4,
      //     child: Row(
      //       children: <Widget>[
      //         autoTextSize('立案人:', TextStyle(color: Colors.black), context),
      //         autoTextSizeLeft('${model.createrName}', TextStyle(color: Colors.grey[600]), context),
      //       ],
      //     )
      //   ),
      // );
      return row;
    }

    ///第一條row
    List<Widget> first2RowView() {
      List<Widget> row = [];
      var createTime = '${model.dataTime} ${model.dataTime2}';
      final dft = new DateFormat('yyyy/MM/dd HH:mm');
      final dft2 = new DateFormat('yy/MM/dd HH:mm');
      var cTime = dft.parse(createTime);
      var cTimeStr = dft2.format(cTime);
      row.add(
        Expanded(
            flex: 4,
            child: Row(
              children: <Widget>[
                autoTextSize('立案人:', TextStyle(color: Colors.black), context),
                autoTextSizeLeft('${model.createrName}',
                    TextStyle(color: Colors.grey[600]), context),
              ],
            )),
      );
      return row;
    }

    ///第二條row
    List<Widget> secondRowView() {
      List<Widget> row = [];

      if (model.statusName == '新案') {
        if (model.pUserName == "未指派") {
          var createTime = '${model.dataTime} ${model.dataTime2}';
          final dft = new DateFormat('yyyy/MM/dd HH:mm');
          final dft2 = new DateFormat('yy/MM/dd HH:mm');
          var cTime = dft.parse(createTime);
          var cTimeStr = dft2.format(cTime);
          row.add(
              autoTextSize('立案:', TextStyle(color: Colors.indigo), context));
          row.add(autoTextSize(
              '$cTimeStr', TextStyle(color: Colors.grey[600]), context));
        } else {
          row.add(
              autoTextSize('派案:', TextStyle(color: Colors.indigo), context));
          row.add(autoTextSize('${model.pushTime}',
              TextStyle(color: Colors.grey[600]), context));
          if (model.pushTimeDiffStatus == "" && model.pushTimeDiff != "") {
            row.add(autoTextSize(
                '未接:', TextStyle(color: Colors.grey[600]), context));
            row.add(autoTextSize('${model.pushTimeDiff}',
                TextStyle(color: Colors.indigo), context));
          }
        }
      } else if (model.statusName == '接案') {
        if (model.takeTimeDiff == "") {
          row.add(
              autoTextSize('接案:', TextStyle(color: Colors.indigo), context));
          row.add(
              autoTextSize('未結:', TextStyle(color: Colors.indigo), context));
        } else {
          Color col;
          if (model.takeTimeDiffStatus == "1") {
            col = Colors.red;
          } else {
            col = Colors.indigo;
          }
          row.add(
              autoTextSize('接案:', TextStyle(color: Colors.indigo), context));
          row.add(autoTextSize('${model.takeTime}',
              TextStyle(color: Colors.grey[600]), context));
          row.add(
              autoTextSize('未結:', TextStyle(color: Colors.indigo), context));
          row.add(autoTextSize(
              '${model.takeTimeDiff}', TextStyle(color: col), context));
        }
      } else if (model.statusName == '結案' || model.statusName == '單位結案') {
        if (model.pushTime != "") {
          var strStartDate = model.pushTime;
          var strPushTime = model.pushTime;
          if (strPushTime.length > 4) {
            strPushTime = strPushTime.substring(2);
          }
          var strCloseDataTime =
              '${model.closeDataTime} ${model.closeDataTime2}';
          if (strStartDate.length < 19) {
            strStartDate = strStartDate + ':00';
          }
          final dft = new DateFormat('yyyy/MM/dd HH:mm:ss');
          var myStartDate = dft.parse(strStartDate);
          var myDateClose = strCloseDataTime;
          if (myDateClose.length < 19 && strCloseDataTime != " ") {
            myDateClose = myDateClose + ":00";
          } else {
            myDateClose = strStartDate;
          }
          var myCloseDate = dft.parse(myDateClose);
          var deference = myCloseDate.difference(myStartDate);
          var inday = deference.inDays;
          var inhour = deference.inHours;
          if (inhour > 24) {
            inhour = inhour - (inday * 24);
          }
          var inminut = deference.inMinutes - (deference.inHours * 60);
          Color col;
          if (model.pushTimeDiffStatus == "1") {
            col = Colors.red;
          } else {
            col = Colors.indigo;
          }
          row.add(autoTextSize(
              '${model.statusName}:', TextStyle(color: Colors.green), context));
          row.add(Icon(
            Icons.access_time,
            size: 20,
          ));
          row.add(autoTextSize(
              '$inday天$inhour時$inminut分', TextStyle(color: col), context));
        } else {
          row.add(autoTextSize(
              '${model.statusName}:', TextStyle(color: Colors.green), context));
          row.add(autoTextSize('${model.closeDataTime} ${model.closeDataTime2}',
              TextStyle(color: Colors.grey[600]), context));
        }
      }
      return row;
    }

    ///第三條row
    List<Widget> thirdRowView() {
      List<Widget> row = [];
      if (model.statusName == '新案') {
        row.add(Expanded(
          flex: 5,
          child: Row(
            children: <Widget>[
              autoTextSize('指派:', TextStyle(color: Colors.black), context),
              autoTextSize('${model.pUserName}',
                  TextStyle(color: Colors.grey[600]), context)
            ],
          ),
        ));
        Widget w;
        if (model.pushTimeDiffStatus == "" && model.pushTimeDiff != "") {
          w = autoTextSize('新案-未接案', TextStyle(color: Colors.red), context);
        } else {
          w = autoTextSize('新案', TextStyle(color: Colors.red), context);
        }
        if (fromFunc != 'InterimAuth')
          row.add(Expanded(
            flex: 5,
            child: Row(
              children: <Widget>[
                autoTextSize('狀態: ', TextStyle(color: Colors.black), context),
                w,
              ],
            ),
          ));
      } else {
        row.add(Expanded(
          flex: 5,
          child: Row(
            children: <Widget>[
              autoTextSize('指派:', TextStyle(color: Colors.black), context),
              autoTextSize('${model.pUserName}',
                  TextStyle(color: Colors.grey[600]), context)
            ],
          ),
        ));
        if (fromFunc != 'InterimAuth')
          row.add(Expanded(
            flex: 5,
            child: Row(
              children: <Widget>[
                autoTextSize('狀態: ', TextStyle(color: Colors.black), context),
                autoTextSize('${model.statusName}',
                    TextStyle(color: statusColor), context)
              ],
            ),
          ));
      }
      return row;
    }

    Widget content = Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
            child: Row(children: firstRowView()),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
            child: Row(children: first2RowView()),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
            child: Row(children: secondRowView()),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
            child: Row(children: thirdRowView()),
          ),
          Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: Color(MyColors.hexFromStr('f2f2f2')),
                  border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.red))),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: autoTextSize(
                        '案由', TextStyle(color: Colors.black), context),
                  ),
                  Expanded(
                    flex: 6,
                    child: autoTextSizeLeft('${model.subject}',
                        TextStyle(color: Colors.blueAccent), context),
                  )
                ],
              )),
        ],
      ),
    );

    List<Widget> wList = [];
    wList.add(content);
    if (fromFunc != "InterimAuth") {
      wList.add(
        Positioned(
            right: 5.0,
            bottom: -8.0,
            child: GestureDetector(
              child: Image.asset('static/images/detail.png',
                  width: 50, height: 50),
              onTap: () {
                switch (fromFunc) {
                  case 'Maint':
                    NavigatorUtils.goMaintDetail(context, model.custNO, userId,
                        deptId, model.caseID, model.statusName, accName);
                    break;
                  case 'AssignEmpl':
                    NavigatorUtils.goAssignEmplDetail(
                        context,
                        model.custNO,
                        userId,
                        deptId,
                        model.caseID,
                        model.statusName,
                        accName);
                    break;
                  case 'DPMaint':
                    NavigatorUtils.goDPMaintDetail(
                        context,
                        model.custNO,
                        userId,
                        deptId,
                        model.caseID,
                        model.statusName,
                        accName);
                    break;
                  case 'DPAssign':
                    NavigatorUtils.goDPAssignDetail(
                        context,
                        model.custNO,
                        userId,
                        deptId,
                        model.caseID,
                        model.statusName,
                        accName);
                    break;
                  case 'File':
                    NavigatorUtils.goFileDettail(context, model.custNO, userId,
                        deptId, model.caseID, model.statusName, 'File');
                    break;
                  case 'DPMaintClose':
                    NavigatorUtils.goFileDettail(context, model.custNO, userId,
                        deptId, model.caseID, model.statusName, 'DPMaintClose');
                    break;
                  case 'SalesMaint':
                    NavigatorUtils.goSalesMaintDetail(context, model.custNO,
                        userId, deptId, model.caseID, model.statusName);
                }
              },
            )),
      );
    } else {
      wList.add(
        Positioned(
            right: 5.0,
            bottom: 10.0,
            child: GestureDetector(
                child: FlatButton(
              child:
                  autoTextSize('授權', TextStyle(color: Colors.white), context),
              color: Colors.blue[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              onPressed: () {},
            ))),
      );
    }

    if ((fromFunc == 'DPMaint' && model.statusName == '結案') ||
        fromFunc == 'File' ||
        fromFunc == 'DPMaintClose') {
      wList.add(
        Positioned(
            right: 5.0,
            top: -3.0,
            child: GestureDetector(
              child: Container(
                color: Colors.white,
                child: changeCheckIcon(context),
              ),
              onTap: () {
                addCaseIdFunc(model.caseID);
              },
            )),
      );
    }
    return Stack(children: wList);
  }
}

class MaintListModel {
  String caseID;
  String caseNO;
  String dataTime;
  String dataTime2;
  String closeDataTime;
  String closeDataTime2;
  String subject;
  String caseTypeName;
  String area;
  String custNO;
  String custName;
  String statusName;
  String fUnitName;
  String pDeptName;
  String pUserName;
  String pushTime;
  String takeTime;
  String pushTimeDiff;
  String takeTimeDiff;
  String pushTimeDiffStatus;
  String takeTimeDiffStatus;
  String createrName;

  MaintListModel();

  MaintListModel.forMap(MaintTableCell data) {
    caseID = data.CaseID == null ? "" : data.CaseID;
    caseNO = data.CaseNO == null ? "" : data.CaseNO;
    dataTime = data.DataTime == null ? "" : data.DataTime;
    dataTime2 = data.DataTime2 == null ? "" : data.DataTime2;
    closeDataTime = data.CloseDataTime == null ? "" : data.CloseDataTime;
    closeDataTime2 = data.CloseDataTime2 == null ? "" : data.CloseDataTime2;
    subject = data.Subject == null ? "" : data.Subject;
    caseTypeName = data.CaseTypeName == null ? "" : data.CaseTypeName;
    area = data.Area == null ? "" : data.Area;
    custNO = data.CustNO == null ? "" : data.CustNO;
    custName = data.CustName == null ? "" : data.CustName;
    statusName = data.StatusName == null ? "" : data.StatusName;
    fUnitName = data.FUnitName == null ? "" : data.FUnitName;
    pDeptName = data.PDeptName == null ? "" : data.PDeptName;
    pUserName = data.PUserName == "" ? "未指派" : data.PUserName;
    pushTime = data.PushTime == null ? "" : data.PushTime;
    takeTime = data.TakeTime == null ? "" : data.TakeTime;
    pushTimeDiff = data.PushTimeDiff == null ? "" : data.PushTimeDiff;
    takeTimeDiff = data.TakeTimeDiff == null ? "" : data.TakeTimeDiff;
    pushTimeDiffStatus =
        data.PushTimeDiffStatus == null ? "" : data.PushTimeDiffStatus;
    takeTimeDiffStatus =
        data.TakeTimeDiffStatus == null ? "" : data.TakeTimeDiffStatus;
    createrName = data.CreaterName == null ? "" : data.CreaterName;
  }
}
