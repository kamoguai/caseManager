
import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/net/Api.dart';
import 'package:fluttertoast/fluttertoast.dart';
///
///單位案件處理頁面api
///Date: 2019-06-27
class DPMaintDao {
  ///取得單位案件處理列表
  static getDPMaintList({iType, userId, searchFunit, searchStatus, searchCaseType, searchSubject, searchCustNo, searchSerial, searchPuser}) async {
    Map<String, dynamic> mainDataArray = {};
    List<dynamic> dataArray = [];
    var res = await HttpManager.netFetch(Address.didGetDPMaintList(iType, userId, searchFunit, searchStatus, searchCaseType, searchSubject, searchCustNo, searchSerial, searchPuser), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("單位案件list resp => " + res.data.toString());
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
  ///將多筆案件結案api
  static postDPMaintClose({userId, caseId}) async {
    var res = await HttpManager.netFetch(Address.didDeptClose(userId, caseId), null, null, null);
    if (res != null && res.result) {
      if (res.data['Response']['ReturnCode'] == "00") {
        Fluttertoast.showToast(msg: '單位結案成功');
      }
      else {
         Fluttertoast.showToast(msg:'${res.data['Response']['MSG']}');
      }
    }
  }
  ///取得部門詳情api
  static getDPMaintDetail({userId, caseId}) async {
    Map<String, dynamic> mainDataArray = {};
    Map<String, dynamic> dataArray = {};
    var res = await HttpManager.netFetch(Address.getDeptCaseDetail(userId, caseId), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("部門詳情 resp => " + res.data.toString());
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
  ///單位回覆作業
  static didDPMaint({userId, caseId, newStatus, newAData, deptId, pUserId}) async {
    
    var res = await HttpManager.netFetch(Address.assignDPMaint(userId, caseId, deptId, pUserId, newStatus, newAData), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("單位回覆作業 resp => " + res.data.toString());
      } 
      if (res.data['Response']['ReturnCode'] == "00") {
        Fluttertoast.showToast(msg:'回覆成功');
      }
      else {
        Fluttertoast.showToast(msg:'${res.data['Response']['MSG']}');
      }
      
    }
    else {
      return new DataResult(null, false);
    }
  }
  ///單位部門結案列表
  static getDPMaintCloseList({userId, deptId}) async {
    Map<String, dynamic> mainDataArray = {};
    List<dynamic> dataArray = [];
    var res = await HttpManager.netFetch(Address.getDeptCloseList(userId, deptId), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("單位案件結案list resp => " + res.data.toString());
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
  ///單位部門結案詳情
  static getDPMaintCloseDetail({userId, caseId}) async {
    Map<String, dynamic> mainDataArray = {};
    Map<String, dynamic> dataArray = {};
    var res = await HttpManager.netFetch(Address.getDeptCloseCase(userId, caseId), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("部門結案詳情 resp => " + res.data.toString());
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
}