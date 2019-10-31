
import 'package:auto_size_text/auto_size_text.dart';
import 'package:case_manager/common/dao/DeptInfoDao.dart';
import 'package:case_manager/common/dao/UserInfoDao.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
///
///部門選擇dialog
///Date: 2019-06-10
///
class DeptSelectorDialog extends StatefulWidget {
  ///是否點擊此下拉選單
  final isClickDeptSelect;
  ///依功能使用選擇器
  final fromFunc;
  ///呼叫function給主頁使用
  final Function callApiData;
  DeptSelectorDialog({this.isClickDeptSelect, this.fromFunc, this.callApiData});
  @override
  _DeptSelectorDialogState createState() => _DeptSelectorDialogState();
}

class _DeptSelectorDialogState extends State<DeptSelectorDialog> with BaseWidget {
  ///裝載api list
  final List<dynamic> dataArray = [];
  final List<dynamic> originArray = [];
  Map<String, dynamic> pickData = {};
  ///userInfo model
  UserInfo userInfo;
  ///textFieldController
  TextEditingController editingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    isLoading = true;
    initParam();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  autoTextSize(text, style, context){
    return AutoSizeText(
      text,
      style: style,
      minFontSize: 5.0,
      textAlign: TextAlign.start,  
    );
  }
  
  ///初始化
  initParam() {

    _getApiData();
  }
  ///取得api資料
  _getApiData() async{
    var userInfoData = await UserInfoDao.getUserInfoLocal();
    if (mounted) {
      setState(() {
        userInfo = userInfoData.data;
      });
    }
    ///如果是指派個人
    if (widget.fromFunc == 'AssignEmpl') {
      if (userInfo.userData.Position == '2') {
        var res = await DeptInfoDao.getDeptSelect(null);
        if (res != null && res.result) {
          if(mounted) {
            setState(() {
              isLoading = false;
              dataArray.addAll(res.data);
              originArray.addAll(res.data);
              if (dataArray.length > 0 && dataArray.length < 2) {
                pickData = dataArray[0];
                widget.callApiData(pickData);
                Navigator.pop(context);
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
      else if (userInfo.userData.Position == '3') {
        var res = await DeptInfoDao.getUserDeptSelect(userInfo.userData.UserID);
        if (res != null && res.result) {
          if(mounted) {
            setState(() {
              isLoading = false;
              dataArray.addAll(res.data);
              originArray.addAll(res.data);
              if (dataArray.length > 0 && dataArray.length < 2) {
                pickData = dataArray[0];
                widget.callApiData(pickData);
                Navigator.pop(context);
              }
              else if (dataArray.length < 1) {
                Navigator.pop(context);
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
      else {
        var res = await DeptInfoDao.getDeptSelect(userInfo.userData.UserID);
        if (res != null && res.result) {
          if(mounted) {
            setState(() {
              isLoading = false;
              dataArray.addAll(res.data);
              originArray.addAll(res.data);
              if (dataArray.length > 0 && dataArray.length < 2) {
                pickData = dataArray[0];
                widget.callApiData(pickData);
                Navigator.pop(context);
              }
              else if (dataArray.length < 1) {
                Navigator.pop(context);
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
    }
    else {//其他
      var res = await DeptInfoDao.getUserDeptSelect(userInfo.userData.UserID);
      if (res != null && res.result) {
        if(mounted) {
          setState(() {
            isLoading = false;
            dataArray.addAll(res.data);
            originArray.addAll(res.data);
            if (dataArray.length > 0 && dataArray.length < 2) {
              pickData = dataArray[0];
              widget.callApiData(pickData);
              Navigator.pop(context);
            }
            else if (dataArray.length < 1) {
              Navigator.pop(context);
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
  }
  ///filter功能
  void filterSearchReasult(String str) {
    List<dynamic> dummySearchList = List<dynamic>();
    dummySearchList.addAll(dataArray);
    if (str.isNotEmpty) {
      List<dynamic> dummyListData = List<dynamic>();
      dummySearchList.forEach((item) {
        if (item['DeptName'].contains(str)) {
          dummyListData.add(item);
          setState(() {
            dataArray.clear();
            dataArray.addAll(dummyListData);
          });
        }
      });
      return ;
    }
    else {
      setState(() {
        dataArray.clear();
        dataArray.addAll(originArray);
      });
    }

  }
  ///搜尋bar
  Widget searchTextField() {
    Widget widget;
    widget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          filterSearchReasult(value);
        },
        controller: editingController,
        decoration: InputDecoration(
          labelText: '部門名稱',
          hintText: '',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))
          ),
        ),
      ),
    );
    return widget;
  }
  ///widget list item
  Widget listItem(BuildContext context, int index) {
    Widget item;
    var dicIndex = dataArray[index];
    var dic = DeptSelectorModel.forMap(dicIndex);
    item = GestureDetector(
      child: Container(
        color: pickData == dicIndex ? Colors.yellow : Colors.white,
        height: titleHeight(context) * 1.5,
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Center(
          child: autoTextSize(dic.deptName, TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
        )
      ),
      onTap: () {
        setState(() {
          pickData = dicIndex;
        });
        print('select dept -> $pickData');
      },
    );
    
    return item;
  }

  ///widget list view
  Widget listView() {
    Widget list;
    if (dataArray.length > 0) {
      list = Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: listItem,
          itemCount:  dataArray.length,
        ),
      );
    }
    else {
      list = Container(child: Center(child: autoTextSize('查無資料', TextStyle(color: Colors.black), context),),);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?  Container(width: 150, child: showLoadingAnime(context)) : 
     Container(
      //  padding: EdgeInsets.symmetric(vertical: 20.0),
      //  decoration: BoxDecoration(shape: BoxShape.circle),
      //  height: deviceHeight4(context) * 2,
       child: Column(
         children: <Widget>[
           Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
               color: Color(MyColors.hexFromStr('#40b89e')),
             ),
             height: titleHeight(context) * 1.5,
             child: Center(child: autoTextSize('選擇部門', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)), context),)
           ),
           searchTextField(),
           listView(),
           Container(
             height: titleHeight(context) * 1.5,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[
                 Expanded(
                   flex: 5,
                   child: Container(
                     height: titleHeight(context) * 1.5,
                     child: FlatButton(
                        color: Color(MyColors.hexFromStr('#f2f2f2')),
                        child: autoTextSize('取消', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                        onPressed: (){
                          if (widget.isClickDeptSelect) {
                             Navigator.pop(context, 'cancel');
                          }
                          else {
                            //第一次pop跳離dialog
                            Navigator.pop(context, 'cancel');
                            //第二次pop跳回主頁
                            Navigator.pop(context, 'cancel');
                          }
                        },
                      ),
                   )
                 ),
                 Expanded(
                   flex: 5,
                    child: Container(
                      height: titleHeight(context) * 1.5, 
                      child: FlatButton(
                        color: Color(MyColors.hexFromStr('#40b89e')),
                        child: autoTextSize('確定', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)), context),
                        onPressed: () {
                          if (pickData.length > 0) {
                            widget.callApiData(pickData);
                          }
                          Navigator.pop(context, 'ok');
                        },
                      ),
                    )
                 )
               ],
             ),
           )
         ],
       ),
     );
  }
}

class DeptSelectorModel {
  ///部門id
  String deptID;
  ///部門名稱
  String deptName;
  DeptSelectorModel();
  
  DeptSelectorModel.forMap(dic) {
    deptID = dic["DeptID"] == null ? "" : dic["DeptID"];
    deptName = dic["DeptName"] == null ? "" : dic["DeptName"];
  }
}