

import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/net/Api.dart';
///
///首頁相關API呼叫
///Date: 2019-06-10
///
class HomeDao {
  
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

}