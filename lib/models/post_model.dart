import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    String? id,
    required String text,
    required double latitude,
    required double longitude,
    @Default([]) List<String> images,
    @Default([]) List<String> imageUrls,
    required DateTime createdAt,
    String? userId,
    String? userName,
    String? userAvatar,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
}

@freezed
class CreatePostRequest with _$CreatePostRequest {
  const factory CreatePostRequest({
    required String text,
    required double latitude,
    required double longitude,
    @Default([]) List<String> images,
  }) = _CreatePostRequest;

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) => _$CreatePostRequestFromJson(json);
}
