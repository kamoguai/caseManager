
import 'package:case_manager/common/dao/DetailPageDao.dart';
import 'package:case_manager/common/dao/UserInfoDao.dart';
import 'package:case_manager/common/model/SsoLogin.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignalDialog extends StatefulWidget {
  final custNo;
  final custName;
  SignalDialog({this.custNo, this.custName});
  @override
  _SignalDialogState createState() => _SignalDialogState();
}

class _SignalDialogState extends State<SignalDialog> with BaseWidget {

  ///data相關
  List<dynamic> dataArray = new List<dynamic>();
  ///所選row array
  final List<String> toTransformArray = [];
  ///所選row 狀態，選定時為true，未選為flase
  List<bool> isSelectArray = [];
  /// user model
  UserInfo userInfo;
  /// sso model
  Sso sso;
  var isCanAdd = false;
  var tapId = "";
  var tapIndex = 0;
  var tapTarget = "";
  var selectAccNo = "";
  var selectEmpName = "";
  ///初始化
  initParam() async {
    getDataList();
  }
 
  ///first item
  Widget _firstItem() {
    Widget item;
    if(dataArray.length > 0) {
      var dic = SignalViewModel.forMap(dataArray[0]);
      item = GestureDetector(
        child: Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.red, style: BorderStyle.solid))),
          child: Column(
            children: <Widget>[
              Container(
                height: listHeight(context),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: deviceWidth10(context) * 2,
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('客戶端', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('015', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('${dic.cust._015}', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('054', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('${dic.cust._054}', TextStyle(color: Colors.black), context),
                    ),
                     Container(
                       width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('113', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('${dic.cust._113}', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('158', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      child: autoTextSize('${dic.cust._158}', TextStyle(color: Colors.black), context),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.blue[100], border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: deviceWidth10(context) * 2,
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('TAP端', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context) * 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: listHeight(context),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('015', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('${dic.tap._015}', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('054', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('${dic.tap._054}', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('113', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('${dic.tap._113}', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('158', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  child: autoTextSize('${dic.tap._158}', TextStyle(color: Colors.black), context),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: listHeight(context),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('029', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('${dic.tap._029}', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('036', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('${dic.tap._036}', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('044', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('${dic.tap._044}', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                  child: autoTextSize('052', TextStyle(color: Colors.black), context),
                                ),
                                Container(
                                  width: deviceWidth10(context),
                                  child: autoTextSize('${dic.tap._052}', TextStyle(color: Colors.black), context),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: listHeight(context),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: deviceWidth10(context) * 2,
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('客戶端', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('029', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('${dic.cust._029}', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('036', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('${dic.cust._036}', TextStyle(color: Colors.black), context),
                    ),
                     Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('044', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('${dic.cust._044}', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('052', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      child: autoTextSize('${dic.cust._052}', TextStyle(color: Colors.black), context),
                    ),
                  ],
                ),
              ),
              Container(
                height: listHeight(context),
                decoration: BoxDecoration(color: Colors.pink[50], border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: deviceWidth10(context) * 2,
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('CMTS', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('029', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('${dic.cmts._029}', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('036', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('${dic.cmts._036}', TextStyle(color: Colors.black), context),
                    ),
                     Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('044', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('${dic.cmts._044}', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('052', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      child: autoTextSize('${dic.cmts._052}', TextStyle(color: Colors.black), context),
                    ),
                  ],
                ),
              ),
              Container(
                height: listHeight(context),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: deviceWidth10(context) * 2,
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('1.客戶', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('1BER', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('${dic.cust._ber}', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('1MER', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('${dic.cust._mer}', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('BER', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('${dic.tap._ber}', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                      child: autoTextSize('MER', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      width: deviceWidth10(context),
                      child: autoTextSize('${dic.tap._mer}', TextStyle(color: Colors.black), context),
                    ),
                  ],
                ),
              ),
              Container(
                height: listHeight(context),
                color: Colors.green[50],
                child: Row(
                  children: <Widget>[
                    autoTextSize('${dic.reportDate} ${dic.reportMan}', TextStyle(color: Colors.black), context),
                  ],
                )
              ),
            ],
          ),
        ),
        onTap: () {
        },
      );
    }
    else {
      item = Container();
    }
    return item;
  }

  ///loglist item
  Widget _logListItem(BuildContext context, int index) {
    var count = index + 1;
    var dicIndex = dataArray[index + 1];
    var dic = SignalViewModel.forMap(dicIndex);
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
        child: Column(
          children: <Widget>[
            Container(
              height: listHeight(context),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
              child: Row(
                children: <Widget>[
                  Container(
                    width: deviceWidth10(context) * 2,
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('客戶端', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('015', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('${dic.cust._015}', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('054', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('${dic.cust._054}', TextStyle(color: Colors.black), context),
                  ),
                    Container(
                      width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('113', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('${dic.cust._113}', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('158', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    child: autoTextSize('${dic.cust._158}', TextStyle(color: Colors.black), context),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.blue[100], border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
              child: Row(
                children: <Widget>[
                  Container(
                    width: deviceWidth10(context) * 2,
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('TAP端', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context) * 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: listHeight(context),
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('015', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('${dic.tap._015}', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('054', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('${dic.tap._054}', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('113', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('${dic.tap._113}', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('158', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                child: autoTextSize('${dic.tap._158}', TextStyle(color: Colors.black), context),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: listHeight(context),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('029', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('${dic.tap._029}', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('036', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('${dic.tap._036}', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('044', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('${dic.tap._044}', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                                child: autoTextSize('052', TextStyle(color: Colors.black), context),
                              ),
                              Container(
                                width: deviceWidth10(context),
                                child: autoTextSize('${dic.tap._052}', TextStyle(color: Colors.black), context),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: listHeight(context),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
              child: Row(
                children: <Widget>[
                  Container(
                    width: deviceWidth10(context) * 2,
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('客戶端', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('029', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('${dic.cust._029}', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('036', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('${dic.cust._036}', TextStyle(color: Colors.black), context),
                  ),
                    Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('044', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('${dic.cust._044}', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('052', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    child: autoTextSize('${dic.cust._052}', TextStyle(color: Colors.black), context),
                  ),
                ],
              ),
            ),
            Container(
              height: listHeight(context),
              decoration: BoxDecoration(color: Colors.pink[50], border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
              child: Row(
                children: <Widget>[
                  Container(
                    width: deviceWidth10(context) * 2,
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('CMTS', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('029', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('${dic.cmts._029}', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('036', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('${dic.cmts._036}', TextStyle(color: Colors.black), context),
                  ),
                    Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('044', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('${dic.cmts._044}', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('052', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    child: autoTextSize('${dic.cmts._052}', TextStyle(color: Colors.black), context),
                  ),
                ],
              ),
            ),
            Container(
              height: listHeight(context),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
              child: Row(
                children: <Widget>[
                  Container(
                    width: deviceWidth10(context) * 2,
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('1.客戶', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('1BER', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('${dic.cust._ber}', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('1MER', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('${dic.cust._mer}', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('BER', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('${dic.tap._ber}', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style:  BorderStyle.solid))),
                    child: autoTextSize('MER', TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    width: deviceWidth10(context),
                    child: autoTextSize('${dic.tap._mer}', TextStyle(color: Colors.black), context),
                  ),
                ],
              ),
            ),
            Container(
              height: listHeight(context),
              color: Colors.green[50],
              child: Row(
                children: <Widget>[
                  autoTextSize('${dic.reportDate} ${dic.reportMan}', TextStyle(color: Colors.black), context),
                ],
              )
            ),
          ],
        ),
      ),
      onTap: () {
      },
    );
  }

  ///loglsit view
  Widget _logListView() {
    Widget logList;
    if(dataArray.length > 0) {
      logList = Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: _logListItem,
          itemCount: dataArray.length - 1,
        ),
      );
    } 
    else {
      logList = Expanded(child: Container(child: Center(child: Text('目前沒有資料'))));
    }
    return logList;
  }

  ///呼叫api data
  getDataList() async {
    var userInfoData = await UserInfoDao.getUserInfoLocal();
    if (mounted) {
      setState(() {
        userInfo = userInfoData.data;
      });
    }
    dataArray.clear();
    var res = await DetailPageDao.getSignalLogData(custNo: widget.custNo);
    if(res != null && res.result) {
      if(mounted) {
        setState(() {
          isLoading = false;
          dataArray = res.data["Data"];
          for (var i = 0; i < dataArray.length; i++) {
            isSelectArray.add(false);
          }
        });
      }
    }
    else {
      setState(() {
        isLoading = false;
      });
    }
    
  }
  
  @override
  deviceWidth2(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return (width / 2) - 4;
  }
  @override
  deviceWidth3(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return (width / 3) - 3;
  }
  @override
  deviceWidth10(BuildContext context) {
   
    return super.deviceWidth10(context) - 2;
  }
  @override
  void initState() {
    super.initState();
    isLoading = true;
    initParam();
    getDataList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height)..init(context);
    Widget btnAction;
    
     btnAction = Container(
      color: Color(MyColors.hexFromStr('e8fcff')),
      height: titleHeight(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: deviceWidth2(context) ,
            child: FlatButton(
              textColor: Colors.red,
              child: autoTextSize('離開', TextStyle(color: Colors.red), context),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );

    return isLoading ? Container(width: 150, child: showLoadingAnime(context)) :
     Container(
      height: deviceHeight4(context) * 3.5,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(MyColors.hexFromStr('#fafff2')), border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            height: listHeight(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: autoTextSize('客編: ', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: autoTextSize(widget.custNo, TextStyle(color: Colors.black), context),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: autoTextSize('姓名: ', TextStyle(color: Colors.black), context),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: autoTextSize(widget.custName, TextStyle(color: Colors.black), context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _firstItem(),          
          _logListView(),
          buildLine(),
          btnAction,
        ],
      ),
    );
  }
}

class SignalViewModel {
  String reportMan;
  String reportDate;
  TAP tap;
  CUST cust;
  CMTS cmts;
  SignalViewModel();
  SignalViewModel.forMap(data) {
    reportMan = data['ReportMan'] == '---' ? '' : data['ReportMan'];
    reportDate = data['ReportDate'] == '---' ? '' : data['ReportDate'];
    if(data['TAP'] != null && data['TAP'] != {}) {
      tap = TAP.forMap(data['TAP']);
    }
    else {
      tap = null;
    }
    if(data['CUST'] != null && data['CUST'] != {}) {
      cust = CUST.forMap(data['TAP']);
    }
    else {
      cust = null;
    }
    if(data['CMTS'] != null && data['CMTS'] != {}) {
      cmts = CMTS.forMap(data['TAP']);
    }
    else {
      cmts = null;
    }
  }
}
class TAP {
  String _113;
  String _158;
  String _015;
  String _054;
  String _029;
  String _036;
  String _044;
  String _052;
  String _ber;
  String _mer;
  TAP();
  TAP.forMap(data) {
    _113 = data['113'] == '---' ? '-' : data['113'];
    _158 = data['158'] == '---' ? '-' : data['158'];
    _015 = data['015'] == '---' ? '-' : data['015'];
    _054 = data['054'] == '---' ? '-' : data['054'];
    _029 = data['029'] == '---' ? '-' : data['029'];
    _036 = data['036'] == '---' ? '-' : data['036'];
    _044 = data['044'] == '---' ? '-' : data['044'];
    _052 = data['052'] == '---' ? '-' : data['052'];
    _ber = data['BER'] == '---' ? '-' : data['BER'];
    _mer = data['MER'] == '---' ? '-' : data['MER'];
  }

}

class CUST {
  String _113;
  String _158;
  String _015;
  String _054;
  String _029;
  String _036;
  String _044;
  String _052;
  String _ber;
  String _mer;
  CUST();
  CUST.forMap(data) {
    _113 = data['113'] == '---' ? '-' : data['113'];
    _158 = data['158'] == '---' ? '-' : data['158'];
    _015 = data['015'] == '---' ? '-' : data['015'];
    _054 = data['054'] == '---' ? '-' : data['054'];
    _029 = data['029'] == '---' ? '-' : data['029'];
    _036 = data['036'] == '---' ? '-' : data['036'];
    _044 = data['044'] == '---' ? '-' : data['044'];
    _052 = data['052'] == '---' ? '-' : data['052'];
    _ber = data['BER'] == '---' ? '-' : data['BER'];
    _mer = data['MER'] == '---' ? '-' : data['MER'];
  }
}
class CMTS {
  String _029;
  String _036;
  String _044;
  String _052;
  CMTS();
  CMTS.forMap(data) {
    _029 = data['029'] == '---' ? '-' : data['029'];
    _036 = data['036'] == '---' ? '-' : data['036'];
    _044 = data['044'] == '---' ? '-' : data['044'];
    _052 = data['052'] == '---' ? '-' : data['052'];
  }
}