

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/categoryviewmodel.dart';
import '../models/categorynews.dart';

class categorypage extends StatefulWidget {
  const categorypage({super.key});

  @override
  State<categorypage> createState() => _categorypageState();
}

class _categorypageState extends State<categorypage> {
  String category = 'general';
  late catviewmod catview = catviewmod();

  List<String> categorieslist = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology'
  ];

  late Future<categorynews> newsFuture;

  void _updateNewsFuture() {
    newsFuture = catview.fetchcategory(category: category);
  }

  @override
  void initState() {
    super.initState();
    //_fetchAndSetSources();
    _updateNewsFuture();
  }

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Categories',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text('.',style: TextStyle(color: Colors.deepPurple,fontSize: 28,fontWeight: FontWeight.bold),)
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Explore Topics',
              style: GoogleFonts.playfair(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: categorieslist.length,
              itemBuilder: (context, index) {
                bool isSelected = categorieslist[index] == category;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        category = categorieslist[index];
                        _updateNewsFuture();
                      });


                    }
                    ,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? Colors.grey[800]! : Colors.grey[300]!,
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: Colors.grey[800]!.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          categorieslist[index][0].toUpperCase() +
                              categorieslist[index].substring(1),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${category[0].toUpperCase()}${category.substring(1)} News',
              style: GoogleFonts.playfair(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<categorynews>(
              future: newsFuture , //catview.fetchcategory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitChasingDots(
                      color: Colors.deepPurple,
                      size: 50,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                        SizedBox(height: 16),
                        Text(
                          'Failed to load news',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles == null ||
                    snapshot.data!.articles!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.article_outlined, size: 60, color: Colors.grey[400]),
                        SizedBox(height: 16),
                        Text(
                          'No news available',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: snapshot.data!.articles!.length,
                  itemBuilder: (context, index) {
                    var article = snapshot.data!.articles![index];

                    String timeAgo = 'Recently';
                    try {
                      if (article.publishedAt != null) {
                        DateTime publishedDate = DateTime.parse(article.publishedAt!);
                        timeAgo = _getTimeAgo(publishedDate);
                      }
                    } catch (e) {
                      timeAgo = 'Recently';
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: article.urlToImage ?? '',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: SpinKitCircle(
                                        color: Colors.deepPurple,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 50,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          article.source?.name ?? 'Unknown',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        timeAgo,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    article.title ?? 'No Title',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.raleway(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    article.description ?? 'No description available',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      height: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline_rounded,
                                        size: 16,
                                        color: Colors.grey[500],
                                      ),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          article.author ?? 'Unknown Author',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
