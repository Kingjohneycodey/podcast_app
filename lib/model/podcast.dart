class Podcast {
  final String title;
  final String audio;
  final String image;
  final String id;

  const Podcast({
    required this.title,
    required this.audio,
    required this.image,
    required this.id,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
    title: json['title_original'],
    audio: json['audio'],
    image: json['image'],
    id: json['id'],
  );

  Map<String, dynamic> toJson() => {
    'title_original': title,
    'audio': audio,
    'image': image,
    'id': id,
  };
}
