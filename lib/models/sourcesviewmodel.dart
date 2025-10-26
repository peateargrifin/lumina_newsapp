import 'package:news/repository/sourcesrepo.dart';

import 'sources.dart';

class sourcesviewmodel{
  var country;

  late final rep = sourcesrepo(api: 'your api key', country: country);

//  var country;


  Future<sourcesources> fetchsources()async{
    final response = await rep.fetchsources();
    return response;
  }
  sourcesviewmodel({required this.country});





}