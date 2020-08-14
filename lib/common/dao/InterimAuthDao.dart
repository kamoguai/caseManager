import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/net/Api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// 二次授權相關
///Date: 2020-01-09
class InterimAuthDao {
  ///取得二次授權案件list
  static getInterimAuthList({userId}) async {
    Map<String, dynamic> mainDataArray = {};
    List<dynamic> dataArray = [];
    var res = await HttpManager.netFetch(
        Address.didGetInterimAuthList(userId), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("二次授權案件list resp => " + res.data.toString());
      }
      if (res.data['Response']['ReturnCode'] == "00") {
        mainDataArray = res.data["ReturnData"];
      }
      if (mainDataArray.length > 0) {
        dataArray = mainDataArray["QLists"];
        return new DataResult(dataArray, true);
      } else {
        return new DataResult(null, false);
      }
    } else {
      return new DataResult(null, false);
    }
  }

  /// 二次授權post
  static postInterimAuth({
    custCode,
    userId,
    prodItems,
  }) async {
    var res = await HttpManager.netFetch(
        Address.postTempAuthorize(custCode, userId, prodItems: prodItems),
        null,
        null,
        null);
    List<dynamic> dataArray = [];
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("二次授權 resp => " + res.data.toString());
      }
      if (res.data['retCode'] == "00") {
        var data = res.data["data"];
        if (data["RtnCD"] == "00") {
          Fluttertoast.showToast(
              msg: '授權成功',
              timeInSecForIos: 2,
              backgroundColor: Colors.black,
              textColor: Colors.white);
          return new DataResult(null, true);
        } else if (data["RtnCD"] == "01") {
          dataArray = data["productInfos"];
          return new DataResult(dataArray, true);
        } else {
          Fluttertoast.showToast(msg: '${data['RtnMsg']}');
          return new DataResult(data, false);
        }
      } else {
        Fluttertoast.showToast(msg: '${res.data['retName']}');
        return new DataResult(res.data, false);
      }
    }
  }

  /// 二次授權更新db狀態
  static interimAuthUpdate({userId, id, acceptAccNo}) async {
    var res = await HttpManager.netFetch(
        Address.updateTempAuthorize(userId, id, acceptAccNo), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("二次授權更新db狀態 resp => " + res.data.toString());
      }
      if (res.data['Response']['ReturnCode'] == "00") {
        Fluttertoast.showToast(
            msg: '授權成功',
            timeInSecForIos: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(msg: '${res.data['Response']['MSG']}');
      }
      return new DataResult(null, true);
    } else {
      return new DataResult(null, false);
    }
  }
}
