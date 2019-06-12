

import 'package:case_manager/common/model/MaintTableCell.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
/**
 * 個人案件處理item
 * Date: 2019-06-11
 */
class MaintListItem extends StatelessWidget with BaseWidget{
  final MaintListModel model;

  MaintListItem({this.model});

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

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
            child: Row(
              children: <Widget>[
                autoTextSize('立案:', TextStyle(color: Colors.black), context),
                autoTextSize('${model.dataTime}', TextStyle(color: Colors.grey[600]), context),
                SizedBox(width: 5.0,),
                autoTextSize('${model.dataTime2}', TextStyle(color: Colors.grey[600]), context),
                SizedBox(width: 5.0,),
                autoTextSize('${model.pUserName}', TextStyle(color: Colors.grey[600]), context),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
            child: Row(
              children: <Widget>[
                autoTextSize('派案:', TextStyle(color: Colors.black), context),
                autoTextSize('${model.pushTime}', TextStyle(color: Colors.grey[600]), context),

              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
            child: Row(
              children: <Widget>[
                autoTextSize('指派:', TextStyle(color: Colors.black), context),
                autoTextSize('${model.pUserName}', TextStyle(color: Colors.grey[600]), context),
                SizedBox(width: 5.0,),
                autoTextSize('狀態: ', TextStyle(color: Colors.black), context),
                autoTextSize('${model.statusName}', TextStyle(color: statusColor), context)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(color: Color(MyColors.hexFromStr('f2f2f2')), border: Border(bottom: BorderSide(width: 1.0, color: Colors.red))),
              
          )
        ],
      ),
    );
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
    pUserName = data.PUserName == null ? "" : data.PUserName; 
    pushTime = data.PushTime == null ? "" : data.PushTime; 
    takeTime = data.TakeTime == null ? "" : data.TakeTime; 
    pushTimeDiff = data.PushTimeDiff == null ? "" : data.PushTimeDiff; 
    takeTimeDiff = data.TakeTimeDiff == null ? "" : data.TakeTimeDiff; 
    pushTimeDiffStatus = data.PushTimeDiffStatus == null ? "" : data.PushTimeDiffStatus; 
    takeTimeDiffStatus = data.TakeTimeDiffStatus == null ? "" : data.TakeTimeDiffStatus; 
    createrName = data.CreaterName == null ? "" : data.CreaterName; 
  }
}