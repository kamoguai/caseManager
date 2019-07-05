import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/net/Api.dart';

///
///統計分析相關api
///Date: 2019-07-05
class AnalizeDao {

  ///取得案件部門統計分析列表
  static getDeptCaseCount({searchYear, searchMonth}) async {
    Map<String, dynamic> mainDataArray = {};
    List<dynamic> dataArray = [];
    var res = await HttpManager.netFetch(Address.getAnalizeCaseList(searchYear, searchMonth), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("案件部門統計分析列表 resp => " + res.data.toString());
      } 
      if (res.data['Response']['ReturnCode'] == "00") {
        mainDataArray = res.data["ReturnData"];
      }
      if (mainDataArray.length > 0) {
        dataArray = mainDataArray["DeptCaseCount"];
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