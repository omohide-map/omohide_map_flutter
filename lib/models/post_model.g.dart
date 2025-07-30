// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      text: json['text'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'text': instance.text,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'image_urls': instance.imageUrls,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$CreatePostRequestImpl _$$CreatePostRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePostRequestImpl(
      text: json['text'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CreatePostRequestImplToJson(
        _$CreatePostRequestImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'images': instance.images,
    };
