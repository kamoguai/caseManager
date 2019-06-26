import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/net/Api.dart';
import 'package:fluttertoast/fluttertoast.dart';
///
///指派個人API呼叫
///Date: 2019-06-25
class AssignDao {
  ///取得指派個人案件處理清單
  static getAssignEmplList({userId, deptId}) async {
    Map<String, dynamic> mainDataArray = {};
    List<dynamic> dataArray = [];
    var res = await HttpManager.netFetch(Address.didAssignEmplList(userId, deptId), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("指派個人案件list resp => " + res.data.toString());
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
  
  ///指派個人案件處理案件
  static getAssignEmplCase({userId, caseId}) async {
    Map<String, dynamic> mainDataArray = {};
    Map<String, dynamic> dataArray = {};
    var res = await HttpManager.netFetch(Address.didAssignEmplCase(userId, caseId), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("指派個人案件處理 resp => " + res.data.toString());
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
  ///指派個人案件處理作業
  static didAssignEmpl({userId, caseId, pUser}) async {
    
    var res = await HttpManager.netFetch(Address.didAssignEmpl(userId, caseId, pUser), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("指派個人案件處理作業 resp => " + res.data.toString());
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