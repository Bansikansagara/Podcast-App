/// Represents a single podcast episode with all its metadata.
class Episode {
  final String id;
  final String title;
  final String description;
  final String duration;
  final String date;
  final String audioUrl;
  final String coverUrl;

  Episode({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.date,
    required this.audioUrl,
    required this.coverUrl,
  });

  /// Factory constructor to create an [Episode] instance from a JSON map.
  /// Typically used when loading data from a local file or an API.
  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      date: json['date'],
      audioUrl: json['audioUrl'],
      coverUrl: json['coverUrl'],
    );
  }

  /// Converts the [Episode] instance back into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'date': date,
      'audioUrl': audioUrl,
      'coverUrl': coverUrl,
    };
  }
}
