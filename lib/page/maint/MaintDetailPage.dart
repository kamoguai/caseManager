

import 'package:case_manager/common/dao/DetailPageDao.dart';
import 'package:case_manager/common/dao/MaintDao.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:case_manager/widget/DetailFiveBtnWidget.dart';
import 'package:case_manager/widget/DetailItemWidget.dart';
import 'package:flutter/material.dart';
/**
 * 個人案件詳情頁面
 * Date: 2019-06-17
 */
class MaintDetailPage extends StatefulWidget {
  ///由前頁傳入客編
  final custCode;
  ///由前頁傳入使用者id
  final userId;
  ///由前頁傳入案件id
  final caseId;
  MaintDetailPage({this.custCode, this.userId, this.caseId});
  @override
  MaintDetailPageState createState() => MaintDetailPageState();
}

class MaintDetailPageState extends State<MaintDetailPage> with BaseWidget{
  
  ///取得設定檔
  var config;
  ///裝詳情 data
  Map<String,dynamic> dataArray = Map<String,dynamic>();
  ///裝ping data
  Map<String,dynamic> pingArray = Map<String,dynamic>();
  ///裝CPE data
  Map<String,dynamic> cpeArray = Map<String,dynamic>();
  ///裝FLAP data
  Map<String,dynamic> flapArray = Map<String,dynamic>();
  ///保留客編
  var custNoStr = "";
  ///保留客戶名
  var custNameStr = "";
  ///保留cmts
  var cmtsStr = "";
  ///保留cmmac
  var cmmacStr = "";
  
  @override
  void initState() {
    super.initState(); 
    getCaseData();
    getPingData();
  }

  @override
  void dispose() {
    super.dispose();
  }
  ///呼叫maintCase api
  getCaseData() async {
    isLoading = true;
    var res = await MaintDao.getMaintCase(userId: widget.userId, caseId: widget.caseId);
    if (res != null && res.result) {
      dataArray = res.data;
      
    }
  }

  ///呼叫小ping api
  getPingData() async {
    isLoading = true;
    var res = await DetailPageDao.getPingSNR(context, custCode: widget.custCode);
    if (res != null && res.result) {
      pingArray = res.data;
      if(mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    else {
      if(mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  
  /// app bar action按鈕
  List<Widget> actions() {
    List<Widget> list = [
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(width: deviceWidth4(context),),
            Container(
              alignment: Alignment.center,
              height: 30,
              width: deviceWidth3(context) * 1.1,
              child: FlatButton.icon(
                icon: Image.asset('static/images/24.png'),
                color: Colors.transparent,
                label: Text(''),
                onPressed: (){
                  NavigatorUtils.goLogin(context);
                },
              ),
            ),
            SizedBox(width: deviceWidth4(context),),
          ],
        ),
      )
    ];
    return list;
  }
  ///body內容
  Widget bodyView() {
    DetailItemModel model;
    model = DetailItemModel.forMap(dataArray);
    Widget body;
    body = isLoading ? showLoadingAnimeB(context) : Column(
      children: <Widget>[
        DetailFiveBtnWidget(custNoStr: pingArray["CustCode"],custNameStr: pingArray["CustName"],cmtsStr: pingArray["CMTS"], cmmacStr: pingArray["CMMAC"], cwData: pingArray["CodeWord"],),
        buildLine(),
        DetailItemWidget(defaultModel: model, data: dataArray),
      ],
    );
    return body;
  }
  ///bottomNavigationBar 按鈕
  Widget bottomBar() {
    Widget bottom = Material(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth4(context),
              child: autoTextSize('刷新', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),context),
            ),
            onTap: () {
              // showRefreshLoading();
            },
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth4(context),
              child: autoTextSize('查詢', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),context),
            ),
            onTap: (){

            },
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth4(context),
              child: autoTextSize('排序', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),context),
            ),
            onTap: (){

            },
          ),
          
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth4(context),
              child: autoTextSize('返回', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),context),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          
        ],
      ),
    );
    return bottom;
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: Container(),
          elevation: 0.0,
          actions: actions(),
        ),
        body: bodyView(),
        bottomNavigationBar: bottomBar(),
      ),
    );
  }
}