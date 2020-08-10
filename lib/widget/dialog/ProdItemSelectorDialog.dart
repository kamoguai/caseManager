import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


///
///二次授權產品選擇器
///Data: 2020-08-10
///
class ProdItemSelectorDialog extends StatefulWidget {

  ///由前畫面帶入產品訊息
  final List<dynamic> dataArray;
  ProdItemSelectorDialog({this.dataArray});
  @override
  _ProdItemSelectorDialogState createState() => _ProdItemSelectorDialogState();
}

class _ProdItemSelectorDialogState extends State<ProdItemSelectorDialog> with BaseWidget{

  List<dynamic> prodItems = [];
  Map<String, dynamic> map = {};
  Map<String, dynamic> pickData = {};

  @override
  void initState() {
    super.initState();
    _analizeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///widget list item
  Widget listItem(BuildContext context, int index) {
    Widget item;
    var dicIndex = this.prodItems[index];
    item = GestureDetector(
      child: Container(
        color: pickData == dicIndex ? Colors.yellow : Colors.white,
        height: titleHeight(context) * 1.5,
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Center(
          child: autoTextSize(dicIndex.name, TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
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
    if (this.prodItems.length > 0) {
      list = Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: listItem,
          itemCount:  this.prodItems.length,
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
    return Container(
      child: Column(
         children: <Widget>[
           Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
               color: Color(MyColors.hexFromStr('#40b89e')),
             ),
             height: titleHeight(context) * 1.5,
             child: Center(child: autoTextSize('選擇二授產品', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)), context),)
           ),
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
                          //第一次pop跳離dialog
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
                            Fluttertoast.showToast(msg: 'null');
                            return;
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

  void _analizeData() {
    var items = widget.dataArray;
    for (var dic in items) {
      var isSuspend = dic["isSuspend"].toString();
      var isSecond = dic["isSecondAuthorize"].toString();
      if (isSuspend == "0" && isSecond == "1") {
        var mapData = ProdInfoModel.forMap(dic);
        this.prodItems.add(mapData);
      }
      print(this.prodItems);
    }

  }
}

class ProdInfoModel {
  String code;
  String name; 
  int isSuspend;
  int isSecondAuthorize;
  ProdInfoModel();
  ProdInfoModel.forMap(dic) {
    code = dic["code"] == null ? "" : dic["code"];
    name = dic["name"] == null ? "" : dic["name"];
    isSuspend =  dic["isSuspend"];
    isSecondAuthorize =  dic["isSecondAuthorize"];

  }
}