import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/net/Api.dart';

///
/// 二次授權相關
///Date: 2020-01-09
class InterimAuthDao {

  ///取得二次授權案件list
  static getInterimAuthList({userId}) async {
    Map<String, dynamic> mainDataArray = {};
    List<dynamic> dataArray = [];
    var res = await HttpManager.netFetch(Address.didGetInterimAuthList(userId), null, null, null);
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

      }
      else {
        return new DataResult(null, false);
      }
    }
    else {
      return new DataResult(null, false);
    }
  }

  ///二次授權post
  static postInterimAuth() async {
    
  }

}