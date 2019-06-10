
import 'package:case_manager/common/dao/DeptInfoDao.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
/**
 * 部門選擇dialog
 * Date: 2019-06-10
 */
class DeptSelectorDialog extends StatefulWidget {
  @override
  _DeptSelectorDialogState createState() => _DeptSelectorDialogState();
}

class _DeptSelectorDialogState extends State<DeptSelectorDialog> with BaseWidget {
  ///裝載api list
  final List<dynamic> dataArray = [];
  
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

  initParam() {

    _getApiData();
  }
  ///取得api資料
  _getApiData() async{
    var res = await DeptInfoDao.getDeptSelect(null);
    if (res != null && res.result) {
      if(mounted) {
        setState(() {
          isLoading = false;
          dataArray.addAll(res.data);
        });
      }
    }
    else {
      setState(() {
        isLoading = false;
      });
    }
  }

  ///widget list item
  Widget listItem(BuildContext context, int index) {
    Widget item;
    var dicIndex = dataArray[index];
    var dic = DeptSelectorModel.forMap(dicIndex);
    item = GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: autoTextSize(dic, TextStyle(color: Colors.black), context),
            ),
            Container(

              child: Icon(Icons.check), color: Colors.blueAccent,),
          ],
        ),
      ),
      onTap: () {

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
          itemCount:  dataArray.length - 1,
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
       height: deviceHeight4(context) * 2,
       child: Column(),
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