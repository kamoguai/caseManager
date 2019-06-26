
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/dao/DetailPageDao.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:case_manager/widget/dialog/CPEDialog.dart';
import 'package:case_manager/widget/dialog/CWDialog.dart';
import 'package:case_manager/widget/dialog/FLAPDialog.dart';
import 'package:case_manager/widget/dialog/MaintainLogDialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
///詳情頁body最上方五顆按鈕
///Date: 2019-06-17
///
class DetailFiveBtnWidget extends StatelessWidget with BaseWidget {
  ///由前頁傳入客編
  final String custNoStr;
  ///由前頁傳入客名
  final String custNameStr;
  ///由前頁傳入cmts
  final String cmtsStr;
  ///由前頁傳入cmmac
  final String cmmacStr;
  ///由前頁傳入cep data
  final DataResult cpeData;
  ///由前頁傳入flap data
  final DataResult flapData;
  ///由前頁傳入cw data
  final Map<String, dynamic> cwData;

  ///裝CPE data
  Map<String,dynamic> cpeArray = Map<String,dynamic>();
  ///裝FLAP data
  Map<String,dynamic> flapArray = Map<String,dynamic>();

  DetailFiveBtnWidget({this.custNoStr, this.custNameStr, this.cmtsStr, this.cmmacStr, this.cwData, this.cpeData, this.flapData});


  ///呼叫cep api
  getCPEData() async {
    isLoading = true;
    var res = await DetailPageDao.getCPEData(cmts: cmtsStr, cmmac: cmmacStr);
    return res;
  }
  ///呼叫flap api
  getFLAPData() async {
    isLoading = true;
    var res = await DetailPageDao.getFLAPData(cmts: cmtsStr, cmmac: cmmacStr);
    return res;
  }
  ///清除flap api
  clearFlapData() async {
    isLoading = true;
    var res = await DetailPageDao.clearFLAPData(cmts: cmtsStr, cmmac: cmmacStr);
    return res;
  }

  ///清除flap function
  void _clearFlapFunc() async {
    if (isLoading) {
      Fluttertoast.showToast(msg: '資料讀取中..');
      return;
    }
    var res = await clearFlapData();
    if(res != null && res.result) {
      Fluttertoast.showToast(msg: res.data["MSG"]);
    }
  }

  ///cw dialog
  Widget cwDialog(BuildContext context, data) {
    CWViewModel model;
    model = CWViewModel.forMap(data);
    return Material(
       type: MaterialType.transparency,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.end,
         children: <Widget>[
           Card(
             child: CWDialog(data: data, defaultViewModel: model,),
           ),
           SizedBox(height: 38,)
         ],
       ),
    );
  }

  ///cpe dialog
  Widget cpeDialog(BuildContext context, data) {
    return Material(
       type: MaterialType.transparency,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.end,
         children: <Widget>[
           Card(
             child: CPEDialog(custNoStr, custNameStr, data.data),
           ),
           SizedBox(height: 38,)
         ],
       ),
    );
  }
  ///flap dialog
  Widget flapDialog(BuildContext context, data) {
    FlapViewModel model;
    model = FlapViewModel.forMap(data.data);
    return Material(
       type: MaterialType.transparency,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.end,
         children: <Widget>[
           Card(
             child: FLAPDialog(custNo: custNoStr, custName: custNameStr, data: data.data, defaultViewModel: model, clearFlapFunc: _clearFlapFunc,),
           ),
           SizedBox(height: 38,)
         ],
       ),
    );
  }
  ///maintain dialog
  Widget maintainDialog(BuildContext context,) {
    
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            child: MaintainLogDialog(custNo: custNoStr, custName: custNameStr,),
          ),
          SizedBox(height: 38,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    Widget bodyView;
    ///小size手機畫面，iphone se大小
    if (deviceHeight < 600) {
      bodyView = Container(
        constraints: BoxConstraints.expand(height: 50),
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(color: Color(MyColors.hexFromStr('f1f1f1')), borderRadius: BorderRadius.circular(4.0), border: Border.all(width: 1.0, color: Colors.grey, style: BorderStyle.solid)),
              height: 30,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(

                  child: autoTextSize('CW', TextStyle(color: Colors.black), context),
                  
                ),
                onTap: (){
                  if (cwData == null) {
                    Fluttertoast.showToast(msg: '查無資料!');
                    return;
                  }
                  Fluttertoast.showToast(msg: '資料讀取中，請稍候..');
                  Future.delayed(const Duration(seconds: 1),() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => cwDialog(context, cwData)
                    );
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(color: Color(MyColors.hexFromStr('f0fcff')), borderRadius: BorderRadius.circular(4.0), border: Border.all(width: 1.0, color: Colors.grey, style: BorderStyle.solid)),
              height: 30,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(

                  child: autoTextSize('CPE', TextStyle(color: Colors.black), context),
                  
                ),
                onTap: () async{
                  if(cwData == null || cmtsStr == '---') {
                    Fluttertoast.showToast(msg: '查無資料!');
                    return;
                  }
                  Fluttertoast.showToast(msg: '資料讀取中，請稍候..');
                  var res = await getCPEData();
                  Future.delayed(const Duration(seconds: 1),() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => cpeDialog(context, res)
                    );
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(color: Color(MyColors.hexFromStr('fef5f6')), borderRadius: BorderRadius.circular(4.0), border: Border.all(width: 1.0, color: Colors.grey, style: BorderStyle.solid)),
              height: 30,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(

                  child: autoTextSize('FLAP', TextStyle(color: Colors.black), context),
                  
                ),
                onTap: () async {
                  if(cwData == null || cmtsStr == '---') {
                    Fluttertoast.showToast(msg: '查無資料!');
                    return;
                  }
                  Fluttertoast.showToast(msg: '資料讀取中，請稍候..');
                  var res = await getFLAPData();
                  Future.delayed(const Duration(seconds: 1),() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => flapDialog(context, res)
                    );
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(color: Color(MyColors.hexFromStr('eeffec')), borderRadius: BorderRadius.circular(4.0), border: Border.all(width: 1.0, color: Colors.grey, style: BorderStyle.solid)),
              height: 30,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(

                  child: autoTextSize('追蹤記錄', TextStyle(color: Colors.black), context),
                  
                ),
                onTap: (){
                  
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(color: Color(MyColors.hexFromStr('fff7dc')), borderRadius: BorderRadius.circular(4.0), border: Border.all(width: 1.0, color: Colors.grey, style: BorderStyle.solid)),
              height: 30,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(

                  child: autoTextSize('維修記錄', TextStyle(color: Colors.black), context),
                  
                ),
                onTap: (){
                  if(custNoStr == null || custNoStr == '') {
                    Fluttertoast.showToast(msg: '查無資料!');
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => maintainDialog(context)
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
    else {
      bodyView = Container(
        constraints: BoxConstraints.expand(height: 50),
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(color: Color(MyColors.hexFromStr('f1f1f1')), borderRadius: BorderRadius.circular(4.0), border: Border.all(width: 1.0, color: Colors.grey, style: BorderStyle.solid)),
              height: 30,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(

                  child: autoTextSize('CW', TextStyle(color: Colors.black), context),
                  
                ),
                onTap: (){
                  if (cwData == null) {
                    Fluttertoast.showToast(msg: '查無資料!');
                    return;
                  }
                  Fluttertoast.showToast(msg: '資料讀取中，請稍候..');
                  Future.delayed(const Duration(seconds: 1),() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => cwDialog(context, cwData)
                    );
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(color: Color(MyColors.hexFromStr('f0fcff')), borderRadius: BorderRadius.circular(4.0), border: Border.all(width: 1.0, color: Colors.grey, style: BorderStyle.solid)),
              height: 30,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(

                  child: autoTextSize('CPE', TextStyle(color: Colors.black), context),
                  
                ),
                onTap: () async{
                  if(cwData == null || cmtsStr == '---') {
                    Fluttertoast.showToast(msg: '查無資料!');
                    return;
                  }
                  Fluttertoast.showToast(msg: '資料讀取中，請稍候..');
                  var res = await getCPEData();
                  Future.delayed(const Duration(seconds: 1),() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => cpeDialog(context, res)
                    );
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(color: Color(MyColors.hexFromStr('fef5f6')), borderRadius: BorderRadius.circular(4.0), border: Border.all(width: 1.0, color: Colors.grey, style: BorderStyle.solid)),
              height: 30,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(

                  child: autoTextSize('FLAP', TextStyle(color: Colors.black), context),
                  
                ),
                onTap: () async {
                  if(cwData == null || cmtsStr == '---') {
                    Fluttertoast.showToast(msg: '查無資料!');
                    return;
                  }
                  Fluttertoast.showToast(msg: '資料讀取中，請稍候..');
                  var res = await getFLAPData();
                  Future.delayed(const Duration(seconds: 1),() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => flapDialog(context, res)
                    );
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(color: Color(MyColors.hexFromStr('eeffec')), borderRadius: BorderRadius.circular(4.0), border: Border.all(width: 1.0, color: Colors.grey, style: BorderStyle.solid)),
              height: 30,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(

                  child: autoTextSize('追蹤記錄', TextStyle(color: Colors.black), context),
                  
                ),
                onTap: (){
                  
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(color: Color(MyColors.hexFromStr('fff7dc')), borderRadius: BorderRadius.circular(4.0), border: Border.all(width: 1.0, color: Colors.grey, style: BorderStyle.solid)),
              height: 30,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(

                  child: autoTextSize('維修記錄', TextStyle(color: Colors.black), context),
                  
                ),
                onTap: (){
                  if(custNoStr == null || custNoStr == '') {
                    Fluttertoast.showToast(msg: '查無資料!');
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => maintainDialog(context)
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
    return bodyView;
  }
}