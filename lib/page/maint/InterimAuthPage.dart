

import 'package:case_manager/common/dao/InterimAuthDao.dart';
import 'package:case_manager/common/dao/UserInfoDao.dart';
import 'package:case_manager/common/model/InterimAuthModel.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/redux/SysState.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/CommonUtils.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/MyPullLoadWidget.dart';
import 'package:case_manager/widget/dialog/ProdItemSelectorDialog.dart';
import 'package:case_manager/widget/items/InterimAuthListItem.dart';
import 'package:flutter/material.dart';
import 'package:case_manager/widget/MyListState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
///
///個人案件處理list頁面
///Date: 2019-06-11
///
class InterimAuthPage extends StatefulWidget {
  final String accName;
  final String deptId;
  final bool isHasData;
  InterimAuthPage({this.accName, this.deptId, this.isHasData});
  @override
  _InterimAuthPageState createState() => _InterimAuthPageState();
}

class _InterimAuthPageState extends State<InterimAuthPage> with AutomaticKeepAliveClientMixin<InterimAuthPage>, MyListState<InterimAuthPage>{
  ///app bar左邊title
  var userTitle = "二次臨時授權";
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
  ///userInfo model
  UserInfo userInfo;
  ///數據資料arr
  final List<dynamic> dataArray = [];
  ///返回msg
  var resMsg = "";
  ///變更輸入/列表畫面
  bool isChangedView = false;
  ///textField controller
  TextEditingController _editingController = TextEditingController();
  ///node
  FocusNode _node =  FocusNode();
  ///產品arr
  List<dynamic> prodItems = [];

  @override
  void initState() {
    super.initState();
    clearData();
    initParam();
  }

  @override
  void dispose() {
    clearData();
    this._editingController.clear();
    this._node.dispose();
    super.dispose();

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
    if (isLoading) {
      return null;
    }

    isLoading = true;
    var res = await getApiData();
    if (res != null && res.result) {
      List<InterimAuthModel> list = new List();
      dataArray.addAll(res.data);
      if (dataArray.length > 0) {
        for (var dic in dataArray) {
          list.add(InterimAuthModel.fromJson(dic));
        }
      }
      List<dynamic> newCount = [];
      List<dynamic> noCount = [];
      for (var dic in res.data) {
        if (dic["StatusName"] == '新案') {
          newCount.add(dic);
        }
        else if (dic["StatusName"] == '接案') {
          noCount.add(dic);
        }
      }
      if(mounted) {
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
    this.isChangedView = widget.isHasData;
    /// new node
    this._node = FocusNode();
    var userInfoData = await UserInfoDao.getUserInfoLocal();
    if (mounted) {
      setState(() {
        userInfo = userInfoData.data;
        this.getFirstTimeApiData();
      });
    }
  }
  ///列表顯示物件
  _renderItem(index) {
    InterimAuthModel mtc = pullLoadWidgetControl.dataList[index];
    IAModel model = IAModel.forMap(mtc);
    return InterimAuhtListItem(model: model, userId: userInfo.userData.UserID, deptId: deptId, callApiData: this._callApiData,);
  }
  ///頁面上方head
  _renderHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: titleHeight(),
      decoration: BoxDecoration(color: Color(MyColors.hexFromStr('#eeffec')),border: Border(top: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid), bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
      child: Center(
        child: autoTextSize('尚未授權有 ${dataArray.length} 筆', TextStyle(color: Colors.black)),
      )
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

  void _callApiData(model) async {
    CommonUtils.showLoadingDialog(context);
    var resp = await InterimAuthDao.postInterimAuth(custCode: model.custCode, userId: userInfo.userData.Account);
    if (resp.result) {
      Navigator.pop(context);
      var res = await InterimAuthDao.interimAuthUpdate(userId: userInfo.userData.UserID, id: model.id, acceptAccNo: userInfo.userData.Account);
      if (res.result) {
        showRefreshLoading();
      }
    }
    else {
      Navigator.pop(context);
    }
  }
 
  ///第一次進入取得的資料
  getFirstTimeApiData() async {
    var res = await InterimAuthDao.getInterimAuthList(userId: userInfo.userData.UserID);
    if (res != null && res.result) {
      List<InterimAuthModel> list = new List();
      dataArray.addAll(res.data);
      if (dataArray.length > 0) {
        for (var dic in dataArray) {
          list.add(InterimAuthModel.fromJson(dic));
        }
      }
      if(mounted) {
        setState(() {
          totalCount = res.data.length;
          isLoading = false;
          pullLoadWidgetControl.dataList.clear();
          pullLoadWidgetControl.dataList.addAll(list);
          pullLoadWidgetControl.needLoadMore = false;
        });
      }
    }
  }

  ///取得api資料
  getApiData() async {
    
    var res = await InterimAuthDao.getInterimAuthList(userId: userInfo.userData.UserID);
    return res;
  }

  ///post二次授權
  postApiData() async {
    CommonUtils.showLoadingDialog(context);
    var res = await InterimAuthDao.postInterimAuth(custCode: _editingController.text, userId: userInfo.userData.Account);
    if (res.result){
      if (res.data != null) {
        setState(() {
          this.prodItems = res.data;
          Navigator.pop(context);
        });
      }
      else {
        setState(() {
          this.resMsg = '授權成功';
          Navigator.pop(context);
        });
      }
    }
    else {
      setState(() {
        
        this.resMsg = '${res.data['retName'] == null ? res.data['RtnMsg'] : res.data['retName']}';
        Navigator.pop(context);
      });
    }
    
  }

  void updateChangedView(v) {
    setState(() {
      this.isChangedView = v;
      if (v) {
        FocusScope.of(context).requestFocus(_node);
        _editingController.text = "";
      }
    });
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
                child: autoTextSize('', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
              ),
              onTap: () {
                
              },
            ),
            Container(
              alignment: Alignment.center,
              height: 30,
              width: deviceWidth3() * 1.1,
              child: FlatButton.icon(
                icon: Image.asset('static/images/24.png'),
                color: Colors.transparent,
                label: Text(''),
                onPressed: (){
                  NavigatorUtils.goLogin(context);
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 30,
              width: deviceWidth4(),
              child: autoTextSize('${_getStore().state.userInfo.userData?.UserName} $totalCount', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
          ],
        ),
      )
    ];
    return list;
  }
  Widget bodyView() {
    Widget body;
    List<Widget> columnList = [];
    columnList.add(
      _renderHeader()
    );
    if (this.isChangedView) {
      columnList.add(
        Expanded(
          child: _renderBody(),
        )
      );
    }
    else {
      columnList.add(
        Expanded(
          child: Column(
            children: <Widget>[

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _editingController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  maxLength: 10,
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: '客編',
                    hintText: '請輸入二次授權之客編',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                    ),
                  ),
                  onSubmitted: (v) {
                   
                  },
                ),
              ),
              Center(
                child: Container(
                  child: FlatButton(
                    color: Colors.blue[300],
                    child: autoTextSize('授權', TextStyle(color: Colors.white)),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      print(this._editingController.text);
                      if (this._editingController.text.length < 10) {
                        Fluttertoast.showToast(msg: '請輸入完整客編！');
                        return;
                      }
                      else {
                        await this.postApiData();
                        if (prodItems.length > 0) {
                          Future.delayed(const Duration(milliseconds: 50),(){
                            showDialog(
                            context: context,
                            builder: (BuildContext context) => prodItemSelectorDialog(context, prodItems)
                            );
                          });
                        }
                        return;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Container(
                 child: Text(this.resMsg, style: TextStyle(color: Colors.red, fontSize: MyScreen.loginTextFieldFontSize(context)),)
                ),
              )
            ],
          ),
        )
      );
    }
    body = isLoading ? showLoadingAnime(context) : Column(
      children:  columnList
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
              width: deviceWidth6(),
              child: autoTextSize('刷新', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: () {
              showRefreshLoading();
            },
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth6(),
              child: autoTextSize( this.isChangedView ? '輸入' : '列表', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: (){
               var v = !this.isChangedView;
               this.updateChangedView(v);
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
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth7(),
              child: autoTextSize('', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: () {
              
            },
          ),
          
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth6(),
              child: autoTextSize('返回', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: () {
               NavigatorUtils.goHome(context);
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
        bottomNavigationBar: bottomBar()
      ),
    );
  }

  ///二授產品選擇dialog
  Widget prodItemSelectorDialog(BuildContext context, items) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: ProdItemSelectorDialog(dataArray: items),
      )
    );
  }
}