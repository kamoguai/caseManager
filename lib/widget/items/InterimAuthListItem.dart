import 'package:case_manager/common/model/InterimAuthModel.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

///
///二次授權專用item
///Date: 2020-01-16
///
class InterimAuhtListItem extends StatelessWidget with BaseWidget{


  IAModel model;
  ///使用者id
  final userId;
  ///使用者名稱
  final accName;
  ///由前頁傳入部門id
  final deptId;
  ///callApi
  final Function callApiData;
  
  InterimAuhtListItem({this.model, this.userId, this.accName, this.deptId, this.callApiData});

  @override
  Widget build(BuildContext context) {

    DateFormat df = DateFormat("yy/MM/dd HH:mm");
    DateTime dt = DateTime.parse(model.createOn);
    String createOn = df.format(dt);

    Widget content = Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "立案：",
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context))
                        ),
                        TextSpan(
                          text: createOn,
                          style: TextStyle(color: Colors.grey[600], fontSize: MyScreen.defaultTableCellFontSize(context))
                        )
                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "立案人：",
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context))
                        ),
                        TextSpan(
                          text: model.createBy,
                          style: TextStyle(color: Colors.grey[600], fontSize: MyScreen.defaultTableCellFontSize(context))
                        )
                      ]
                    ),
                  ),
                ),
              ]
            ),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "客編：",
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context))
                        ),
                        TextSpan(
                          text: model.custCode,
                          style: TextStyle(color: Colors.grey[600], fontSize: MyScreen.defaultTableCellFontSize(context))
                        )
                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "授權狀態：",
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context))
                        ),
                        TextSpan(
                          text: model.authType == 'N' ? '未授權' : '已授權',
                          style: TextStyle(color: Colors.red[300], fontSize: MyScreen.defaultTableCellFontSize(context))
                        )
                      ]
                    ),
                  ),
                ),
              ]
            ),
          ),
          Container(
            width: double.infinity,
            // padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.red))),
            child: SizedBox(height: titleHeight(context),)
          ),
        ],
      ),
    );

    List<Widget> wList = [];
    wList.add(content);
    wList.add(
      Positioned(
        right: 5.0,
        bottom: 0.0,
        child: GestureDetector(
          child: FlatButton(
            child: autoTextSize('授權', TextStyle(color: Colors.white), context),
            color: Colors.blue[300],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            onPressed: () {
              callApiData(model);
            },
          )
        )
      ),
    );

    return Stack(
      children: wList,
    );
  }
}
class IAModel {
  String id;
  String custCode;
  String authType;
  String deptCode;
  String acceptAccNo;
  String acceptName;
  String createBy;
  String createOn;
  String updateBy;
  String updateOn;
  IAModel();
  IAModel.forMap(InterimAuthModel data) {
    id = data.ID == null ? "" : data.ID; 
    custCode = data.CustCode == null ? "" : data.CustCode; 
    authType = data.AuthType == null ? "" : data.AuthType; 
    deptCode = data.DeptCode == null ? "" : data.DeptCode; 
    acceptAccNo = data.AcceptAccNo == null ? "" : data.AcceptAccNo; 
    acceptName = data.AcceptName == null ? "" : data.AcceptName; 
    createBy = data.CreateBy == null ? "" : data.CreateBy; 
    createOn = data.CreateOn == null ? "" : data.CreateOn; 
    updateBy = data.UpdateBy == null ? "" : data.UpdateBy; 
    updateOn = data.UpdateOn == null ? "" : data.UpdateOn; 
  }
}