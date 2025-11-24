import 'package:get/get.dart';
import '../models/article.dart';
import '../services/news_service.dart';

class NewsController extends GetxController {
  RxList<Article> articles = <Article>[].obs;
  final loading = false.obs;
  final category = 'technology'.obs;

  @override
  void onInit() {
    fetchArticles();
    super.onInit();
  }

  void changeCategory(String cat) {
    category.value = cat;
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    loading.value = true;
    final result = await NewsService.fetchHeadlines(category.value);
    articles.value = result;
    loading.value = false;
  }
}