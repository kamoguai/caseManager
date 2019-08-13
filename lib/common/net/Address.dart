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
  static const String kSNRHostName = "http://snr.dctv.tw:25888/";
  static const String kSNRHostPingName = "http://snr.dctv.tw:8989/";
  static const String getSsoKey = "SSO/json/login.do?";
  static const String getVersion = "ValidataVersion/json/index!checkVersion.action?";
  static const String loginAPI = "WorkOrder/json/wok!login.action?";
  static final String bundleID = "com.dctv.caseManager";
  static final String verNo = "3.0.0811";


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
    return "$ssoDomainName/${getVersion}packageName=$bundleID&type=$deviceType&verNo=$verNo";
  }

  ///登入SSO
  static ssoLoginAPI(account, password, tokenId) {
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
    return "$ssoDomain${getSsoKey}function=login&accNo=$account&passWord=$password&uniqueCode=12343234&sysName=caseManager&tokenType=$deviceType&tokenID=$tokenId&packageName=com.dctv.caseManager&type=$deviceType";
  }
  ///-------------------- caseManager api -------------------- ///
  ///登入取得使用者資訊
  static loginWithCmAccount(account, ssokey) {
    return "${kCMHostPath}FunctionName=Login2&SYSName=caseManager&Account=$account&SSOKey=$ssokey";
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
  ///取得部門內員工list
  static didEmplSelect(deptId) {
    return "${kCMHostPath}FunctionName=EmplSelect&DeptID=$deptId";
  }
  ///指派case給部門
  static didAssignDeptCase(userId, caseId) {
    return "${kCMHostPath}FunctionName=AssignDeptCase&UserID=$userId&CaseID=$caseId";
  }
  ///指派部門, params: userId, caseId, funit, newAData
  static didAssignDept(userId, caseId, funit, newAData, pUserId) {
    return "${kCMHostPath}FunctionName=AssignDept&UserID=$userId&CaseID=$caseId&FUnit=$funit&PUserID=$pUserId&NewAData=$newAData";
  }
  ///指派部門 params: userId, caseId, funit, puserId, newAData
  static didAssignDeptExt(userId, caseId, funit, puserId, newAData) {
    return "${kCMHostPath}FunctionName=AssignDept&UserID=$userId&CaseID=$caseId&FUnit=$funit&NewAData=$newAData&PuserID=$puserId";
  }
  ///取得指派部門員工案件列表
  static didAssignEmplList(userId, deptId) {
    return "${kCMHostPath}FunctionName=AssignEmplList&UserID=$userId&DeptID=$deptId";
  }
  ///指派case給員工詳情
  static didAssignEmplCase(userId, caseId) {
    return "${kCMHostPath}FunctionName=AssignEmplCase&UserID=$userId&CaseID=$caseId";
  }
  ///指派員工作業
  static didAssignEmpl(userId, caseId, pUser) {
    return "${kCMHostPath}FunctionName=AssignEmpl&UserID=$userId&CaseID=$caseId&PUser=$pUser";
  }
  ///取得個人案件處理清單
  static didMaintList(userId, deptId) {
    return "${kCMHostPath}FunctionName=MaintList&UserID=$userId&DeptID=$deptId";
  }
  ///取得業務list
  static getSalesMaintList(userId, deptId, searchStatus) {
    var str = "${kCMHostPath}FunctionName=SalesList&UserID=$userId&DeptID=$deptId";
    if (searchStatus != null && searchStatus != '') {
      str += "&$searchStatus";
    }
    return str;
  }
  ///取得個人案件處理清單，條件查詢
  static didGetMaintListExt(itype, userId, deptId, searchStatus, searchCaseType, searchSubject, searchCustNo, searchSerial) {
    var urlStr = "${kCMHostPath}FunctionName=MaintList&UserID=$userId&DeptID=$deptId";
    if (itype == 1) {
      if (searchStatus != null && searchStatus.length > 0) {
        urlStr += "&SearchStatus=$searchStatus";
      }
      if (searchCaseType != null && searchCaseType.length > 0) {
        urlStr += "&SearchCaseType=$searchCaseType";
      }
      if (searchSubject != null && searchSubject.length > 0) {
        urlStr += "&SearchSubject=$searchSubject";
      }
      if (searchCustNo != null && searchCustNo.length > 0) {
        urlStr += "&SearchCustNO=$searchCustNo";
      }
      if (searchSerial != null && searchSerial.length > 0) {
        urlStr += "&SearchSerial=$searchSerial";
      }
    }
    return urlStr;
  }
  ///取得個人案件詳情
  static getMaintCase(userId, caseId) {
    return "${kCMHostPath}FunctionName=MaintCase&UserID=$userId&CaseID=$caseId";
  }
  ///送出個人案件狀態
  static didMaint(userId, caseId, newStatus, newAData) {
    var str = "${kCMHostPath}FunctionName=Maint&UserID=$userId&CaseID=$caseId&newStatus=$newStatus&newAData=$newAData";
    return str;
  }
  ///部門關閉caselist
  static getDeptCloseList(userId, deptId) {
    return "${kCMHostPath}FunctionName=DeptCloseList&UserID=$userId&DeptID=$deptId";
  }
  ///部門case詳情資料
  static getDeptCaseDetail(userId, caseId) {
    var str = "${kCMHostPath}FunctionName=DPMaintCase&UserID=$userId&CaseID=$caseId";
    return str;
  }
  ///部門關閉case多筆
  static didDeptClose(userId, caseId) {
    var str = "${kCMHostPath}FunctionName=DeptClose&UserID=$userId&CaseID=$caseId";
    return str;
  }
  ///file list
  static getFileList(userId) {
    return "${kCMHostPath}FunctionName=FileList&UserID=$userId";
  }
  ///file case
  static getFileCase(userId, caseId) {
    return "${kCMHostPath}FunctionName=FileCase&UserID=$userId&CaseID=$caseId";
  }
  ///案件歸檔執行
  static didFile(userId, caseId) {
    var str = "${kCMHostPath}FunctionName=File&UserID=$userId&CaseID=$caseId";
    return str;
  }
  ///取得可選case狀態
  static getCaseType() {
    return "${kCMHostPath}FunctionName=CaseTypeSelect";
  }
  ///單位條件查詢case
  static didGetDPMaintList(iType, userId, searchFunit, searchStatus, searchCaseType, searchSubject, searchCustNo, searchSerial, searchPuser,) {
    var urlStr = "${kCMHostPath}FunctionName=DPMaintList&UserID=$userId&SearchFUnit=$searchFunit";
    if (iType == 1) {
      if (searchStatus != null && searchStatus.length > 0) {
        urlStr += "&SearchStatus=$searchStatus";
      }
      if (searchCaseType != null && searchCaseType.length > 0) {
        urlStr += "&SearchCaseType=$searchCaseType";
      }
      if (searchSubject != null && searchSubject.length > 0) {
        urlStr += "&SearchSubject=$searchSubject";
      }
      if (searchCustNo != null && searchCustNo.length > 0) {
        urlStr += "&SearchCustNO=$searchCustNo";
      }
      if (searchSerial != null && searchSerial.length > 0) {
        urlStr += "&SearchSerial=$searchSerial";
      }
      if (searchPuser != null && searchPuser.length > 0) {
        urlStr += "&SearchPuser=$searchPuser";
      }
    }
    return urlStr;
  }
  ///業務ok
  static toSalesOk(userId, caseId, toSales) {
    return "${kCMHostPath}FunctionName=ToSalesOk&UserID=$userId&CaseID=$caseId&ToSales=$toSales";
  }
  ///單位部門回覆
  static assignDPMaint(userId, caseId, pdeptId, puserId, newStatus, newAData) {
    var str = "${kCMHostPath}FunctionName=DPMaint&UserID=$userId&CaseID=$caseId&PDeptID=$pdeptId&PUserID=$puserId&NewStatus=$newStatus&NewAData=$newAData";
    return str;
  }
  ///取得使用者案件筆數
  static getUserCaseType(account) {
    return "${kCMHostPath}FunctionName=GetUserCaseCount&account=$account";
  }
  ///部門結案詳情
  static getDeptCloseCase(userId, caseId) {
    return "${kCMHostPath}FunctionName=DeptCloseCase&UserID=$userId&CaseID=$caseId";
  }
  ///取得案件部門統計分析列表
  static getAnalizeCaseList(searchYear, searchMonth) {
    return "${kCMHostPath}FunctionName=GetDeptCaseCount&SearchYear=$searchYear&SearchMonth=$searchMonth";
  }


  ///-------------------- snr api -------------------- ///
  ///取得snr設定檔
  static getQueryConfigureAPI() {
    var aesUri = AesUtils.aes128Encrypt("${kSNRHostName}SNRProcess?FunctionName=QueryConfigure");
    var appendUrl = aesDomain + aesUri;
    return appendUrl;
  }
  ///小ping資料
  static getPingSNR(str) {
    String paraType = "";
    int type = 0;
    switch (type) {
      case 0: {
          paraType = "CustCode";
        }
        break;
      case 1: {
          paraType = "Telephone";
        }
        break;
      case 2: {
          paraType = "Address";
        }
        break;
      case 3: {
          paraType = "CMMAC";
        }
        break;
      default: {}
        break;

    }
    var aesUri = AesUtils.aes128Encrypt("$kSNRHostPingName/SNRping.php?Action=getSNR&$paraType=$str");
    var appendUrl = aesDomain + aesUri;
    return appendUrl;
  }
  ///大ping-cpe
  static getCPEDataAPI(cmts, cmmac) {
    var aesUri = AesUtils.aes128Encrypt("${kSNRHostPingName}SNRping.php?Action=getCPE&CMTS=$cmts&CMMAC=$cmmac");
    var appendUrl = aesDomain + aesUri;
    return appendUrl;
  }
  ///大ping-flap
  static getFLAPDataAPI(cmts, cmmac) {
    var aesUri = AesUtils.aes128Encrypt("${kSNRHostPingName}SNRping.php?Action=getFLAP&CMTS=$cmts&CMMAC=$cmmac");
    var appendUrl = aesDomain + aesUri;
    return appendUrl;
  }
  ///大ping-清除flap
  static clearFLAPDataAPI(cmts, cmmac) {
    var aesUri = AesUtils.aes128Encrypt("${kSNRHostPingName}SNRping.php?Action=ClearFLAP&CMTS=$cmts&CMMAC=$cmmac");
    var appendUrl = aesDomain + aesUri;
    return appendUrl;
  }
  ///操作維修紀錄
  static getHipassLogDataAPI(custNo) {
    var aesUri = AesUtils.aes128Encrypt("${kSNRHostName}SNRProcess?FunctionName=query_hilowpass_log&custNo=$custNo");
    var appendUrl = aesDomain + aesUri;
    return appendUrl;
  }
  ///清除維修記錄
  static delReportLog(senderId, senderName, logIdList, custId, from) {
    var logidStr = "";
    var i = 0;
    for (var str in logIdList) {
      if (str.contains("XXXXX")) {
        if (logidStr != "") {
          if (i < 1) {
            logidStr += ",XXXXX";
          }
        }
        else {
          if (i < 1) {
            logidStr += "XXXXX";
          }
        }
        i += 1;
      }
      else {
        if (logidStr == "") {
          logidStr = str;
        }
        else {
          logidStr = "$logidStr,$str";
        }
      }
    }
    var aesUri = AesUtils.aes128Encrypt("${kSNRHostName}SNRProcess?FunctionName=DeleteReportLog&SenderID=$senderId&SenderName=$senderName&LogID=$logidStr&CustCD=$custId&From=$from");
    var appendUrl = aesDomain + aesUri;
    return appendUrl;
  }
  ///操作維修紀錄-添加log
  static addDescriptionAPI(custId, inputText, senderId, senderName, from) {
    var aesUri = AesUtils.aes128Encrypt("${kSNRHostName}SNRProcess?FunctionName=AddReportLog&SenderID=$senderId&SenderName=$senderName&InputText=$inputText&CustCD=$custId&From=$from");
    var appendUrl = aesDomain + aesUri;
    return appendUrl;
  }
  ///信號log
  static getSignalLog(custId) {
    var aesUri = AesUtils.aes128Encrypt("${kSNRHostName}SNRProcess?FunctionName=QuerySignalLog&CustCD=$custId");
    var appendUrl = aesDomain + aesUri;
    return appendUrl;
  }

}