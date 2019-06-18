
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:case_manager/common/style/MyStyle.dart';
/**
 * 詳情頁面裡面的CPE dialog
 * Date: 2019-06-17
 */
class CPEDialog extends StatelessWidget with BaseWidget{

  final String custNo;
  final String custName;
  final List<dynamic> data;

  CPEDialog(this.custNo, this.custName, this.data);

  Widget _cpeItem(BuildContext context, int index) {
    var dic = data[index];
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
      height: listHeight(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5.0),
            width: deviceWidth2(context) - 5,
            child: autoTextSize(dic["IP"], TextStyle(color: Colors.black), context),
          ),
          buildLineHeight(context),
          Container(
            padding: EdgeInsets.only(left: 5.0),
            width: deviceWidth2(context) - 5,
            child: autoTextSize(dic["MAC"], TextStyle(color: Colors.black), context),
          )
        ],
      ),
    );
  }
  Widget _cpeListView() {
    Widget listView;
    if(data.length > 0) {
      listView = Container(
        height: 200,
        child: ListView.builder(
          itemBuilder: _cpeItem,
          itemCount: data.length,
        ),
      );
    }
    else {
      listView = Center(child: Text('尚無資料'),);
    }
    return listView;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(MyColors.hexFromStr('#f0fcff')),
      child: Column(
        children: <Widget>[
          Container(
            height: listHeight(context),
            padding: EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  child: autoTextSize('客編: ', TextStyle(color: Colors.black), context),
                ),
                Container(
                  child: autoTextSize(custNo, TextStyle(color: Colors.black), context),
                ),
                SizedBox(width: 10.0,),
                Container(
                  child: autoTextSize('姓名: ', TextStyle(color: Colors.black), context),
                ),
                Container(
                  child: autoTextSize(custName, TextStyle(color: Colors.black), context),
                ),
              ],
            ),
          ),
          _cpeListView(),
          buildLine(),
          Container(
            height: titleHeight(context),
            child: FlatButton(
              textColor: Colors.red,
              child: Text('離開', style: TextStyle(fontSize: MyScreen.appBarFontSize(context)),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}