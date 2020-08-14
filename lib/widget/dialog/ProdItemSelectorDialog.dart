import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/CommonUtils.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';

///
///二次授權產品選擇器
///Data: 2020-08-10
///
class ProdItemSelectorDialog extends StatefulWidget {
  ///由前畫面帶入產品訊息
  final List<dynamic> dataArray;

  ///由前端帶入客編
  final String customerCode;

  ///由前畫面帶入，input: 輸入畫面，list: 列表畫面
  final String pageType;

  ///callback func
  final Function excuteTempAuthProds;

  /// pageType = list
  final String listID;

  ProdItemSelectorDialog(
      {this.dataArray,
      this.customerCode,
      this.pageType,
      this.excuteTempAuthProds,
      this.listID});
  @override
  _ProdItemSelectorDialogState createState() => _ProdItemSelectorDialogState();
}

class _ProdItemSelectorDialogState extends State<ProdItemSelectorDialog>
    with BaseWidget {
  List<dynamic> prodItems = [];
  List<dynamic> originItems = [];
  Map<String, dynamic> map = {};
  List<dynamic> pickData = [];

  @override
  void initState() {
    super.initState();
    _initData();
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
    item = Column(
      children: [
        GestureDetector(
          child: Container(
              color: pickData.contains(dicIndex.code)
                  ? Colors.yellow
                  : Colors.white,
              height: titleHeight(context) * 1.5,
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Center(
                child: autoTextSize(
                    dicIndex.name,
                    TextStyle(
                        color: Colors.black,
                        fontSize: MyScreen.homePageFontSize(context)),
                    context),
              )),
          onTap: () {
            setState(() {
              if (pickData.contains(dicIndex.code)) {
                pickData.remove(dicIndex.code);
              } else {
                pickData.add(dicIndex.code);
              }
            });
            print('select dept -> $pickData');
          },
        ),
        Container(
          color: Colors.grey,
          height: 2,
          width: double.infinity,
        ),
        SizedBox(
          height: 2,
        )
      ],
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
          itemCount: this.prodItems.length,
        ),
      );
    } else {
      list = Container(
        child: Center(
          child: autoTextSize('查無資料', TextStyle(color: Colors.black), context),
        ),
      );
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
              child: Center(
                child: autoTextSize(
                    '選擇二授產品',
                    TextStyle(
                        color: Colors.white,
                        fontSize: MyScreen.homePageFontSize(context)),
                    context),
              )),
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
                        child: autoTextSize(
                            '取消',
                            TextStyle(
                                color: Colors.black,
                                fontSize: MyScreen.homePageFontSize(context)),
                            context),
                        onPressed: () {
                          //第一次pop跳離dialog
                          Navigator.pop(context, 'cancel');
                        },
                      ),
                    )),
                Expanded(
                    flex: 5,
                    child: Container(
                      height: titleHeight(context) * 1.5,
                      child: FlatButton(
                        color: Color(MyColors.hexFromStr('#40b89e')),
                        child: autoTextSize(
                            '確定',
                            TextStyle(
                                color: Colors.white,
                                fontSize: MyScreen.homePageFontSize(context)),
                            context),
                        onPressed: () {
                          CommonUtils.showLoadingDialog(context);
                          _sendProdCodes(widget.customerCode);
                          Future.delayed(const Duration(milliseconds: 1000),
                              () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  ///將傳入data分成可選data
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

  void _initData() {
    this.pickData = [];
    this.prodItems = [];
    this.map = {};
  }

  ///送出產品code
  void _sendProdCodes(custCode) {
    var originData = widget.dataArray;
    this.originItems = [];
    for (var dic in originData) {
      var isSuspend = dic["isSuspend"].toString();
      var isSecond = dic["isSecondAuthorize"].toString();

      ///將可二授權的產品分出並add在originItems裡面
      if (isSuspend == "1" && isSecond == "1") {
        var prodCode = dic["code"].toString();
        this.originItems.add(prodCode);
      }
    }

    ///將所選code和originItems合在一起
    this.originItems.addAll(this.pickData);

    ///如果是列表頁送出
    if (widget.pageType == 'list') {
      widget.excuteTempAuthProds(this.originItems, custCode, widget.pageType,
          listID: widget.listID);
    } else {
      ///如果是輸入頁送出
      widget.excuteTempAuthProds(this.originItems, custCode, widget.pageType);
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
    isSuspend = dic["isSuspend"];
    isSecondAuthorize = dic["isSecondAuthorize"];
  }
}
