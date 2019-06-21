
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/CommonUtils.dart';
///
///如snr ping資料的顯示
///Date: 2019-06-20
///
class PingItem extends StatelessWidget with BaseWidget {
  
  final PingViewModel defaultViewModel;
  final dynamic configData;
  PingItem({this.defaultViewModel, this.configData});

  @override
  buildLineHeight(context) {
    
    return new Container(
      height: 25,
      width: 1.0,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    var netType = 'EXT';
    Map<String, dynamic> snr0 = {};
    Map<String, dynamic> snr1 = {};
    Map<String, dynamic> snr2 = {};
    Map<String, dynamic> snr3 = {};
    Map<String, dynamic> pwr0 = {};
    Map<String, dynamic> pwr1 = {};
    Map<String, dynamic> pwr2 = {};
    Map<String, dynamic> pwr3 = {};
    Map<String, dynamic> u = {};

    if (defaultViewModel.snr != null) {
      u = defaultViewModel.snr.u0;
      snr0 = u;
      pwr0 = u;
      u = defaultViewModel.snr.u1;
      snr1 = u;
      pwr1 = u;
      u = defaultViewModel.snr.u2;
      snr2 = u;
      pwr2 = u;
      u = defaultViewModel.snr.u3;
      snr3 = u;
      pwr3 = u;
    }
    else {
      snr0 = {"SNR":""};
      snr1 = {"SNR":""};
      snr2 = {"SNR":""};
      snr3 = {"SNR":""};
      pwr0 = {"PWR":""};
      pwr1 = {"PWR":""};
      pwr2 = {"PWR":""};
      pwr3 = {"PWR":""};
    }

    var netStatus = "";
    if(defaultViewModel.status == "") {
      netStatus = "";
    }
    else if (defaultViewModel.status == "online"){
      netStatus = "上線";
    }
    else{
      netStatus = "離線";
    }

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(top: 2.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: deviceWidth3(context) - 1,
                  child: autoTextSize('${defaultViewModel.installDate}', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: deviceWidth3(context) - 1,
                  child: autoTextSize('${defaultViewModel.installMan}', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: deviceWidth3(context) - 1,
                  child: autoTextSize('${defaultViewModel.saleMan}', TextStyle(color: Colors.black), context),
                ),
              ],
            ),
          ),
          buildLine(),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context) * 2 + deviceWidth9(context) * 0.5) - 1,
                  child: autoTextSize('${defaultViewModel.custCode}', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context) + deviceWidth9(context) * 0.5) - 1,
                  child: autoTextSize('${defaultViewModel.custName}', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: deviceWidth9(context) * 3 - 1,
                  child: autoTextSize('${defaultViewModel.buildingName}', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  alignment: Alignment.center,
                  height: 25,
                  width: deviceWidth9(context) * 2,
                  child: autoTextSize('${defaultViewModel.onlineTime}', TextStyle(color: Colors.blue), context),
                ),
              ],
            ),
          ),
          buildLine(),
          Container(
            height: 52,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: Colors.grey,
                  style: BorderStyle.solid
                )
              )
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: deviceWidth92(context) - 1,
                  padding: EdgeInsets.all(10),
                  child: autoTextSize('', TextStyle(color: Colors.red, fontWeight: FontWeight.bold), context),
                ),
                buildHeightLine51(),
                Container(
                  color: Color(MyColors.hexFromStr('#ffeef1')),
                  width: ((deviceWidth9(context) * 4)) - 1,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 25, 
                            alignment: Alignment.center, 
                            width: deviceWidth9(context) - 1,
                            child: autoTextSize(snr0["SNR"],
                                  TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(snr0["SNR"], 'U0_SNR', netType, configData))), context),
                          ),
                          buildLineHeight(context),
                          Container(
                            height: 25,
                            alignment: Alignment.center, 
                            width: deviceWidth9(context) - 1,
                            child: autoTextSize(snr1["SNR"],
                                TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(snr1["SNR"], 'U1_SNR', netType, configData))), context),
                          ),
                          buildLineHeight(context),
                          Container(
                            height: 25,
                            alignment: Alignment.center, 
                            width: deviceWidth9(context) - 1,
                            child: autoTextSize(snr2["SNR"],
                                TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(snr2["SNR"], 'U2_SNR', netType, configData))), context),
                          ),
                          buildLineHeight(context),
                          Container(
                            height: 25,
                            alignment: Alignment.center, 
                            width: deviceWidth9(context) - 1,
                            child: autoTextSize(snr3["SNR"],
                                TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(snr3["SNR"], 'U3_SNR', netType, configData))), context),
                          ),
                        ],
                      ),
                       buildLine(),
                       Row(
                         children: <Widget>[
                           Container(
                              height: 25,
                              alignment: Alignment.center, 
                              width: deviceWidth9(context) - 1,
                              child: autoTextSize(pwr0["PWR"],
                                  TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(pwr0["PWR"], 'U0_PWR', netType, configData))), context),
                            ),
                            buildLineHeight(context),
                            Container(
                              height: 25,
                              alignment: Alignment.center, 
                              width: deviceWidth9(context) - 1,
                              child: autoTextSize(pwr1["PWR"],
                                  TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(pwr1["PWR"], 'U1_PWR', netType, configData))), context),
                            ),
                            buildLineHeight(context),
                            Container(
                              height: 25,
                              alignment: Alignment.center, 
                              width: deviceWidth9(context) - 1,
                              child: autoTextSize(pwr2["PWR"],
                                  TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(pwr2["PWR"], 'U2_PWR', netType, configData))), context),
                            ),
                            buildLineHeight(context),
                            Container(
                              height: 25,
                              alignment: Alignment.center, 
                              width: deviceWidth9(context) - 1,
                              child: autoTextSize(pwr3["PWR"],
                                  TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(pwr3["PWR"], 'U3_PWR', netType, configData))), context),
                            ),
                         ],
                       )
                    ],
                  ),
                ),
                buildHeightLine51(),
                Container(
                  width: deviceWidth92(context) - 1,
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                        style: BorderStyle.solid
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: autoTextSize('PING', TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), context),
                    onPressed: (){},
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color(MyColors.hexFromStr('#f1f1f1')),
            height: 25.0,
            child: Row(
              children: <Widget>[
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.dsMer, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.dp0, 'DSMER_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.ds0, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.ds0, 'DS0_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.ds1, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.ds1, 'DS1_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.ds2, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.ds2, 'DS2_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.ds3, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.ds3, 'DS3_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.ds4, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.ds4, 'DS4_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.ds5, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.ds5, 'DS5_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.ds6, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.ds6, 'DS6_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.ds7, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.ds7, 'DS7_PING', netType, configData))), context),
                ),
              ],
            ),
          ),
          buildLine(),
          Container(
            color: Color(MyColors.hexFromStr('#f1f1f1')),
            height: 25.0,
            child: Row(
              children: <Widget>[
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.dsdb, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.dp0, 'DSDB_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.dp0, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.dp0, 'DP0_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.dp1, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.dp1, 'DP1_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.dp2, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.dp2, 'DP2_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.dp3, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.dp3, 'DP3_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.dp4, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.dp4, 'DP4_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.dp5, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.dp5, 'DP5_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.dp6, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.dp6, 'DP6_PING', netType, configData))), context),
                ),
                buildLineHeight(context),
                Container(
                  width: deviceWidth9(context) - 1,
                  child: autoTextSize(defaultViewModel.dp7, TextStyle(color: Color(CommonUtils.checkSnrConfigureValueColor(defaultViewModel.dp7, 'DP7_PING', netType, configData))), context),
                ),
              ],
            ),
          ),
          buildLine(),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context) * 1.5) - 1,
                  child: autoTextSize(netStatus, TextStyle(color: defaultViewModel.status == "online" ? Colors.blue : Colors.red), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context) * 1.5) - 1,
                  child: autoTextSize(defaultViewModel.bb, TextStyle(color: Colors.blue), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context)) - 1,
                  child: autoTextSize(defaultViewModel.note2, TextStyle(color: Color(MyColors.hexFromStr(defaultViewModel.note2color))), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context)) - 1,
                  child: autoTextSize(defaultViewModel.note3, TextStyle(color: Color(MyColors.hexFromStr(defaultViewModel.note3color))), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context)) - 1,
                  child: autoTextSize(defaultViewModel.note4, TextStyle(color: Color(MyColors.hexFromStr(defaultViewModel.note4color))), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context)) - 1,
                  child: autoTextSize(defaultViewModel.note5, TextStyle(color: Color(MyColors.hexFromStr(defaultViewModel.note4color))), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context) * 2),
                  child: autoTextSize(defaultViewModel.pingTime, TextStyle(color: Color(MyColors.hexFromStr(defaultViewModel.note5color))), context),
                ),
              ],
            ),
          ),
          buildLine(),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context) * 2.5) - 1,
                  child: autoTextSize('上:${defaultViewModel.usflow}', TextStyle(color: Colors.red), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context) * 2.5) - 1,
                  child: autoTextSize('下:${defaultViewModel.dsflow}', TextStyle(color: Colors.blue), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context) * 2) - 1,
                  child: autoTextSize('回:${defaultViewModel.response}', TextStyle(color: Colors.black), context),
                ),
                buildLineHeight(context),
                Container(
                  height: 25,
                  alignment: Alignment.center, 
                  width: (deviceWidth9(context) * 2) - 1,
                  child: autoTextSize('掉:${defaultViewModel.packetLoss}', TextStyle(color: Colors.black), context),
                ),
              ],
            ),
          ),
          buildLine(),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}

class PingViewModel {
  String installDate;
  String installMan;
  String saleMan;
  String mac;
  String cmts;
  String cif;
  String node;
  String custCode;
  String onlineTime;
  String cmswver;
  String custName;
  String bb;
  String buildingName;
  String ds0;
  String ds1;
  String ds2;
  String ds3;
  String ds4;
  String ds5;
  String ds6;
  String ds7;
  String dp0;
  String dp1;
  String dp2;
  String dp3;
  String dp4;
  String dp5;
  String dp6;
  String dp7;
  String dsdb;
  String dsMer;
  String status;
  String pingTime;
  String note1;
  String note1color;
  String note2;
  String note2color;
  String note3;
  String note3color;
  String note4;
  String note4color;
  String note5;
  String note5color;
  String usflow;
  String dsflow;
  String response;
  String packetLoss;

  SNR snr;
  CodeWord codeWord;

  PingViewModel();

  PingViewModel.forMap(data) {
    installMan = data["InstallMan"] == null ? "" : data["InstallMan"];
    installDate = data["InstallDate"] == null ? "" : data["InstallDate"];
    saleMan = data["SaleMan"] == null ? "" : data["SaleMan"];
    mac = data["MAC"] == null ? "" : data["MAC"];
    cmts = data["CMTS"] == null ? "" : data["CMTS"];
    cif = data["CIF"] == null ? "" : data["CIF"];
    node = data["NODE"] == null ? "" : data["NODE"];
    custCode = data["CustCode"] == null ? "" : data["CustCode"];
    onlineTime = data["ONLINETIME"] == null ? "" : data["ONLINETIME"];
    cmswver = data["CMSWVER"] == null ? "" : data["CMSWVER"];
    custName = data["CustName"] == null ? "" : data["CustName"];
    note1 = data["note1"] == null ? "" : data["note1"];
    note1color = data["note1color"] == null ? "000000" : data["note1color"];
    ds0 = data["DS0"] == null ? "" : data["DS0"];
    ds1 = data["DS1"] == null ? "" : data["DS1"];
    ds2 = data["DS2"] == null ? "" : data["DS2"];
    ds3 = data["DS3"] == null ? "" : data["DS3"];
    ds4 = data["DS4"] == null ? "" : data["DS4"];
    ds5 = data["DS5"] == null ? "" : data["DS5"];
    ds6 = data["DS6"] == null ? "" : data["DS6"];
    ds7 = data["DS7"] == null ? "" : data["DS7"];
    dp0 = data["DP0"] == null ? "" : data["DP0"];
    dp1 = data["DP1"] == null ? "" : data["DP1"];
    dp2 = data["DP2"] == null ? "" : data["DP2"];
    dp3 = data["DP3"] == null ? "" : data["DP3"];
    dp4 = data["DP4"] == null ? "" : data["DP4"];
    dp5 = data["DP5"] == null ? "" : data["DP5"];
    dp6 = data["DP6"] == null ? "" : data["DP6"];
    dp7 = data["DP7"] == null ? "" : data["DP7"];
    dsdb = data["DSDB"] == null ? "" : data["DSDB"];
    dsMer = data["DSMER"] == null ? "" : data["DSMER"];
    status = data["STATUS"] == null ? "" : data["STATUS"];
    bb = data["BB"] == null ? "" : data["BB"];
    buildingName = data["BuildingName"] == null ? "" : data["BuildingName"];
    pingTime = data["PINGTIME"] == null ? "" : data["PINGTIME"];
    note2 = data["note2"] == null ? "" : data["note2"];
    note2color = data["note2color"] == null ? "000000" : data["note2color"];
    note3 = data["note3"] == null ? "" : data["note3"];
    note3color = data["note3color"] == null ? "000000" : data["note3color"];
    note4 = data["note4"] == null ? "" : data["note4"];
    note4color = data["note4color"] == null ? "000000" : data["note4color"];
    note5 = data["note5"] == null ? "" : data["note5"];
    note5color = data["note5color"] == null ? "000000" : data["note5color"];
    usflow = data["USFLOW"] == null ? "" : data["USFLOW"];
    dsflow = data["DSFLOW"] == null ? "" : data["DSFLOW"];
    response = data["Response"] == null ? "" : data["Response"];
    packetLoss = data["PacketLoss"] == null ? "" : data["PacketLoss"];
    if (data["SNR"] != null && data["SNR"] != {}) {
      snr = SNR.forMap(data["SNR"]);
    }
    else {
      snr = null;
    }
    if (data["CodeWord"] != null && data["CodeWord"] != {}) {
      codeWord = CodeWord.forMap(data["CodeWord"]);
    }
    else {
      codeWord = null;
    }
  }
}
class SNR {
  Map<String,dynamic> u0;
  Map<String,dynamic> u1;
  Map<String,dynamic> u2;
  Map<String,dynamic> u3;
  SNR();
  SNR.forMap(data) {
    u0 = data["U0"] == null ? null : data["U0"];
    u1 = data["U1"] == null ? null : data["U1"];
    u2 = data["U2"] == null ? null : data["U2"];
    u3 = data["U3"] == null ? null : data["U3"];
  }
}
class CodeWord {
  Map<String,dynamic> u0;
  Map<String,dynamic> u1;
  Map<String,dynamic> u2;
  Map<String,dynamic> u3;
  CodeWord();
  CodeWord.forMap(data) {
    u0 = data["U0"] == null ? null : data["U0"];
    u1 = data["U1"] == null ? null : data["U1"];
    u2 = data["U2"] == null ? null : data["U2"];
    u3 = data["U3"] == null ? null : data["U3"];
  }
}
