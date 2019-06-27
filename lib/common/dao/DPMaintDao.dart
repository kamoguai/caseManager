
import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/net/Api.dart';
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
}