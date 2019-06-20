

import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/net/Api.dart';

///
///部門相關API呼叫
///Date: 2019-06-10
///
class DeptInfoDao {
  ///部門list
  static getDeptSelect(userId) async {
    var res = await HttpManager.netFetch(Address.didUserDeptSelect(userId), null, null, null);
    Map<String, dynamic> mainDataArray = {};
    List<dynamic> dataArray = [];
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("部門list resp => " + res.data.toString());
      } 
      if (res.data['Response']['ReturnCode'] == "00") {
        mainDataArray = res.data["ReturnData"];
      }
      if (mainDataArray.length > 0) {
        dataArray = mainDataArray["DeptDatas"];
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