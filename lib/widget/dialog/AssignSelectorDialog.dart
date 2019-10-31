
import 'package:auto_size_text/auto_size_text.dart';
import 'package:case_manager/common/dao/AssignDao.dart';
import 'package:case_manager/common/dao/AssignInfoDao.dart';
import 'package:case_manager/common/dao/UserInfoDao.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';

///
///指派人員dialog
///Date: 2019-06-25
class AssignSelectorDialog extends StatefulWidget {
  ///由前頁傳入部門id
  final deptId;
  ///依功能使用選擇器
  final fromFunc;
  ///呼叫function給主頁使用
  final Function callApiData;
  ///由前頁傳入來自accName
  final accName;
  AssignSelectorDialog({this.deptId, this.fromFunc, this.callApiData, this.accName});
  @override
  _AssignSelectorDialogState createState() => _AssignSelectorDialogState();
}

class _AssignSelectorDialogState extends State<AssignSelectorDialog> with BaseWidget{
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
    var res = await AssignInfoDao.getEmplSelect(widget.deptId);
    if (res != null && res.result) {
        if(mounted) {
          setState(() {
            isLoading = false;
            dataArray.addAll(res.data);
            originArray.addAll(res.data);
          });
        }
    }
    else {
      setState(() {
        isLoading = false;
      });
    }
  }
  ///執行指派動作api
  postAssignEmpl() async {
    var res = await AssignDao.didAssignEmpl();
    if (res.result) {
      new Future.delayed(const Duration(seconds: 1),() {
        NavigatorUtils.goAssign(context, widget.accName, deptId: widget.deptId);
      });
    }
  }
  ///widget list item
  Widget listItem(BuildContext context, int index) {
    Widget item;
    var dicIndex = dataArray[index];
    var dic = AssignSelectorModel.forMap(dicIndex);
    item = GestureDetector(
      child: Container(
        color: pickData == dicIndex ? Colors.yellow : Colors.white,
        height: titleHeight(context) * 1.5,
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Center(
          child: autoTextSize(dic.name, TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
        )
      ),
      onTap: () {
        setState(() {
          pickData = dicIndex;
        });
        print('select empl -> $pickData');
      },
    );
    
    return item;
  }

  ///filter功能
  void filterSearchReasult(String str) {
    List<dynamic> dummySearchList = List<dynamic>();
    dummySearchList.addAll(dataArray);
    if (str.isNotEmpty) {
      List<dynamic> dummyListData = List<dynamic>();
      dummySearchList.forEach((item) {
        if (item['Name'].contains(str)) {
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
       child: Column(
         children: <Widget>[
           Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
               color: Color(MyColors.hexFromStr('#40b89e')),
             ),
             height: titleHeight(context) * 1.5,
             child: Center(child: autoTextSize('選擇部門員工', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)), context),)
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
                          Navigator.pop(context, 'cancel');
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

class AssignSelectorModel {
  ///使用者id
  String userId;
  ///員工id
  String emplId;
  ///員工名稱
  String name;
  AssignSelectorModel();
  
  AssignSelectorModel.forMap(dic) {
    userId = dic["UserID"] == null ? "" : dic["UserID"];
    emplId = dic["EmplID"] == null ? "" : dic["EmplID"];
    name = dic["Name"] == null ? "" : dic["Name"];
  }
}