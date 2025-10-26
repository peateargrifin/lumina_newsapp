import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/newsheadlines.dart';

class newsrepo {
  var api;
  var country;

  Future<newsheadlines> fetchnews({String? source}) async {
    // String? api;
    if (source == null) {
      String baseurl = 'https://newsapi.org/v2/top-headlines?country=';
      final response = await http.get(
        Uri.parse('$baseurl$country&apiKey=$api'),
      );

      if (response.statusCode == 200) {
        return newsheadlines.fromJson(jsonDecode(response.body));
      }
      throw Exception(e);


    } else {
      String baseurl = 'https://newsapi.org/v2/top-headlines?sources';

      //https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=46094d62da3c46e5a39393b871a0a903
      //
      // final Uri url = Uri.parse(baseurl).replace(
      //   queryParameters: {
      //     'sources': source,
      //     'apiKey': api, // Use the 'api' variable from your class
      //   },
      // );

      final response = await http.get( Uri.parse('$baseurl=$source&apiKey=$api'));
      if (response.statusCode == 200) {
        return newsheadlines.fromJson(jsonDecode(response.body));
      }
      throw Exception(e);




    }
  }

  newsrepo({required this.api, required this.country});
}
