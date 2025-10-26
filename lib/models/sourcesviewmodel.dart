import 'package:news/repository/sourcesrepo.dart';

import 'sources.dart';
//46094d62da3c46e5a39393b871a0a903
class sourcesviewmodel{
  var country;

  late final rep = sourcesrepo(api: '46094d62da3c46e5a39393b871a0a903', country: country);

//  var country;


  Future<sourcesources> fetchsources()async{
    final response = await rep.fetchsources();
    return response;
  }
  sourcesviewmodel({required this.country});





}