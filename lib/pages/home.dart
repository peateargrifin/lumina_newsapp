

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/extensions/mediaquery.dart';
import 'package:news/models/categorynews.dart';
import 'package:news/models/categoryviewmodel.dart';
import 'package:news/models/newsheadlines.dart';
import 'package:news/models/sources.dart';
import 'package:news/models/sourcesviewmodel.dart';

import '../models/newsviewmod.dart';
import 'categorypage.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  newsviewmod newsview = newsviewmod(country: 'us');
  sourcesviewmodel sources = sourcesviewmodel(country: 'us');
  catviewmod catview = catviewmod();

  List<Sources> sourcelist = [];
  String? sourceid;
  String selectedSourceName = 'All Sources';


  late Future<newsheadlines> newsFuture;
  late Future<categorynews> catnewsFuture;

  Future<void> _fetchAndSetSources() async {
    try {

      final sourcesData = await sources.fetchsources();

      setState(() {

        sourcelist =
            sourcesData.sources?.where((s) => s.id != null).toList() ?? [];

      });
    } catch (e) {

      print('Failed to load sources: $e');
      setState(() {

      });
    }
  }

  void _updateNewsFuture() {
   newsFuture= newsview.fetchnews(source: sourceid);

  }

  void updatecatgennews(){
    catnewsFuture= catview.fetchcategory(category: 'general');
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetSources();
    _updateNewsFuture();
    updatecatgennews();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (category)=> categorypage()));
          },
          icon: Icon(Icons.menu_rounded, color: Colors.black87, size: 28),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Lumira',
              style: GoogleFonts.playfairDisplay(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Text(
              '.',
              style: GoogleFonts.playfairDisplay(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String?>(
            icon: Icon(Icons.filter_list_alt, color: Colors.black87, size: 26),
            onSelected: (String? selectedId) {
              setState(() {

                sourceid = selectedId;


                _updateNewsFuture();
              });
              _updateNewsFuture();
            },
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<String?>> items = [];
              items.add(
                PopupMenuItem<String?>(
                  value: null,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: sourceid == null
                              ? Colors.deepPurple
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'All Sources',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: sourceid == null
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: sourceid == null
                                    ? Colors.deepPurple
                                    : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Show all available news',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );

              //items.add(PopupMenuDivider(height: 8));


              for (var source in sourcelist) {
                items.add(
                  PopupMenuItem<String?>(
                    value: source.id,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: sourceid == source.id
                                ? Colors.deepPurple
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                source.name ?? 'Unknown Source',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: sourceid == source.id
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: sourceid == source.id
                                      ? Colors.deepPurple
                                      : Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Lang: ${source.language?.toUpperCase() ?? 'N/A'}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return items;
            },


          ),
          SizedBox(width: 10),

        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              'Breaking News',
              style: GoogleFonts.playfair(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            width: context.width,
            height: context.height * 0.45,
            child: FutureBuilder<newsheadlines>(
              future: newsFuture,//newsview.fetchnews(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitChasingDots(
                      color: Colors.deepPurple,
                      size: 50,
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      String timeAgo = 'Recently';
                      try {
                        if (snapshot.data!.articles![index].publishedAt !=
                            null) {
                          DateTime publishedDate = DateTime.parse(
                            snapshot.data!.articles![index].publishedAt!,
                          );
                          timeAgo = _getTimeAgo(publishedDate);
                        }
                      } catch (e) {
                        timeAgo = 'Recently';
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          width: context.width * 0.85,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: context.width * 0.85,
                                  height: context.height * 0.45,
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!
                                        .articles![index]
                                        .urlToImage
                                        .toString(),
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
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 50,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              Container(
                                width: context.width * 0.85,
                                height: context.height * 0.45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8),
                                    ],
                                    stops: [0.5, 1.0],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                right: 15,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    snapshot
                                            .data!
                                            .articles![index]
                                            .source
                                            ?.name ??
                                        'News',
                                    style: GoogleFonts.raleway(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title ??
                                            'No Title',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.raleway(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          height: 1.3,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_rounded,
                                            size: 14,
                                            color: Colors.white70,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            timeAgo,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            snapshot
                                                    .data!
                                                    .articles![index]
                                                    .author ??
                                                'Unknown Author',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: Colors.white60,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Latest News',
                  style: GoogleFonts.playfair(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: 10),


          //here latest

          FutureBuilder<categorynews>(
            future: catnewsFuture , //catview.fetchcategory(),
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
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
