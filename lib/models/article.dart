class Article {
  final String title;
  final String? description;
  final String url;
  final String? image;
  final String? content;
  final String source;
  final String publishedAt;

  Article({
    required this.title,
    this.description,
    required this.url,
    this.image,
    this.content,
    required this.source,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    dynamic sourceData = json['source'];

    String sourceName;

    if (sourceData is Map) {
      sourceName = sourceData['name'] ?? 'Unknown';
    } else if (sourceData is String) {
      sourceName = sourceData;
    } else {
      sourceName = 'Unknown';
    }

    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'],
      url: json['url'],
      image: json['urlToImage'],
      content: json['content'],
      source: sourceName,
      publishedAt: json['publishedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "url": url,
    "urlToImage": image,
    "content": content,
    "source": source,
    "publishedAt": publishedAt,
  };
}