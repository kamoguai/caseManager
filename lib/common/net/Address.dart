import 'dart:io';
import 'package:flutter/services.dart';
import 'package:case_manager/common/utils/AesUtils.dart';
///地址數據
class Address {
  static const String ssoDomain = "http://nsso.dctv.net.tw:8081/";
  static const String aesDomain = "http://asg.dctv.net.tw:8082/EncEDI/interfaceAES?data=";
  static const String ssoDomainName = "http://wos.dctv.net.tw:8081/";
  static const String kCMHostPath = "http://msg.dctv.net.tw/api/Q2/?";
  static const String kDHostPath = "http://msg.dctv.net.tw/api/OnDuty/?";
  static const String kAreaHostPath = "http://msg.dctv.net.tw/api/AreaBugData?";
  static const String getSsoKey = "SSO/json/login.do?";
  static const String getVersion = "ValidataVersion/json/index!checkVersion.action?";
  static const String loginAPI = "WorkOrder/json/wok!login.action?";
  static final String bundleID = "com.dctv.caseManager";
  static final String verNo = "3.0.0522";


  ///檢查是否有更新app
  static getValidateVersionAPI() {
    String deviceType = "";
    try {
      if (Platform.isAndroid) {
        deviceType = "android";
      }
      else if (Platform.isIOS) {
        deviceType = 'ios';
      }
    } on PlatformException {
      
    }
    return "${ssoDomainName}/${getVersion}packageName=${bundleID}&type=$deviceType&verNo=${verNo}";
  }

  ///登入SSO
  static ssoLoginAPI(account, password) {
    String deviceType = "";
    try {
      if (Platform.isAndroid) {
        deviceType = "android";
      }
      else if (Platform.isIOS) {
        deviceType = 'ios';
      }
    } on PlatformException {
      
    }
    return "${ssoDomain}${getSsoKey}function=login&accNo=$account&passWord=$password&uniqueCode=12343234&sysName=caseinformation&tokenType=$deviceType&tokenID=slg;ksl;dc123&packageName=com.dctv.caseinformation&type=$deviceType";
  }

  ///登入取得使用者資訊
  static loginWithCmAccount(account, ssokey) {
    return "${kCMHostPath}FunctionName=Login2&SYSName=caseinformation&Account=$account&SSOKey=$ssokey";
  }

  ///取得當班主管
  static getDataOfShiftLeader() {
    return "${kDHostPath}FunctionName=GetData";
  }

  ///立案
  static createCaseWithAccount(area, address, qData, accNo) {
    return "${kAreaHostPath}FunctionName=CreateCase&Area=$area&Address=$address&Qdata=$qData&Accno=$accNo";
  }
  ///讀取case
  static readerCase(id, accNo, name) {
    return "${kAreaHostPath}FunctionName=Reader&ID=$id&AccNo=$accNo&Name=$name";
  }
  ///關閉case
  static setCloseCase(id, reason, accNo, name) {
    return "${kAreaHostPath}FunctionName=SetClose&ID=$id&Reason=$reason&AccNo=$accNo&Name=$name";
  }
  ///回報case
  static setReportCase(id, backData, accNo, name) {
    return "${kAreaHostPath}FunctionName=BackData&ID=$id&BackData=$backData&Accno=$accNo&Name=$name";
  }
  ///取得關閉case資料
  static getEventsCloseCaseWithArea(area) {
    return "${kAreaHostPath}FunctionName=CloseCase&Area=$area";
  }
  ///取得open case資料
  static getEventsOpenCase() {
   return "${kAreaHostPath}FunctionName=OpenCase";
  }

  ///指派單位 or 條件查詢 by uniqueCode
  static didAssignDepList(userId, uniqueCode) {
    var urlStr = "${kCMHostPath}FunctionName=AssignDeptList&UserID=$userId";
    if (uniqueCode != null && uniqueCode != "") {
      urlStr += "&uniqueCode=$uniqueCode";
    }
    return urlStr;
  }
  ///取得部門編號, or 條件查詢 by id
  static didDeptSelect(userId) {
    var urlStr = "${kCMHostPath}FunctionName=DeptSelect";
    if (userId != null && userId != "") {
      urlStr += "&UserID=$userId";
    }
    return urlStr;
  }
  ///取得使用者部門編號
  static didUserDeptSelect(userId) {
    return "${kCMHostPath}FunctionName=userdeptselect&UserID=$userId";
  }
  ///取得部門內員工資料
  static didEmplSelect(deptId) {
    return "${kCMHostPath}FunctionName=EmplSelect&DeptID=$deptId";
  }
  ///指派case給部門
  static didAssignDeptCase(userId, caseId) {
    return "${kCMHostPath}FunctionName=AssignDeptCase&UserID=$userId&CaseID=$caseId";
  }
  ///指派部門, params: userId, caseId, funit, newAData
  static didAssignDept(userId, caseId, funit, newAData) {
    return "${kCMHostPath}FunctionName=AssignDept&UserID=$userId&CaseID=$caseId&FUnit=$funit&NewAData=$newAData";
  }
  ///指派部門 params: userId, caseId, funit, puserId, newAData
  static didAssignDeptExt(userId, caseId, funit, puserId, newAData) {
    return "${kCMHostPath}FunctionName=AssignDept&UserID=$userId&CaseID=$caseId&FUnit=$funit&NewAData=$newAData&PuserID=$puserId";
  }
  ///取得指派部門員工
  static didAssignEmplList(userId, deptId) {
    return "${kCMHostPath}FunctionName=AssignEmplList&UserID=$userId&DeptID=$deptId";
  }
  ///指派case給員工
  static didAssignEmplCase(userId, caseId) {
    return "${kCMHostPath}FunctionName=AssignEmplList&UserID=$userId&CaseID=$caseId";
  }
  ///指派員工
  static didAssignEmpl(userId, caseId, pUser) {
    return "${kCMHostPath}FunctionName=AssignEmpl&UserID=$userId&CaseID=$caseId&PUser=$pUser";
  }
  ///取得
  static didMaintList(userId, deptId) {
    return "${kCMHostPath}FunctionName=MaintList&UserID=$userId&DeptID=$deptId";
  }
  ///取得業務list
  static didGetSalesMaintList(userId, deptId) {
    return "${kCMHostPath}FunctionName=SalesList&UserID=$userId&DeptID=$deptId";
  }
  ///
  static didGetMaintListExt(itype, userId, deptId, searchStatus, searchCaseType, searchSubject, searchCustNo, searchSerial) {
    var urlStr = "${kCMHostPath}FunctionName=MaintList&UserID=$userId&DeptID=$deptId";
    if (itype == 1) {
      if (searchStatus.length > 0) {
        urlStr += "&SearchStatus=$searchStatus";
      }
      if (searchCaseType.length > 0) {
        urlStr += "&SearchCaseType=$searchCaseType";
      }
      if (searchSubject.length > 0) {
        urlStr += "&SearchSubject=$searchSubject";
      }
      if (searchCustNo.length > 0) {
        urlStr += "&SearchCustNO=$searchCustNo";
      }
      if (searchSerial.length > 0) {
        urlStr += "&SearchSerial=$searchSerial";
      }
    }
    return urlStr;
  }
  ///
  static didMaintCase(userId, caseId) {
    return "${kCMHostPath}FunctionName=MaintCase&UserID=$userId&CaseID=$caseId";
  }
  ///
  static didMaint(userId, caseId, newStatus, newAData) {
    return "${kCMHostPath}FunctionName=Maint&UserID=$userId&CaseID=$caseId&newStatus=$newStatus&newAData=$newAData";
  }
  ///部門關閉list
  static didDeptCloseList(userId, deptId) {
    return "${kCMHostPath}FunctionName=DeptCloseList&UserID=$userId&DeptID=$deptId";
  }
  ///部門關閉case list
  static didDeptCloseCase(userId, caseId) {
    return "${kCMHostPath}FunctionName=DPMaintCase&UserID=$userId&CaseID=$caseId";
  }
  ///部門關閉case
  static didDeptClose(userId, caseId) {
    return "${kCMHostPath}FunctionName=DeptClose&UserID=$userId&CaseID=$caseId";
  }
  ///file list
  static didFileList(userId) {
    return "${kCMHostPath}FunctionName=FileList&UserID=$userId";
  }
  ///file case
  static didFileCase(userId, caseId) {
    return "${kCMHostPath}FunctionName=FileCase&UserID=$userId&CaseID=$caseId";
  }
  ///
  static didFile(userId, caseId) {
    return "${kCMHostPath}FunctionName=File&UserID=$userId&CaseID=$caseId";
  }
  ///取得case狀態
  static getCaseType() {
    return "${kCMHostPath}FunctionName=CaseTypeSelect";
  }
  ///
  static didGetDPMaintList(iType, userId, searchFunit, searchStatus, searchCaseType, searchSubject, searchCustNo, searchSerial, searchPuser,) {
    var urlStr = "${kCMHostPath}FunctionName=DPMaintList&UserID=$userId&SearchFUnit=$searchFunit";
    if (iType == 1) {
      if (searchStatus.length > 0) {
        urlStr += "&SearchStatus=$searchStatus";
      }
      if (searchCaseType.length > 0) {
        urlStr += "&SearchCaseType=$searchCaseType";
      }
      if (searchSubject.length > 0) {
        urlStr += "&SearchSubject=$searchSubject";
      }
      if (searchCustNo.length > 0) {
        urlStr += "&SearchCustNO=$searchCustNo";
      }
      if (searchSerial.length > 0) {
        urlStr += "&SearchSerial=$searchSerial";
      }
      if (searchPuser.length > 0) {
        urlStr += "&SearchPuser=$searchPuser";
      }
    }
    return urlStr;
  }
  ///業務ok
  static toSalesOk(userId, caseId, toSales) {
    return "${kCMHostPath}FunctionName=ToSalesOk&UserID=$userId&CaseID=$caseId&ToSales=$toSales";
  }
  ///
  static assignDPMaint(userId, caseId, pdeptId, puserId, newStatus, newAData) {
    return "${kCMHostPath}FunctionName=DPMaint&UserID=$userId&CaseID=$caseId&PDeptID=$pdeptId&PUserID=$puserId&NewStatus=$newStatus&NewAData=$newAData";
  }
  ///取得使用者案件筆數
  static getUserCaseType(account) {
    return "${kCMHostPath}FunctionName=GetUserCaseCount&account=$account";
  }

}