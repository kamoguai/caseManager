
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/**
 * 詳情頁面顯示
 * Date: 2019-06-18
 */
class DetailItemWidget extends StatelessWidget with BaseWidget{

  final DetailItemModel defaultModel;
  final Map<String, dynamic> data;
  DetailItemWidget({this.defaultModel, this.data});
  
  List<Widget> thirdRowViewR() {
    List<Widget> row = [];
    if (defaultModel.statusName == '新案') {

    }
    else if (defaultModel.statusName == '接案') {

    }
    else if (defaultModel.statusName == '結案') {

    }
    return row;
  }
  
  @override
  Widget build(BuildContext context) {
    var dataTime = '${defaultModel.dataTime} ${defaultModel.dataTime2}';
    final dft = new DateFormat('yyyy/MM/dd HH:mm');
    var createTime = dft.parse(dataTime);
    ///接案時間
    var pushTime;
    var pushTimeStr = "";
    final dft2 = new DateFormat('MM/dd HH:mm');
    var createTimeStr = dft2.format(createTime);
    if (defaultModel.pushTime != "") {
      pushTime = dft.parse(defaultModel.pushTime);
      pushTimeStr = dft2.format(pushTime);
    }
    ///case狀態
    var caseStatusStr = "";
    ///案件狀態
    Color statusColor;
    switch (defaultModel.statusName) {
      case '新案':
        if (defaultModel.pushTimeDiffStatus == "" && defaultModel.pushTimeDiff != "") {
          caseStatusStr = '未接案';
        }
        else {
          caseStatusStr = '新案';
        }
        statusColor = Colors.red;
        break;
      case '接案':
        if (defaultModel.takeTimeDiff != "") {
          caseStatusStr = '未結';
        }
        caseStatusStr = '接案';
        statusColor = Colors.blue;
        break;
      case '結案':
        caseStatusStr = '結案';
        statusColor = Colors.green;
        break;
      default:
        break;
    }


    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  width: deviceWidth5(context) * 3,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      autoTextSize('立案:${defaultModel.createrName} $createTimeStr', TextStyle(color: Colors.grey[600]), context),
                    ],
                  ),
                ),
                buildLineHeight(context),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  width: deviceWidth5(context) * 2 - 1,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      autoTextSizeLeft('類別:${defaultModel.caseTypeName}', TextStyle(color: Colors.blueAccent[400]), context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  width: deviceWidth5(context) * 3,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      autoTextSize('指派:', TextStyle(color: Colors.grey[600]), context),
                      autoTextSize('${defaultModel.pUserName} ', TextStyle(color: Colors.blue[600]), context),
                      autoTextSize('$pushTimeStr', TextStyle(color: Colors.grey[600]), context),
                    ],
                  ),
                ),
                buildLineHeight(context),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 5.0),
                  width: deviceWidth5(context) * 2 - 1,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      autoTextSize('狀態:', TextStyle(color: Colors.grey[600]), context),
                      autoTextSize('${defaultModel.statusName}', TextStyle(color: statusColor), context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  width: deviceWidth5(context) * 3,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      autoTextSize('接案:', TextStyle(color: Colors.grey[600]), context),
                      autoTextSize('${defaultModel.takeTime} ', TextStyle(color: Colors.blue[600]), context),
                    ],
                  ),
                ),
                buildLineHeight(context),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 5.0),
                  width: deviceWidth5(context) * 2 - 1,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      autoTextSize('狀態:', TextStyle(color: Colors.grey[600]), context),
                      autoTextSize('$caseStatusStr', TextStyle(color: statusColor), context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailItemModel {
  String caseNO;
  String dataTime;
  String dataTime2;
  String subject;
  String caseTypeName;
  String qData;
  String area;
  String custNO;
  String custName;
  String tel;
  String mobile;
  String address;
  String createrName;
  String salesName;
  String engineersName;
  String pDeptName;
  String pUserName;
  String pUser2Name;
  String statusName;
  String fUnitName;
  String closeDataTime;
  String closeDataTime2;
  QADatas qADatas;
  String commandTime;
  String pushTime;
  String takeTime;
  String pushTimeDiff;
  String takeTimeDiff;
  String pushTimeDiffStatus;
  String takeTimeDiffStatus;

  DetailItemModel();

  DetailItemModel.forMap(data) {
    caseNO = data["CaseNO"] == null ? "" : data["CaseNO"];
    dataTime = data["DataTime"] == null ? "" : data["DataTime"];
    dataTime2 = data["DataTime2"] == null ? "" : data["DataTime2"];
    subject = data["Subject"] == null ? "" : data["Subject"];
    caseTypeName = data["CaseTypeName"] == null ? "" : data["CaseTypeName"];
    qData = data["QData"] == null ? "" : data["QData"];
    area = data["Area"] == null ? "" : data["Area"];
    custNO = data["CustNO"] == null ? "" : data["CustNO"];
    custName = data["CustName"] == null ? "" : data["CustName"];
    tel = data["Tel"] == null ? "" : data["Tel"];
    mobile = data["Mobile"] == null ? "" : data["Mobile"];
    address = data["Address"] == null ? "" : data["Address"];
    createrName = data["CreaterName"] == null ? "" : data["CreaterName"];
    salesName = data["SalesName"] == null ? "" : data["SalesName"];
    engineersName = data["EngineersName"] == null ? "" : data["EngineersName"];
    pDeptName = data["PDeptName"] == null ? "" : data["PDeptName"];
    pUserName = data["PUserName"] == "" ? "未指派" : data["PUserName"];
    pUser2Name = data["PUser2Name"] == null ? "" : data["PUser2Name"];
    statusName = data["StatusName"] == null ? "" : data["StatusName"];
    fUnitName = data["FUnitName"] == null ? "" : data["FUnitName"];
    closeDataTime = data["CloseDataTime"] == null ? "" : data["CloseDataTime"];
    closeDataTime2 = data["CloseDataTime2"] == null ? "" : data["CloseDataTime2"];
    qADatas = data["QADatas"] == [] ? null : QADatas.forMap(data["QADatas"]);
    commandTime = data["CommandTime"] == null ? "" : data["CommandTime"];
    pushTime = data["PushTime"] == null ? "" : data["PushTime"];
    takeTime = data["TakeTime"] == null ? "" : data["TakeTime"];
    pushTimeDiff = data["PushTimeDiff"] == null ? "" : data["PushTimeDiff"];
    takeTimeDiff = data["TakeTimeDiff"] == null ? "" : data["TakeTimeDiff"];
    pushTimeDiffStatus = data["PushTimeDiffStatus"] == null ? "" : data["PushTimeDiffStatus"];
    takeTimeDiffStatus = data["TakeTimeDiffStatus"] == null ? "" : data["TakeTimeDiffStatus"];
  }
}
class QADatas {
  String createTime;
  String creater;
  String createrName;
  String aData;
  QADatas();
  QADatas.forMap(data) {
    if (data != null && data.length > 0) {
      createTime = data[0]["CreateTime"] == null ? "" : data[0]["CreateTime"];
      creater = data[0]["Creater"] == null ? "" : data[0]["Creater"];
      createrName = data[0]["CreaterName"] == null ? "" : data[0]["CreaterName"];
      aData = data[0]["AData"] == null ? "" : data[0]["AData"];
    }
  }
}