
import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/net/Api.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
///個人案件相關api呼叫
///Date: 2019-06-11
///
class MaintDao{
  ///取得個人案件處理清單
  static getMaintList({userId, deptId}) async {
    Map<String, dynamic> mainDataArray = {};
    List<dynamic> dataArray = [];
    var res = await HttpManager.netFetch(Address.didMaintList(userId, deptId), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("個人案件list resp => " + res.data.toString());
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
  ///取得個人案件處理清單，條件查詢
  static getMaintListExt({itype, userId, deptId, searchStatus, searchCaseType, searchSubject, searchCustNo, searchSerial}) async {
     Map<String, dynamic> mainDataArray = {};
     List<dynamic> dataArray = [];
     var res = await HttpManager.netFetch(Address.didGetMaintListExt(itype, userId, deptId, searchStatus, searchCaseType, searchSubject, searchCustNo, searchSerial), null, null, null);
     if (res != null && res.result) {
      if (Config.DEBUG) {
        print("個人案件list resp => " + res.data.toString());
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
  ///個人案件處理案件
  static getMaintCase({userId, caseId}) async {
    Map<String, dynamic> mainDataArray = {};
    Map<String, dynamic> dataArray = {};
    var res = await HttpManager.netFetch(Address.getMaintCase(userId, caseId), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("個人案件處理 resp => " + res.data.toString());
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
  ///個人案件回覆作業
  static didMaint({userId, caseId, newStatus, newAData}) async {
    
    var res = await HttpManager.netFetch(Address.didMaint(userId, caseId, newStatus, newAData), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("個人案件處理作業 resp => " + res.data.toString());
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
  ///案件狀態選擇list
  static caseTypeSelect() async {
    Map<String, dynamic> mainDataArray = {};
    List<dynamic> dataArray = [];
    var res = await HttpManager.netFetch(Address.getCaseType(), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("案件狀態選擇list resp => " + res.data.toString());
      } 
      if (res.data['Response']['ReturnCode'] == "00") {
        mainDataArray = res.data["ReturnData"];
      }
      if (mainDataArray.length > 0) {
        dataArray = mainDataArray["CaseTypeDatas"];
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
  ///工程結案轉業務回覆目前案件狀態
  static didToSalesOk(userId, caseId, toSales) async {
    var res = await HttpManager.netFetch(Address.toSalesOk(userId, caseId, toSales), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("工程結案轉業務回覆目前案件狀態 resp => " + res.data.toString());
      } 
      if (res.data['Response']['ReturnCode'] == "00") {
        Fluttertoast.showToast(msg:'回傳資料成功!');
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