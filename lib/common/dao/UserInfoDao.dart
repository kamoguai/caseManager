import 'dart:convert';
import 'package:redux/redux.dart';
import 'package:case_manager/common/local/LocalStorage.dart';
import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/net/Api.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:dio/dio.dart';
import 'package:case_manager/common/redux/UserInfoRedux.dart';
import 'package:case_manager/common/dao/DaoResult.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:case_manager/common/utils/CommonUtils.dart';
import 'package:case_manager/common/model/SsoLogin.dart';
///
///使用者信息dao
///Date: 2019-06-05
///
class UserInfoDao {

  static login(account, password, store, context) async {
    // 先儲存account至手機內存
    await LocalStorage.save(Config.USER_NAME_KEY, account);
    var res = await HttpManager.netFetch(Address.ssoLoginAPI(account, password), null, null, new Options(method: "post"));
    
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("sso登入resp => " + res.data.toString());
      } 
      Sso ssoInfo = Sso.fromJson(res.data);
      await LocalStorage.save(Config.USER_ACCNAME_KEY, ssoInfo.accName);
      await LocalStorage.save(Config.USER_SSO_KEY, json.encode(ssoInfo.toJson()));
      return new DataResult(ssoInfo, true);
    }
  }

  ///初始化用戶信息
  static initUserInfo(Store store) async {
    var res = await getUserInfoLocal();
    if (res != null && res.result) {
      store.dispatch(UpdateUserAction(res.data));
    }
    return new DataResult(res.data, (res.result));
  }

   ///獲取本地登入用戶信息
  static getUserInfoLocal() async {
    var userText = await LocalStorage.get(Config.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      UserInfo user = UserInfo.fromJson(userMap);
      return new DataResult(user, true);
    } else {
      return new DataResult(null, false);
    }
  }

  ///獲取本地sso登入用戶信息
  static getUserSSOInfoLocal() async {
    var ssoText = await LocalStorage.get(Config.USER_SSO_KEY);
    if (ssoText != null) {
      var ssoMap = json.decode(ssoText);
      Sso sso = Sso.fromJson(ssoMap);
      return new DataResult(sso, true);
    } else {
      return new DataResult(null, false);
    }
  }

  ///獲取用戶詳細信息
  static getUserInfo(ssoKey, account, password, store) async {
     await LocalStorage.save(Config.PW_KEY, password);
     Map<String, dynamic> mainDataArray = {};
     var res = await HttpManager.netFetch(Address.loginWithCmAccount(account, ssoKey), null, null, null);
     
     if (res != null && res.result) {
        if (Config.DEBUG) {
          print("案件聯繫系統使用者信息resp => "+ res.data.toString());
        }
        if (res.data['Response']['ReturnCode'] == "00") {
          mainDataArray = res.data["ReturnData"];
        }
        if (mainDataArray.length > 0 ) {
          UserInfo userInfo = UserInfo.fromJson(mainDataArray);
          LocalStorage.save(Config.USER_INFO, json.encode(userInfo.toJson()));
          store.dispatch(new UpdateUserAction(userInfo));
          return new DataResult(userInfo, true);
        }
        else {
          return new DataResult(null, true);
        }
     }
  }
  
  ///登入者被註銷更新APP
  static updateDummyApp(context, blankURL) async {
    next() async {
  
      if (blankURL != null && blankURL != "") {
        CommonUtils.showDummuAppDialog(context, '此登入者信息已註銷', blankURL);
      }  
      else {
        print("is android device dummy");
        
      }
    }
    return await next();
  }

  ///檢查更新app版本
  static validNewVersion(context) async {
    var res = await HttpManager.netFetch(Address.getValidateVersionAPI(), null, null, null);
    if (res != null && res.result && res.data.length > 0) {
      if (res.data['ReturnCode'] == "00") {
        CommonUtils.showUpdateAppDialog(context, res.data['MSG'], res.data['UpdateUrl']);
      }
      else {
        Fluttertoast.showToast(msg: res.data['MSG']);
      }
    }
  }

    ///
  static isUpdateApp(context) async {
    var res = await HttpManager.netFetch(Address.getValidateVersionAPI(), null, null, null);
    if (res != null && res.result && res.data.length > 0) {
      if (res.data['ReturnCode'] == "00") {
        return true;
      }
      else {
        return false;
      }
    }
  }
}