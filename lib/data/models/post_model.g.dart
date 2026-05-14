// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
  id: json['id'] as String,
  authorId: json['authorId'] as String,
  authorName: json['authorName'] as String,
  authorPhotoUrl: json['authorPhotoUrl'] as String?,
  content: json['content'] as String,
  imageUrl: json['imageUrl'] as String?,
  createdAt: PostModel._timestampToDate(json['createdAt']),
  updatedAt: PostModel._timestampToDate(json['updatedAt']),
);

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
  'id': instance.id,
  'authorId': instance.authorId,
  'authorName': instance.authorName,
  'authorPhotoUrl': instance.authorPhotoUrl,
  'content': instance.content,
  'imageUrl': instance.imageUrl,
  'createdAt': PostModel._dateToTimestamp(instance.createdAt),
  'updatedAt': PostModel._dateToTimestamp(instance.updatedAt),
};
