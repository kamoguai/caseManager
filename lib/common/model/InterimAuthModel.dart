import 'package:json_annotation/json_annotation.dart';

part 'InterimAuthModel.g.dart';

///
///二次授權model
///Date: 2020-01-16
@JsonSerializable()
class InterimAuthModel {
  String ID;
  String CustCode;
  String AuthType;
  String DeptCode;
  String AcceptAccNo;
  String AcceptName;
  String CreateBy;
  String CreateOn;
  String UpdateBy;
  String UpdateOn;

  InterimAuthModel(
    this.ID,
    this.CustCode,
    this.AuthType,
    this.DeptCode,
    this.AcceptAccNo,
    this.AcceptName,
    this.CreateBy,
    this.CreateOn,
    this.UpdateBy,
    this.UpdateOn,
  );
   // 反序列化
   factory InterimAuthModel.fromJson(Map<String, dynamic> json) => _$InterimAuthModelFromJson(json);
   // 序列化
   Map<String, dynamic> toJson() => _$InterimAuthModelToJson(this);

   // 命名構造函數
   InterimAuthModel.empty();
}