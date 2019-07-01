import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/net/Api.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
///案件歸檔相關api
///Date: 2019-07-01
class FileDao {

  ///案件歸檔list
  static getFileList({userId}) async {
    Map<String, dynamic> mainDataArray = {};
    List<dynamic> dataArray = [];
    var res = await HttpManager.netFetch(Address.getFileList(userId), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("案件歸檔list resp => " + res.data.toString());
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

  ///檔案歸檔詳情
  static getFileCaseDetail({userId, caseId}) async {
    Map<String, dynamic> mainDataArray = {};
    Map<String, dynamic> dataArray = {};
    var res = await HttpManager.netFetch(Address.getFileCase(userId, caseId), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("檔案歸檔詳情 resp => " + res.data.toString());
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

  ///檔案歸檔執行
  static postFile({userId, caseId}) async {
    var res = HttpManager.netFetch(Address.didFile(userId, caseId), null, null, null);
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
}