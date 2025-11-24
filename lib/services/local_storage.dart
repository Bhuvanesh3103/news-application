import 'package:get_storage/get_storage.dart';
import '../models/article.dart';

typedef ArticleMap = Map<String, dynamic>;

class LocalStorage {
  static final box = GetStorage();

  static List<Article> getSavedArticles() {
    final list = box.read('saved') ?? [];
    return (list as List).map((e) => Article.fromJson(e)).toList();
  }

  static void saveArticle(Article article) {
    final saved = getSavedArticles();
    if (!saved.any((e) => e.url == article.url)) {
      saved.add(article);
      box.write('saved', saved.map((e) => e.toJson()).toList());
    }
  }

  static void removeArticle(String url) {
    final saved = getSavedArticles();
    saved.removeWhere((e) => e.url == url);
    box.write('saved', saved.map((e) => e.toJson()).toList());
  }
}