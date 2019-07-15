
import 'dart:convert';

import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DPMaintDao.dart';
import 'package:case_manager/common/dao/DetailPageDao.dart';
import 'package:case_manager/common/dao/FileDao.dart';
import 'package:case_manager/common/dao/UserInfoDao.dart';
import 'package:case_manager/common/local/LocalStorage.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:case_manager/widget/DetailFiveBtnWidget.dart';
import 'package:case_manager/widget/DetailItemWidget.dart';
import 'package:case_manager/widget/dialog/SignalLogDialog.dart';
import 'package:case_manager/widget/items/PingItem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
///歸檔詳情/案件結案詳情
///Date: 2019-07-01
class FileDetailPage extends StatefulWidget {
  ///由前頁傳入客編
  final custCode;
  ///由前頁傳入使用者id
  final userId;
  ///由前頁傳入案件id
  final caseId;
  ///由前頁傳入案件狀態
  final statusName;
  ///由前頁傳入來自function
  final fromFunc;
  FileDetailPage({this.custCode, this.userId, this.caseId, this.statusName, this.fromFunc});
  @override
  _FileDetailPageState createState() => _FileDetailPageState();
}

class _FileDetailPageState extends State<FileDetailPage> with BaseWidget {
 ///取得設定檔
  var config;
  ///userInfo model
  UserInfo userInfo;
  ///裝詳情 data
  Map<String,dynamic> dataArray = Map<String,dynamic>();
  ///裝ping data
  Map<String,dynamic> pingArray = Map<String,dynamic>();
  ///保留客編
  var custNoStr = "";
  ///保留客戶名
  var custNameStr = "";
  ///保留cmts
  var cmtsStr = "";
  ///保留cmmac
  var cmmacStr = "";

  DetailItemModel model;
  
  @override
  void initState(){
    super.initState(); 
    
    initParam();
  }

  @override
  void dispose() {
    super.dispose();
  }
  ///初始化資料
  initParam() async {
    var userInfoData = await UserInfoDao.getUserInfoLocal();
    if (mounted) {
      setState(() {
        userInfo = userInfoData.data;
      });
    }
    getCaseData();
    getPingData();
    getSnrConfigData();
  }

  ///呼叫maintCase api
  getCaseData() async {
    isLoading = true;
    var res;
    switch (widget.fromFunc) {
      case 'File':
        res = await FileDao.getFileCaseDetail(userId: widget.userId, caseId: widget.caseId);
        break;
      case 'DPMaintClose':
        res = await DPMaintDao.getDPMaintCloseDetail(userId: widget.userId, caseId: widget.caseId);
        break;
    }
    if (res != null && res.result) {
      dataArray = res.data;
      if (widget.custCode == null || widget.custCode == '') {
        if(mounted) {
          Future.delayed(const Duration(seconds: 1),() {
            setState(() {
              isLoading = false;
            });
          });
        }
      }
    }
  }

  ///呼叫小ping api
  getPingData() async {
    isLoading = true;
    if (widget.custCode == null || widget.custCode == '') {
      return ;
    }
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

  ///取得snr config資料
  getSnrConfigData() async {
    final configData = await LocalStorage.get(Config.SNR_CONFIG);
    final dic = json.decode(configData);
    config = dic;
  }

  ///呼叫案件歸檔
  postFileApi() async {
    await FileDao.postFile(userId: widget.userId, caseId: widget.caseId);
  }

   ///回覆dialog
  Widget detailReportDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text(''),
      content: autoTextSize('是否要將此案件歸檔?', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
      actions: <Widget>[
        FlatButton(
          child: autoTextSize('取消', TextStyle(color: Colors.red, fontSize: MyScreen.homePageFontSize(context)), context),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: autoTextSize('確定', TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)), context),
          onPressed: () {
            postFileApi();
          },
        )
      ],
    );
  }
  ///訊號dialog
  Widget signalDialog(BuildContext context) {
    if (widget.custCode == null || widget.custCode == '') {
      Fluttertoast.showToast(msg: '查無資料!');
      return null;
    }
    else {
      return Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          child: SignalDialog(custNo: model.custNO, custName: model.custName)
        )
      );
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
    Widget body;
    if (isLoading) {
      body = showLoadingAnimeB(context);
    }
    else {
      if (dataArray.length > 0) {
        // DetailItemModel model;
        model = DetailItemModel.forMap(dataArray);
        PingViewModel pingModel;
        pingModel = PingViewModel.forMap(pingArray);
        body = isLoading ? showLoadingAnimeB(context) : Column(
          children: <Widget>[
            DetailFiveBtnWidget(custNoStr: pingArray["CustCode"],custNameStr: pingArray["CustName"],cmtsStr: pingArray["CMTS"], cmmacStr: pingArray["CMMAC"], cwData: pingArray["CodeWord"],),
            buildLine(),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  DetailItemWidget(defaultModel: model, data: dataArray, fromFunc: 'Maint',),
                  PingItem(defaultViewModel: pingModel, configData: config,),
                ],
              ),
            ),
          ],
        );
      }
    }
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
              width: deviceWidth6(context),
              child: autoTextSize('回覆', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),context),
            ),
            onTap: () {
              if (isLoading) {
                Fluttertoast.showToast(msg: '資料讀取中..');
                return;
              }
              showDialog(
                context: context,
                builder: (BuildContext context) => detailReportDialog(context)
              );
            },
          ),
         
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth6(context),
              child: autoTextSize('訊號', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),context),
            ),
            onTap: () {
              if (isLoading) {
                Fluttertoast.showToast(msg: '資料讀取中..');
                return;
              }
              showDialog(
                context: context,
                builder: (BuildContext context) => signalDialog(context)
              );
            },
          ),
          Container(
            alignment: Alignment.center,
            height: 30,
            // width: deviceWidth3(context),
            child: FlatButton.icon(
              icon: Image.asset('static/images/24.png'),
              color: Colors.transparent,
              label: Text(''),
              onPressed: (){
                NavigatorUtils.goLogin(context);
              },
            ),
          ),
          SizedBox(width: deviceWidth7(context),),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth6(context),
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