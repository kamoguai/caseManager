import 'package:case_manager/common/dao/DPMaintDao.dart';
import 'package:case_manager/common/dao/FileDao.dart';
import 'package:case_manager/common/dao/UserInfoDao.dart';
import 'package:case_manager/common/model/MaintTableCell.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/redux/SysState.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/MyPullLoadWidget.dart';
import 'package:case_manager/widget/dialog/FilterCaseTypeDialog.dart';
import 'package:case_manager/widget/items/MaintListItem.dart';
import 'package:flutter/material.dart';
import 'package:case_manager/widget/MyListState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

///
///歸檔案件列表/單位結案列表
///Date: 2019-07-01
class FilePage extends StatefulWidget {
  final String accName;
  FilePage({this.accName});
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage>
    with AutomaticKeepAliveClientMixin<FilePage>, MyListState<FilePage> {
  ///app bar左邊title
  var userTitle = "案件歸檔";

  ///部門id
  var deptId = "";

  ///新案count
  var newCaseCount = 0;

  ///未結count
  var noCloseCount = 0;

  ///超常count
  var overCount = 0;

  ///全部筆數
  var totalCount = 0;

  ///是否點擊部門下拉選單
  var isClickDeptSelect = false;

  ///是否點擊全選，0:未選，大於0:已選
  var isCheckAll = 0;

  ///userInfo model
  UserInfo userInfo;

  ///數據資料arr
  final List<dynamic> dataArray = [];

  ///原始數據arr
  final List<dynamic> originArray = [];

  ///所選caseId
  List<String> pickCaseIdArray = [];

  @override
  void initState() {
    super.initState();
    clearData();
    initParam();
  }

  @override
  void dispose() {
    super.dispose();
    clearData();
  }

  @override
  bool get isRefreshFirst => false;

  @override
  requestRefresh() async {
    return null;
  }

  @override
  requestLoadMore() async {
    return null;
  }

  //透過override pullcontroller裡面的handleRefresh覆寫數據
  @override
  Future<Null> handleRefresh() async {
    dataArray.clear();
    originArray.clear();
    if (isLoading) {
      return null;
    }

    isLoading = true;
    var res = await getApiData();
    if (res != null && res.result) {
      List<MaintTableCell> list = new List();

      ///將工程會勘排進此list
      List<MaintTableCell> listAs = new List();
      dataArray.addAll(res.data);
      originArray.addAll(res.data);
      if (dataArray.length > 0) {
        for (var dic in dataArray) {
          ///先排除工程會勘
          if (dic["CaseTypeName"] == "工程會勘") {
            listAs.add(MaintTableCell.fromJson(dic));
            continue;
          }
          list.add(MaintTableCell.fromJson(dic));
        }

        ///如果有工程會勘資料
        if (listAs.length > 0) {
          ///將工程會勘資料排在第一筆
          for (var dic in listAs) {
            list.insert(0, dic);
          }
        }
      }
      List<dynamic> newCount = [];
      List<dynamic> noCount = [];
      for (var dic in res.data) {
        if (dic["StatusName"] == '新案') {
          newCount.add(dic);
        } else if (dic["StatusName"] == '接案') {
          noCount.add(dic);
        }
      }
      if (mounted) {
        setState(() {
          totalCount = res.data.length;
          newCaseCount = newCount.length;
          noCloseCount = noCount.length;
          isLoading = false;
          pullLoadWidgetControl.dataList.clear();
          pullLoadWidgetControl.dataList.addAll(list);
          pullLoadWidgetControl.needLoadMore = false;
        });
      }
    }
  }

  Store<SysState> _getStore() {
    return StoreProvider.of(context);
  }

  initParam() async {
    var userInfoData = await UserInfoDao.getUserInfoLocal();
    if (mounted) {
      setState(() {
        userInfo = userInfoData.data;
      });
    }
    showRefreshLoading();
  }

  ///列表顯示物件
  _renderItem(index) {
    MaintTableCell mtc = pullLoadWidgetControl.dataList[index];
    MaintListModel model = MaintListModel.forMap(mtc);
    return MaintListItem(
      model: model,
      userId: userInfo.userData.UserID,
      deptId: deptId,
      fromFunc: userTitle == '案件歸檔' ? 'File' : 'DPMaintClose',
      pickCaseIdArray: pickCaseIdArray,
      addCaseIdFunc: addCaseIdFunc,
    );
  }

  ///頁面上方head
  _renderHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: titleHeight(),
      decoration: BoxDecoration(
          color: Color(MyColors.hexFromStr('#eeffec')),
          border: Border(
              top: BorderSide(
                  width: 1.0, color: Colors.grey, style: BorderStyle.solid),
              bottom: BorderSide(
                  width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          autoTextSize('新案: $newCaseCount', TextStyle(color: Colors.black)),
          SizedBox(
            width: 5.0,
          ),
          autoTextSize('未結: $noCloseCount', TextStyle(color: Colors.black)),
          SizedBox(
            width: 5.0,
          ),
          autoTextSize('超常: $overCount', TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  ///產生body列表
  _renderBody() {
    return MyPullLoadWidget(
      pullLoadWidgetControl,
      (BuildContext context, int index) => _renderItem(index),
      handleRefresh,
      onLoadMore,
      refreshKey: refreshIndicatorKey,
    );
  }

  ///添加結案caseId function
  void addCaseIdFunc(caseId) {
    setState(() {
      if (pickCaseIdArray.contains(caseId)) {
        var index = pickCaseIdArray.indexOf(caseId);
        pickCaseIdArray.removeAt(index);
      } else {
        pickCaseIdArray.add(caseId);
      }
    });
  }

  ///全選caseId function
  void addCaseIdAllFunc() {
    if (dataArray.length < 1) {
      Fluttertoast.showToast(msg: '無資料可選擇!');
      return;
    }
    if (isCheckAll < 1) {
      pickCaseIdArray.clear();
      for (var dic in dataArray) {
        if (dic['StatusName'] == '結案' || dic['StatusName'] == '單位結案') {
          addCaseIdFunc(dic['CaseID']);
        }
      }
      print('所選caseId => ${pickCaseIdArray.length}');
      setState(() {
        isCheckAll += 1;
      });
    } else {
      for (var dic in dataArray) {
        if (dic['StatusName'] == '結案' || dic['StatusName'] == '單位結案') {
          addCaseIdFunc(dic['CaseID']);
        }
      }
      setState(() {
        isCheckAll = 0;
      });
    }
  }

  ///取得api資料
  getApiData() async {
    switch (userTitle) {
      case '案件歸檔':
        var res = await FileDao.getFileList(userId: userInfo.userData.UserID);
        return res;
        break;
      case '單位結案':
        var res = await DPMaintDao.getDPMaintCloseList(
            userId: userInfo.userData.UserID, deptId: userInfo.userData.DeptID);
        return res;
        break;
    }
  }

  /// app bar action按鈕
  List<Widget> actions() {
    List<Widget> list = [
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 5.0),
                height: 38,
                alignment: Alignment.center,
                width: deviceWidth4(),
                child: autoTextSize(
                    '$userTitle',
                    TextStyle(
                        color: Colors.white,
                        fontSize: MyScreen.homePageFontSize(context))),
              ),
              onTap: () {},
            ),
            Container(
              alignment: Alignment.center,
              height: 30,
              width: deviceWidth3() * 1.1,
              child: FlatButton.icon(
                icon: Image.asset('static/images/24.png'),
                color: Colors.transparent,
                label: Text(''),
                onPressed: () {
                  NavigatorUtils.goLogin(context);
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 30,
              width: deviceWidth4(),
              child: autoTextSize(
                  '${widget.accName} $totalCount',
                  TextStyle(
                      color: Colors.white,
                      fontSize: MyScreen.homePageFontSize(context))),
            ),
          ],
        ),
      )
    ];
    return list;
  }

  Widget bodyView() {
    Widget body;
    body = isLoading
        ? showLoadingAnime(context)
        : Column(
            children: <Widget>[
              _renderHeader(),
              Expanded(
                child: _renderBody(),
              )
            ],
          );
    return body;
  }

  ///bottomNavigationBar 按鈕
  Widget bottomBar() {
    Widget bottom = Material(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth7(),
              child: autoTextSize(
                  '篩選',
                  TextStyle(
                      color: Colors.white,
                      fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: () {
              Future.delayed(const Duration(milliseconds: 50), () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        caseTypeSelectorDialog(context));
              });
            },
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth5(),
              child: autoTextSize(
                  userTitle == '案件歸檔' ? '單位結案' : '案件歸檔',
                  TextStyle(
                      color: Colors.white,
                      fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: () {
              setState(() {
                if (pickCaseIdArray.length > 0) {
                  pickCaseIdArray.clear();
                }
                switch (userTitle) {
                  case '案件歸檔':
                    userTitle = '單位結案';
                    break;
                  case '單位結案':
                    userTitle = '案件歸檔';
                    break;
                }
                showRefreshLoading();
              });
            },
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                      width: 1.0,
                      color: Colors.black,
                      style: BorderStyle.solid)),
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 36,
              width: deviceWidth4(),
              child: autoTextSize(
                  userTitle,
                  TextStyle(
                      color: Colors.white,
                      fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: () async {
              if (pickCaseIdArray.length < 1) {
                Fluttertoast.showToast(msg: '尚未選擇欲結案資料');
                return;
              }
              var appendStr = "";
              for (var i = 0; i < pickCaseIdArray.length; i++) {
                if (i == pickCaseIdArray.length - 1) {
                  appendStr += "${pickCaseIdArray[i]}";
                } else {
                  appendStr += "${pickCaseIdArray[i]},";
                }
              }
              bool isSuccessReload = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return this.excuteDailog(context, appendStr);
                  });
              if (isSuccessReload) {
                this.showRefreshLoading();
              }
            },
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth7(),
              child: autoTextSize(
                  '全選',
                  TextStyle(
                      color: Colors.white,
                      fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: () {
              addCaseIdAllFunc();
            },
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth7(),
              child: autoTextSize(
                  '返回',
                  TextStyle(
                      color: Colors.white,
                      fontSize: MyScreen.homePageFontSize(context))),
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

  ///function給DeptSelectorDialog呼叫並把值帶回，多個條件
  void _callApiData(List<dynamic> list) {
    // dataArray.clear();

    if (mounted) {
      setState(() {
        totalCount = list.length;
        isLoading = false;
        pullLoadWidgetControl.dataList.clear();
        pullLoadWidgetControl.dataList.addAll(list);
        pullLoadWidgetControl.needLoadMore = false;
      });
    }
  }

  ///部門選擇dialog
  Widget caseTypeSelectorDialog(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: FilterCaseTypeDialog(
            dataArray: this.dataArray,
            originArray: this.originArray,
            isClickDeptSelect: isClickDeptSelect,
            callApiData: _callApiData,
          ),
        ));
  }

  ///執行檔案歸檔or案件結案
  Widget excuteDailog(BuildContext context, appendStr) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text("温馨提示"),
      //title 的内边距，默认 left: 24.0,top: 24.0, right 24.0
      //默认底部边距 如果 content 不为null 则底部内边距为0
      //            如果 content 为 null 则底部内边距为20
      titlePadding: EdgeInsets.all(10),
      //标题文本样式
      titleTextStyle: TextStyle(color: Colors.black87, fontSize: 16),
      //中间显示的内容
      content: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: '是否要將',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: MyScreen.homePageFontSize(context))),
          TextSpan(
              text: '${pickCaseIdArray.length}',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: MyScreen.homePageFontSize(context))),
          TextSpan(
              text: '筆資料執行$userTitle?',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: MyScreen.homePageFontSize(context)))
        ]),
      ),
      // Text('是否要將${pickCaseIdArray.length}筆資料執行$userTitle?'),
      //中间显示的内容边距
      //默认 EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0)
      contentPadding: EdgeInsets.all(10),
      //中间显示内容的文本样式
      contentTextStyle: TextStyle(
          color: Colors.black54, fontSize: MyScreen.homePageFontSize(context)),
      //底部按钮区域
      actions: <Widget>[
        FlatButton(
          child: Text('取消',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: MyScreen.homePageFontSize(context))),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text('確定',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: MyScreen.homePageFontSize(context))),
          onPressed: () async {
            switch (userTitle) {
              case '案件歸檔':
                var res = await FileDao.postFile(
                    userId: userInfo.userData.UserID, caseId: appendStr);
                if (res != null) {
                  if (res.result) {
                    Fluttertoast.showToast(msg: '歸檔成功');
                    Navigator.of(context).pop(true);
                  } else {
                    Fluttertoast.showToast(msg: '${res.data['MSG']}');
                    Navigator.of(context).pop(false);
                  }
                }

                break;
              case '單位結案':
                var res = await DPMaintDao.postDPMaintClose(
                    userId: userInfo.userData.UserID, caseId: appendStr);
                if (res != null) {
                  if (res.result) {
                    Fluttertoast.showToast(msg: '單位結案成功');
                    Navigator.of(context).pop(true);
                  } else {
                    Fluttertoast.showToast(msg: '${res.data['MSG']}');
                    Navigator.of(context).pop(false);
                  }
                }
                break;
            }
          },
        ),
      ],
    );
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
          bottomNavigationBar: bottomBar()),
    );
  }
}
