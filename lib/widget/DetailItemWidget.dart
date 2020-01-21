
import 'package:auto_size_text/auto_size_text.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///
///詳情頁面顯示
///Date: 2019-06-18
///
class DetailItemWidget extends StatelessWidget with BaseWidget{
  ///set, get
  final DetailItemModel defaultModel;
  ///裝data
  final Map<String, dynamic> data;
  ///來自功能
  final fromFunc;
  DetailItemWidget({this.defaultModel, this.data, this.fromFunc});
  
 
  @override
  autoTextSizeLeft(text, style, context) {
    var fontSize = MyScreen.defaultTableCellFontSize(context);
    var fontStyle = TextStyle(fontSize: fontSize);
    return AutoSizeText(
      text,
      style: style.merge(fontStyle),
      minFontSize: 5.0,
      textAlign: TextAlign.left,
    );
  }
  @override
  autoTextSize(text, style, context) {
    var fontSize = MyScreen.defaultTableCellFontSize(context);
    var fontStyle = TextStyle(fontSize: fontSize);
    return AutoSizeText(
      text,
      style: style.merge(fontStyle),
      minFontSize: 5.0,
      textAlign: TextAlign.left,
    );
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
    ///第一條row顯示
    List<Widget> firstRowView() {
      List<Widget> row = [];
      row.add(
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          width: deviceWidth5(context) * 3,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: autoTextSize('立案:${defaultModel.createrName} $createTimeStr', TextStyle(color: Colors.grey[600]), context),
              ),
              
            ],
          ),
        ),
      );
      row.add(buildLineHeight(context),);
      row.add(
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          width: deviceWidth5(context) * 2 - 1,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: autoTextSizeLeft('類別:${defaultModel.caseTypeName}', TextStyle(color: Colors.blueAccent[400], fontSize: MyScreen.appBarFontSize(context)), context),
              ),
            ],
          ),
        ),
      );
      return row;
    }
    ///第二條row顯示
    List<Widget> secondRowView() {
      List<Widget> row = [];
      row.add(
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          width: deviceWidth5(context) * 3,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: autoTextSize('指派:', TextStyle(color: Colors.grey[600]), context),
              ),
              Container(
                alignment: Alignment.center,
                child: autoTextSize('${defaultModel.pUserName} ', TextStyle(color: Colors.blue[600]), context),
              ),
              Container(
                alignment: Alignment.center,
                child: autoTextSize('$pushTimeStr', TextStyle(color: Colors.grey[600]), context),
              ),
            ],
          ),
        ),
      );
      row.add(buildLineHeight(context),);
      row.add(
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 5.0),
          width: deviceWidth5(context) * 2 - 1,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: autoTextSize('狀態:', TextStyle(color: Colors.grey[600]), context),
              ),
              Container(
                alignment: Alignment.center,
                child: autoTextSize('${defaultModel.statusName}', TextStyle(color: statusColor), context),
              ),
            ],
          ),
        ),
      );
      return row;
    }
    ///第三條row顯示
    List<Widget> thirdRowView() {
      List<Widget> row = [];
      if (defaultModel.statusName == '新案') {
        if (defaultModel.pUserName == '未指派') {
          var createTime = '${defaultModel.dataTime} ${defaultModel.dataTime2}';
          final dft = new DateFormat('yyyy/MM/dd HH:mm');
          final dft2 = new DateFormat('yy/MM/dd HH:mm');
          var cTime = dft.parse(createTime);
          var cTimeStr = dft2.format(cTime);
          row.add(
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              width: deviceWidth5(context) * 3,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: autoTextSize('立案:', TextStyle(color: Colors.indigo),context),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: autoTextSize('$cTimeStr', TextStyle(color: Colors.grey[600]), context)
                  ),
                ],
              ),
            )
          );
          row.add(buildLineHeight(context),);
        }
        else {
          var pushTime = '${defaultModel.pushTime}';
          var pTime;
          var pTimeStr;
          if (pushTime.isEmpty) {
            pTimeStr = "";
          }
          else {
            final dft = new DateFormat('yyyy/MM/dd HH:mm');
            final dft2 = new DateFormat('yy/MM/dd HH:mm');
            pTime = dft.parse(pushTime);
            pTimeStr = dft2.format(pTime);
          }
          row.add(
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              width: deviceWidth5(context) * 3,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: autoTextSize('派案:', TextStyle(color: Colors.indigo), context),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: autoTextSize('$pTimeStr', TextStyle(color: Colors.grey[600]), context)
                  ),
                ],
              ),
            )
          );
          row.add(buildLineHeight(context));
          if(defaultModel.pushTimeDiffStatus == "" && defaultModel.pushTimeDiff != "") {
            row.add(
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                width: deviceWidth5(context) * 2 - 1,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: autoTextSize('未接:', TextStyle(color: Colors.grey[600]), context),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: autoTextSize('${defaultModel.pushTimeDiff}', TextStyle(color: Colors.indigo), context)
                    ),
                  ],
                ),
              )
            );
            return row;
          }
        }
      }
      else if (defaultModel.statusName == '接案') {
        var tTimeStr;
        if (defaultModel.takeTime != "") {
          var takeTime = '${defaultModel.takeTime}';
          final dft = new DateFormat('yyyy/MM/dd HH:mm');
          final dft2 = new DateFormat('yy/MM/dd HH:mm');
          var tTime = dft.parse(takeTime);
          tTimeStr = dft2.format(tTime);
        }
        else {
          tTimeStr = "";
        }
        if (defaultModel.takeTimeDiff == "") {
          row.add(
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              width: deviceWidth5(context) * 3,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: autoTextSize('接案:', TextStyle(color: Colors.indigo), context),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: autoTextSize('$tTimeStr', TextStyle(color: Colors.indigo), context)
                  ),
                ],
              ),
            )
          );
          row.add(buildLineHeight(context));
          row.add(
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              width: deviceWidth5(context) * 2 - 1,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  autoTextSize('未結:', TextStyle(color: Colors.indigo), context),
                ],
              ),
            )
          );
        }
        else {
          Color col;
          if (defaultModel.takeTimeDiffStatus == "1") {
            col = Colors.red;
          }
          else {
            col = Colors.indigo;
          }
          row.add(
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              width: deviceWidth5(context) * 3,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: autoTextSize('接案:', TextStyle(color: Colors.indigo), context),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: autoTextSize('$tTimeStr', TextStyle(color: Colors.grey[600]), context)
                  ),
                ],
              ),
            )
          );
          row.add(buildLineHeight(context));
          row.add(
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              width: deviceWidth5(context) * 2 - 1,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: autoTextSize('未結:', TextStyle(color: Colors.indigo), context),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: autoTextSize('${defaultModel.takeTimeDiff}', TextStyle(color: col), context)
                  ),
                ],
              ),
            )
          );
        }
      }
      else if (defaultModel.statusName == '結案' || defaultModel.statusName == '單位結案') {
        var closeTime = '${defaultModel.closeDataTime} ${defaultModel.closeDataTime2}';
        final dft = new DateFormat('yyyy/MM/dd HH:mm:ss');
        final dft2 = new DateFormat('yy/MM/dd HH:mm');
        var cTime = dft.parse(closeTime);
        var cTimeStr = dft2.format(cTime);
        row.add(
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            width: deviceWidth5(context) * 3,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: autoTextSize('結案:', TextStyle(color: Colors.green), context),
                ),
                Container(
                  alignment: Alignment.center,
                  child: autoTextSize('$cTimeStr', TextStyle(color: Colors.grey[600]), context)
                ),
              ],
            ),
          )
        );
        row.add(buildLineHeight(context));
        var strStartDate = '${defaultModel.dataTime} ${defaultModel.dataTime2}';

        var strCloseDataTime = '${defaultModel.closeDataTime} ${defaultModel.closeDataTime2}';
        if (strStartDate.length < 19) {
          strStartDate = strStartDate + ':00';
        }
        var myStartDate = dft.parse(strStartDate);
        var myDateClose = strCloseDataTime;
        if (myDateClose.length < 19) {
          myDateClose = myDateClose + ":00";
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
        if (defaultModel.pushTimeDiffStatus == "1") {
          col = Colors.red;
        }
        else {
          col = Colors.indigo;
        }
        row.add(
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            width: deviceWidth5(context) * 2 - 1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: autoTextSize('耗時:', TextStyle(color: Colors.grey[600]), context),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Icon(Icons.access_time, size: 20,),
                ),
                Container(
                  alignment: Alignment.center,
                  child: autoTextSize('$inday天$inhour時$inminut分', TextStyle(color: col), context)
                ),
              ],
            ),
          )
        );
      }
      return row;
    }
    ///第四條row顯示
    List<Widget> fourthRowView() {
      List<Widget> row = [];
      var phone = "";
      if (defaultModel.tel != "" && defaultModel.mobile != "") {
        phone = '${defaultModel.tel}．${defaultModel.mobile}';
      }
      else if (defaultModel.tel != "") {
        phone = '${defaultModel.tel}';
      }
      else if (defaultModel.mobile != "") {
        phone = '${defaultModel.mobile}';
      }
      row.add(
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            alignment: Alignment.center,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: autoTextSize('姓名:${defaultModel.custName} 電話:$phone', TextStyle(color: Colors.grey[600]), context),
                )
              ],
            ),
          )
        )
      );
      
      return row;
    }
    ///第五條row顯示
    List<Widget> fifthRowView() {
      List<Widget> row = [];
      row.add(
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            alignment: Alignment.center,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: autoTextSize('地址:', TextStyle(color: Colors.black), context),
                ),
                Container(
                  alignment: Alignment.center,
                  child: autoTextSize('${defaultModel.address}', TextStyle(color: Colors.grey[600]), context),
                ),
              ],
            ),
            
          )
        ),
      );
      return row;
    }
    ///第六條row顯示
    List<Widget> sixthRowView() {
      List<Widget> row = [];
      row.add(
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.topCenter,
            child: autoTextSizeLeft('說明:', TextStyle(color: Colors.grey[600], fontSize: MyScreen.appBarFontSize(context)), context),
          )
          
        ),
      );
      row.add(
        Expanded(
          flex: 6,
          child: autoTextSizeLeft('${defaultModel.qData}', TextStyle(color: Colors.grey[600], fontSize: MyScreen.appBarFontSize(context)), context),
        )
      );
      return row;
    }
    ///第七條row顯示
    List<Widget> seventhRowView() {
      List<Widget> row = [];
      row.add(
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.topCenter,
            child: autoTextSizeLeft('處理:', TextStyle(color: Colors.grey[600], fontSize: MyScreen.appBarFontSize(context)), context),
          ),
          
        )
      );
      if (defaultModel.qADatas != null && defaultModel.qADatas.length > 0) {
        var appendStr = "";
        var i = 0;
        for (var dic in defaultModel.qADatas) {
          appendStr += dic.aData;
          appendStr += '\n';
          appendStr += dic.createTime + ' ' + dic.createrName;
          if (i < defaultModel.qADatas.length - 1) {
             appendStr += '\n\n';
          }
          else {
            appendStr += '\n';
          }
          i += 1;
        }
        row.add(
          Expanded(
            flex: 6,
            child: autoTextSizeLeft('$appendStr', TextStyle(color: Colors.grey[600], fontSize: MyScreen.appBarFontSize(context)), context),
          )
        );
      }
      else {
        row.add(
          Expanded(
            flex: 6,
            child: autoTextSizeLeft('尚無資料', TextStyle(color: Colors.grey[600], fontSize: MyScreen.appBarFontSize(context)), context),
          )
        );
      }
      return row;
    }

    Widget content = Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: firstRowView()
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: secondRowView()
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: thirdRowView()
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(color: Color(MyColors.hexFromStr('f2f2f2')), border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: fourthRowView()
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(color: Color(MyColors.hexFromStr('f2f2f2')), border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: fifthRowView()
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Color(MyColors.hexFromStr('f4ffff')), border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: sixthRowView(),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Color(MyColors.hexFromStr('fff7f6')), border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: seventhRowView(),
            ),
          ),
        ],
      ),
    );
    return Stack(
      children: <Widget>[
        content,
        Positioned(
          right: 10.0,
          bottom: 3,
          child: GestureDetector(
            child: Container(),
            // child: Container(
            //   padding: EdgeInsets.all(3.0),
            //   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.0, color: Colors.indigo, style: BorderStyle.solid)),
            //   child: Text('轉追蹤', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: MyScreen.appBarFontSize(context)),),
            // ),
          ),
        )
      ],
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
  List<QADatas> qADatas;
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
    tel = data["Tel"] == "nullnull" ? "" : data["Tel"];
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
    if (data["QADatas"] != null && data["QADatas"] != []) {
      List<QADatas> list = [];
      var datas = data["QADatas"];
      for (var dic in datas) {
        list.add(QADatas.forMap(dic));
      }
      qADatas = list;
    }
    else {
      qADatas = null;
    }
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
      createTime = data["CreateTime"] == null ? "" : data["CreateTime"];
      creater = data["Creater"] == null ? "" : data["Creater"];
      createrName = data["CreaterName"] == null ? "" : data["CreaterName"];
      aData = data["AData"] == null ? "" : data["AData"];
    }
  }
}