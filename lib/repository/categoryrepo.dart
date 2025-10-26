import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/models/categorynews.dart';


class categoryrepo {
  final String api;
  //final String category;

  categoryrepo({required this.api});

  Future<categorynews> fetchcategory(String category) async {
    // 1. Define the base URL without any query parameters
  String baseUrl = 'https://newsapi.org/v2/everything?q=';

    // 2. Build the final URL safely using Uri


    // 3. Make the HTTP GET request
    final response = await http.get(Uri.parse('$baseUrl$category&apiKey=$api'));

    // 4. Check the response and parse the JSON
    if (response.statusCode == 200) {
      return categorynews.fromJson(jsonDecode(response.body));
    } else {
      // Provide a more informative error message
      throw Exception('Failed to load news sources: ${response.body}');
    }
  }
}
