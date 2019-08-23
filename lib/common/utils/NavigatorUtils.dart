
import 'package:case_manager/page/HomePage.dart';
import 'package:case_manager/page/LoginPage.dart';
import 'package:case_manager/page/analyze/analyzePage.dart';
import 'package:case_manager/page/assign/AssignDetailPage.dart';
import 'package:case_manager/page/assign/AssignPage.dart';
import 'package:case_manager/page/assign/DPAssignDetailPage.dart';
import 'package:case_manager/page/assign/DPAssignPage.dart';
import 'package:case_manager/page/file/FileDetailPage.dart';
import 'package:case_manager/page/file/FilePage.dart';
import 'package:case_manager/page/fixInsert/fixInsertPage.dart';
import 'package:case_manager/page/maint/DPMaintDetailPage.dart';
import 'package:case_manager/page/maint/DPMaintPage.dart';
import 'package:case_manager/page/maint/MaintDetailPage.dart';
import 'package:case_manager/page/maint/MaintPage.dart';
import 'package:case_manager/page/sales/SalesMaintDetailPage.dart';
import 'package:case_manager/page/sales/SalesMaintPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
///導航欄
///Date: 2019-06-04
///
class NavigatorUtils {
  ///替換
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  ///切換無參數頁面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
  ///一般跳轉頁面
  static NavigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(context, new CupertinoPageRoute(builder: (context) => widget));
  }
  ///跳轉至頁面並移除上一頁
  static NavigatorRemoveRouter(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(context, new CupertinoPageRoute(builder: (context) => widget), null);
  }
  ///登入頁
  static goLogin(BuildContext context, {isAutoLogin}) {
    if (isAutoLogin != null  && isAutoLogin != false) {
      NavigatorRouter(context, LoginPage(isAutoLogin: isAutoLogin));
    }
    else {
      Navigator.pushReplacementNamed(context, LoginPage.sName);
    }
  }
  ///跳回登入頁
  static goTopLogin(BuildContext context) {
    NavigatorRemoveRouter(context, LoginPage());
  }
  ///首頁
  ///pushReplacementNamed需要由main.dart做導航
  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.sName);
  }
  ///個人案件處理列表頁面
  static goMaint(BuildContext context, String accName) {
    NavigatorRouter(context, MaintPage(accName: accName));
  }
  ///個人案件處理詳情頁面
  static goMaintDetail(BuildContext context, String custCode, String userId, String deptId, String caseId, String statusName) {
    NavigatorRouter(context, MaintDetailPage(custCode: custCode, userId: userId, deptId: deptId, caseId: caseId, statusName: statusName));
  }
  ///指派個人列表頁面
  static goAssign(BuildContext context, String accName) {
    NavigatorRouter(context, AssignPage(accName: accName));
  }
  ///指派個人案件處理詳情頁面
  static goAssignEmplDetail(BuildContext context, String custCode, String userId, String deptId, String caseId, String statusName) {
    NavigatorRouter(context, AssignDetailPage(custCode: custCode, userId: userId, deptId: deptId, caseId: caseId, statusName: statusName));
  }
  ///單位案件處理列表頁面
  static goDPMaint(BuildContext context, String accName) {
    NavigatorRouter(context, DPMaintPage(accName: accName));
  }
  ///單位案件處理詳情頁面
  static goDPMaintDetail(BuildContext context, String custCode, String userId, String deptId, String caseId, String statusName, String accName) {
    NavigatorRouter(context, DPMaintDetailPage(custCode: custCode, userId: userId, deptId: deptId, caseId: caseId, statusName: statusName, accName: accName,));
  }
  ///單位指派列表頁面
  static goDPAssign(BuildContext context, String accName) {
    NavigatorRouter(context, DPAssignPage(accName: accName));
  }
  ///單位指派詳情頁面
  static goDPAssignDetail(BuildContext context, String custCode, String userId, String deptId, String caseId, String statusName) {
    NavigatorRouter(context, DPAssignDetailPage(custCode: custCode, userId: userId, deptId: deptId, caseId: caseId, statusName: statusName));
  }
  ///案件歸檔/單位結案列表
  static goFileList(BuildContext context, String accName) {
    NavigatorRouter(context, FilePage(accName: accName));
  }
  ///案件歸檔詳情
  static goFileDettail(BuildContext context, String custCode, String userId, String deptId, String caseId, String statusName, String fromFunc) {
     NavigatorRouter(context, FileDetailPage(custCode: custCode, userId: userId, deptId: deptId, caseId: caseId, statusName: statusName, fromFunc: fromFunc,));
  }
  ///裝機問題通知列表
  static goSalesMaint(BuildContext context, String accName) {
     NavigatorRouter(context, SalesMaintPage(accName: accName));
  }
  ///裝機問題通知詳情
  static goSalesMaintDetail(BuildContext context, String custCode, String userId, String deptId, String caseId, String statusName) {
    NavigatorRouter(context, SalesMaintDetailPage(custCode: custCode, userId: userId, deptId: deptId, caseId: caseId, statusName: statusName));
  }
  ///維修插單列表
  static goFixInsert(BuildContext context, String accName) {
    NavigatorRouter(context, FixInsertPage(accName: accName));
  }
  ///維修插單詳情
  static goFixInsertDetail(BuildContext context, String custCode, String userId, String deptId, String caseId, String statusName) {
    NavigatorRouter(context, SalesMaintDetailPage(custCode: custCode, userId: userId, deptId: deptId, caseId: caseId, statusName: statusName));
  }
  ///案件分析列表
  static goAnalyze(BuildContext context) {
    NavigatorRouter(context, AnalyzePage());
  }
  
}