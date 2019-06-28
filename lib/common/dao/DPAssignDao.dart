import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/net/Api.dart';
import 'package:fluttertoast/fluttertoast.dart';
///
///單位指派相關api呼叫
///Date: 2019-06-28
class DPAssignDao {

  ///取得指派單位列表
  static getDPAssignList({userId, uniqueCode}) async {
    Map<String, dynamic> mainDataArray = {};
    List<dynamic> dataArray = [];
    var res = await HttpManager.netFetch(Address.didAssignDepList(userId, uniqueCode), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("指派單位列表 resp => " + res.data.toString());
      } 
      if (res.data['Response']['ReturnCode'] == "00") {
        mainDataArray = res.data["ReturnData"];
      }
      if (mainDataArray.length > 0) {
        dataArray = mainDataArray["QLists"];
        return new DataResult(dataArray, true);

      }
      else {
        return new DataResult(null, false);
      }
    }
    else {
      return new DataResult(null, false);
    }
  }
  ///取得單位指派詳情
  static getDPAssignDetail({userId, caseId}) async {
    Map<String, dynamic> mainDataArray = {};
    Map<String, dynamic> dataArray = {};
    var res = await HttpManager.netFetch(Address.didAssignDeptCase(userId, caseId), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("單位指派詳情 resp => " + res.data.toString());
      } 
      if (res.data['Response']['ReturnCode'] == "00") {
        mainDataArray = res.data["ReturnData"];
      }
      if (mainDataArray.length > 0) {
        dataArray = mainDataArray["QDetail"];
        return new DataResult(dataArray, true);

      }
      else {
        return new DataResult(null, false);
      }
    }
    else {
      return new DataResult(null, false);
    }
  }
  ///單位指派回覆
  static didDPAssignCase({userId, caseId, funit, newAData}) async {
    var res = await HttpManager.netFetch(Address.didAssignDept(userId, caseId, funit, newAData), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("單位指派回覆 resp => " + res.data.toString());
      } 
      if (res.data['Response']['ReturnCode'] == "00") {
        Fluttertoast.showToast(msg:'指派成功');
      }
      else {
        Fluttertoast.showToast(msg:'${res.data['Response']['MSG']}');
      }
      
    }
    else {
      return new DataResult(null, false);
    }
  }
}