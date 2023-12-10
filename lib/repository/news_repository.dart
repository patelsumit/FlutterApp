import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/category_model.dart';
import 'package:flutterapp/models/news_headlines_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  final apiKey = 'd86dfca72ad14e1488b4d42ef5d906da';
  final sources = 'bbc-news';

  // Constructing the URL
  final baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<NewsHeadlinesModel> fetchHeadlinesNews(String sources) async {
    final encodedApiKey = Uri.encodeComponent(apiKey);
    final encodedSources = Uri.encodeComponent(sources);
    final url =
        Uri.parse('$baseUrl?sources=$encodedSources&apiKey=$encodedApiKey');
    final response = await http.get(url);
    if (kDebugMode) {
      print(url);
      print(response);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print(body);
      return NewsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoryModel> fetchCategories(String category) async {
    final encodedApiKey = Uri.encodeComponent(apiKey);
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=$category&apiKey=$encodedApiKey');
    final response = await http.get(url);
    if (kDebugMode) {
      print(url);
      print(response);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print(body);
      return CategoryModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
