import 'package:get/get.dart';
import '../models/article.dart';
import '../services/local_storage.dart';

class SavedController extends GetxController {
  RxList<Article> saved = <Article>[].obs;

  @override
  void onInit() {
    loadSaved();
    super.onInit();
  }

  void loadSaved() {
    saved.value = LocalStorage.getSavedArticles();
  }

  void toggleSave(Article article) {
    if (saved.any((e) => e.url == article.url)) {
      saved.removeWhere((e) => e.url == article.url);
      LocalStorage.removeArticle(article.url);
    } else {
      saved.add(article);
      LocalStorage.saveArticle(article);
    }
    saved.refresh();
  }

}