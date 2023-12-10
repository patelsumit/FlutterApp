import 'package:flutterapp/models/category_model.dart';
import 'package:flutterapp/repository/news_repository.dart';

import '../models/news_headlines_model.dart';

class NewsViewModel {
  final _api = NewsRepository();
  Future<NewsHeadlinesModel> fetchHeadlinesNews(String name) async {
    final response = await _api.fetchHeadlinesNews(name);
    return response;
  }

  Future<CategoryModel> fetchCategories(String category) async {
    final response = await _api.fetchCategories(category);
    return response;
  }
}