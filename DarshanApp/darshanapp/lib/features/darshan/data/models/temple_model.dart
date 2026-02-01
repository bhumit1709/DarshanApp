import '../../domain/entities/temple.dart';

class TempleModel extends Temple {
  const TempleModel({
    required super.id,
    required super.name,
    required super.location,
    required super.description,
    required super.imageAsset,
    required super.videoUrl,
    required super.isLive,
    required super.darshanTime,
  });

  factory TempleModel.fromJson(Map<String, dynamic> json) {
    return TempleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      imageAsset: json['image_asset'] as String,
      videoUrl: json['video_url'] as String,
      isLive: json['is_live'] as bool,
      darshanTime: json['darshan_time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'image_asset': imageAsset,
      'video_url': videoUrl,
      'is_live': isLive,
      'darshan_time': darshanTime,
    };
  }
}
