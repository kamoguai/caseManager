

import 'dart:convert';

import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/local/LocalStorage.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/net/Api.dart';
import 'package:dio/dio.dart';

///
///首頁相關API呼叫
///Date: 2019-06-10
///
class HomeDao {
  ///取得使用者案件筆數
  static getUserCaseType(account) async {
    var res = await HttpManager.netFetch(Address.getUserCaseType(account), null, null, null);
    Map<String, dynamic> mainDataArray = {};
    Map<String, dynamic> userData = {};
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("首頁使用者案件筆數 resp => " + res.data.toString());
      } 
      if (res.data['Response']['ReturnCode'] == "00") {
        mainDataArray = res.data["ReturnData"];
      }
      if (mainDataArray.length > 0) {
        userData = mainDataArray["UserCaseCount"];
        return new DataResult(userData, true);

      }
      else {
        return new DataResult(null, false);
      }
    }
    else {
      return new DataResult(null, false);
    }
  }
  ///snr設定檔
  static getSnrConfigAPI() async {
    Map<String, dynamic> mainDataArray = {};
    Map<String, dynamic> dataArray = {};
    var res = await HttpManager.netFetch(Address.getQueryConfigureAPI(), null, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("取得snr設定檔 resp => ${res.data.toString()}");
      }
      if (res.data['Response']['ReturnCode'] == "0") {
        mainDataArray = res.data["ReturnData"];
      }
      if (res.data['Response']['ReturnCode'] == "0") {
        mainDataArray = res.data["ReturnData"];
      }
      if (mainDataArray.length > 0 ){
        dataArray = mainDataArray["Data"];
        await LocalStorage.save(Config.SNR_CONFIG, json.encode(dataArray));
      }
    }
  }
}