import 'package:auto_size_text/auto_size_text.dart';
import 'package:case_manager/common/dao/MaintDao.dart';
import 'package:case_manager/common/model/MaintTableCell.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/material.dart';

class FilterCaseTypeDialog extends StatefulWidget {
  ///是否點擊此下拉選單
  final isClickDeptSelect;

  ///依功能使用選擇器
  final fromFunc;

  ///由前畫面帶入data
  final dataArray;
  final originArray;

  ///呼叫function給主頁使用
  final Function callApiData;
  FilterCaseTypeDialog(
      {this.dataArray,
      this.originArray,
      this.isClickDeptSelect,
      this.fromFunc,
      this.callApiData});
  @override
  _FilterCaseTypeDialogState createState() => _FilterCaseTypeDialogState();
}

class _FilterCaseTypeDialogState extends State<FilterCaseTypeDialog>
    with BaseWidget {
  ///案件類型資料arr
  final List<dynamic> caseArray = [];

  ///所選caseType
  final List<dynamic> pickCaseIdArray = [];

  ///model
  CaseTypeSelectorModel model;

  ///textFieldController
  TextEditingController editingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    initParam();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  autoTextSize(text, style, context) {
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
  _getApiData() async {
    var res = await MaintDao.caseTypeSelect();
    if (res != null && res.result) {
      setState(() {
        Map<String, dynamic> map = new Map<String, dynamic>();
        for (var dic in res.data) {
          if (dic["CaseTypeName"] == "工程會勘") {
            map["CaseTypeID"] = dic["CaseTypeID"];
            map["CaseTypeName"] = dic["CaseTypeName"];
            continue;
          }
          caseArray.add(dic);
        }
        caseArray.insert(0, map);
        for (var dic in caseArray) {
          pickCaseIdArray.add(dic["CaseTypeName"]);
        }
      });
    }
  }

  ///filter功能
  void filterSearchReasult(String str) {
    List<dynamic> dummySearchList = List<dynamic>();
    dummySearchList.addAll(caseArray);
    if (str.isNotEmpty) {
      List<dynamic> dummyListData = List<dynamic>();
      dummySearchList.forEach((item) {
        if (item['CaseTypeName'].contains(str)) {
          dummyListData.add(item);
          setState(() {
            caseArray.clear();
            caseArray.addAll(dummyListData);
          });
        }
      });
      return;
    } else {
      setState(() {
        caseArray.clear();
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
          labelText: '案件類型',
          hintText: '',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
        ),
      ),
    );
    return widget;
  }

  ///widget list item
  Widget listItem(BuildContext context, int index) {
    Widget item;
    var dicIndex = caseArray[index];
    var dic = CaseTypeSelectorModel.forMap(dicIndex);
    item = GestureDetector(
      child: Container(
        height: titleHeight(context) * 1.5,
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Row(
          children: [
            Expanded(
                flex: 1, child: changeCheckIcon(context, dic.caseTypeName)),
            Expanded(
              flex: 2,
              child: autoTextSize(
                  dic.caseTypeName,
                  TextStyle(
                      color: Colors.black,
                      fontSize: MyScreen.homePageFontSize(context)),
                  context),
            )
          ],
        ),
      ),
      onTap: () {
        addCaseIdFunc(dic.caseTypeName);
        print('select dept -> $pickCaseIdArray');
      },
    );

    return item;
  }

  ///widget list view
  Widget listView() {
    Widget list;
    if (caseArray.length > 0) {
      list = Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: listItem,
          itemCount: caseArray.length,
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

  ///選定check改變icon圖示
  Icon changeCheckIcon(context, pickData) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var iconSize = 20.0;
    if (deviceHeight < 590) {
      iconSize = titleHeight(context) * 1.2;
    } else if (deviceHeight < 600) {
      iconSize = titleHeight(context) * 1.1;
    } else {
      iconSize = listHeight(context) * 0.9;
    }
    if (pickCaseIdArray.contains(pickData)) {
      return Icon(
        Icons.check_box,
        color: Colors.blue,
        size: iconSize,
      );
    } else {
      return Icon(Icons.check_box_outline_blank,
          color: Colors.grey, size: iconSize);
    }
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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(width: 150, child: showLoadingAnime(context))
        : Container(
            //  padding: EdgeInsets.symmetric(vertical: 20.0),
            //  decoration: BoxDecoration(shape: BoxShape.circle),
            //  height: deviceHeight4(context) * 2,
            child: Column(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      color: Color(MyColors.hexFromStr('#40b89e')),
                    ),
                    height: titleHeight(context) * 1.5,
                    child: Center(
                      child: autoTextSize(
                          '選擇案件類型',
                          TextStyle(
                              color: Colors.white,
                              fontSize: MyScreen.homePageFontSize(context)),
                          context),
                    )),
                // searchTextField(),
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
                                      fontSize:
                                          MyScreen.homePageFontSize(context)),
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
                                      fontSize:
                                          MyScreen.homePageFontSize(context)),
                                  context),
                              onPressed: () {
                                if (pickCaseIdArray.length > 0) {
                                  List<MaintTableCell> list = new List();
                                  for (var dic in pickCaseIdArray) {
                                    for (var data in widget.dataArray) {
                                      if (dic == data["CaseTypeName"]) {
                                        list.add(MaintTableCell.fromJson(data));
                                      }
                                    }
                                  }
                                  widget.callApiData(list);
                                }
                                Navigator.pop(context, 'ok');
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
}

class CaseTypeSelectorModel {
  ///部門id
  String caseTypeID;

  ///部門名稱
  String caseTypeName;
  CaseTypeSelectorModel();

  CaseTypeSelectorModel.forMap(dic) {
    caseTypeID = dic["CaseTypeID"] == null ? "" : dic["CaseTypeID"];
    caseTypeName = dic["CaseTypeName"] == null ? "" : dic["CaseTypeName"];
  }
}
