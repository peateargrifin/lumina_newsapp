import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sources.dart';

class sourcesrepo {
  final String api;
  final String country;

  sourcesrepo({required this.api, required this.country});

  Future<sourcesources> fetchsources() async {
    // 1. Define the base URL without any query parameters
    const String baseUrl = 'https://newsapi.org/v2/top-headlines/sources';

    // 2. Build the final URL safely using Uri
    final Uri url = Uri.parse(baseUrl).replace(
      queryParameters: {
        'country': country, // Use the 'country' variable from your class
        'apiKey': api,      // Use the 'api' variable from your class
      },
    );

    // 3. Make the HTTP GET request
    final response = await http.get(url);

    // 4. Check the response and parse the JSON
    if (response.statusCode == 200) {
      return sourcesources.fromJson(jsonDecode(response.body));
    } else {
      // Provide a more informative error message
      throw Exception('Failed to load news sources: ${response.body}');
    }
  }
}
