
class VideoModel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelTitle;
  final String publishDate;
  final int viewCount;
  final String videoUrl;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.publishDate,
    required this.viewCount,
    required this.videoUrl,
  });

  // From JSON (Deserialization)
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['snippet']['title'],
      description: json['snippet']['description'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      channelTitle: json['snippet']['channelTitle'],
      publishDate: json['snippet']['publishedAt'],
      viewCount: json['statistics']['viewCount'] != null
          ? int.parse(json['statistics']['viewCount'].toString())
          : 0,
      videoUrl: 'https://www.youtube.com/watch?v=${json['id']}',
    );
  }

  // To JSON (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'snippet': {
        'title': title,
        'description': description,
        'thumbnails': {'high': {'url': thumbnailUrl}},
        'channelTitle': channelTitle,
        'publishedAt': publishDate,
      },
      'statistics': {
        'viewCount': viewCount,
      },
    };
  }
}
