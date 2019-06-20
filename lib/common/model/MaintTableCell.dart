import 'package:json_annotation/json_annotation.dart';

part 'MaintTableCell.g.dart';

///
///案件列表table cell
///Date; 2019-06-11
///
@JsonSerializable()
class MaintTableCell {

  String CaseID; 
  String CaseNO; 
  String DataTime; 
  String DataTime2;
  String CloseDataTime; 
  String CloseDataTime2; 
  String Subject; 
  String CaseTypeName; 
  String Area; 
  String CustNO; 
  String CustName; 
  String StatusName; 
  String FUnitName; 
  String PDeptName; 
  String PUserName; 
  String PushTime; 
  String TakeTime; 
  String PushTimeDiff; 
  String TakeTimeDiff; 
  String PushTimeDiffStatus; 
  String TakeTimeDiffStatus; 
  String CreaterName; 

  MaintTableCell(
    this.CaseID, 
    this.CaseNO, 
    this.DataTime, 
    this.DataTime2,
    this.CloseDataTime, 
    this.CloseDataTime2, 
    this.Subject, 
    this.CaseTypeName, 
    this.Area, 
    this.CustNO, 
    this.CustName, 
    this.StatusName, 
    this.FUnitName, 
    this.PDeptName, 
    this.PUserName, 
    this.PushTime, 
    this.TakeTime, 
    this.PushTimeDiff, 
    this.TakeTimeDiff, 
    this.PushTimeDiffStatus, 
    this.TakeTimeDiffStatus, 
    this.CreaterName,
  );  
   // 反序列化
   factory MaintTableCell.fromJson(Map<String, dynamic> json) => _$MaintTableCellFromJson(json);
   // 序列化
   Map<String, dynamic> toJson() => _$MaintTableCellToJson(this);

   // 命名構造函數
   MaintTableCell.empty();
}