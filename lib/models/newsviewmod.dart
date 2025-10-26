import 'package:news/repository/newsrepo.dart';

import 'newsheadlines.dart';

class newsviewmod{
  var country;

  late final rep = newsrepo(api: 'your api key', country: country);

  var source;

//  var country;


  Future<newsheadlines> fetchnews({String? source})async{
    final response = await rep.fetchnews(source: source);
    return response;
  }
  newsviewmod({required this.country});





}