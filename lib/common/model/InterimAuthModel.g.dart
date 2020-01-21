// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'InterimAuthModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterimAuthModel _$InterimAuthModelFromJson(Map<String, dynamic> json) {
  return InterimAuthModel(
    json['ID'] as String,
    json['CustCode'] as String,
    json['AuthType'] as String,
    json['DeptCode'] as String,
    json['AcceptAccNo'] as String,
    json['AcceptName'] as String,
    json['CreateBy'] as String,
    json['CreateOn'] as String,
    json['UpdateBy'] as String,
    json['UpdateOn'] as String,
  );
}

Map<String, dynamic> _$InterimAuthModelToJson(InterimAuthModel instance) =>
    <String, dynamic>{
      'ID': instance.ID,
      'CustCode': instance.CustCode,
      'AuthType': instance.AuthType,
      'DeptCode': instance.DeptCode,
      'AcceptAccNo': instance.AcceptAccNo,
      'AcceptName': instance.AcceptName,
      'CreateBy': instance.CreateBy,
      'CreateOn': instance.CreateOn,
      'UpdateBy': instance.UpdateBy,
      'UpdateOn': instance.UpdateOn,
    };
