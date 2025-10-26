import 'package:news/repository/categoryrepo.dart';

import 'categorynews.dart';
//46094d62da3c46e5a39393b871a0a903
class catviewmod{
  //var category;

  late final rep = categoryrepo(api: '46094d62da3c46e5a39393b871a0a903' );

  //var source;

//  var country;


  Future<categorynews> fetchcategory( {required String category})async{
    final response = await rep.fetchcategory(category);
    return response;
  }
  catviewmod();





}