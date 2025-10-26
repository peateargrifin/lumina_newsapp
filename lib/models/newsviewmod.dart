import 'package:news/repository/newsrepo.dart';

import 'newsheadlines.dart';
//46094d62da3c46e5a39393b871a0a903
class newsviewmod{
  var country;

  late final rep = newsrepo(api: '46094d62da3c46e5a39393b871a0a903', country: country);

  var source;

//  var country;


  Future<newsheadlines> fetchnews({String? source})async{
    final response = await rep.fetchnews(source: source);
    return response;
  }
  newsviewmod({required this.country});





}