import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  static const apiKey = '5e300eddd00b4226beffc1430a459180';

  static Future<List<Article>> fetchHeadlines(String category) async {
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=india%20$category&apiKey=$apiKey');

    final res = await http.get(url);
    final data = jsonDecode(res.body);

    List list = data['articles'];
    return list.map((e) => Article.fromJson(e)).toList();
  }
}