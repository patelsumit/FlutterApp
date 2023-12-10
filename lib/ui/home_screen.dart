import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterapp/models/news_headlines_model.dart';
import 'package:flutterapp/ui/category_screen.dart';
import 'package:flutterapp/ui/news_detail_screen.dart';
import 'package:flutterapp/viewmodel/news_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/category_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, independent, reuters, cnn, alJazeera }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategoryScreen()));
          },
          icon: Image.asset(
            'images/category_icon.png',
            height: 30,
            width: 30,
          ),
        ),
        title: Text(
          'News Headlines',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (FilterList item) {
                if (FilterList.bbcNews.name == item.name) {
                  name = 'bbc-news';
                }
                if (FilterList.aryNews.name == item.name) {
                  name = 'ary-news';
                }
                setState(() {
                  selectedMenu = item;
                });
              },
              itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
                    const PopupMenuItem<FilterList>(
                      value: FilterList.bbcNews,
                      child: Text('BBC News'),
                    ),
                    const PopupMenuItem<FilterList>(
                      value: FilterList.aryNews,
                      child: Text('Ary News'),
                    )
                  ])
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsHeadlinesModel>(
              future: newsViewModel.fetchHeadlinesNews(name),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitFadingCube(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsDetailScreen(
                                        newsImage:
                                            'https://www.pakainfo.com/wp-content/uploads/2021/09/image-url-for-testing.jpg',
                                        newsTitle: snapshot
                                            .data!.articles![index].title
                                            .toString(),
                                        date: snapshot
                                            .data!.articles![index].publishedAt
                                            .toString(),
                                        author: snapshot
                                            .data!.articles![index].author
                                            .toString(),
                                        description: snapshot
                                            .data!.articles![index].description
                                            .toString(),
                                        source: snapshot
                                            .data!.articles![index].source!.name
                                            .toString())));
                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.6,
                                  width: width * .9,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: height * .02),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://www.pakainfo.com/wp-content/uploads/2021/09/image-url-for-testing.jpg',
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        child: spinKit,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 15,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.all(15),
                                      height: height * .22,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.7,
                                            child: Text(
                                              snapshot
                                                  .data!.articles![index].title
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: width * 0.7,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data!
                                                      .articles![index]
                                                      .source!
                                                      .name
                                                      .toString(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  format.format(dateTime),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoryModel>(
              future: newsViewModel.fetchCategories('General'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitFadingCube(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://www.pakainfo.com/wp-content/uploads/2021/09/image-url-for-testing.jpg',
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width * .3,
                                  placeholder: (context, url) => Container(
                                    child: const Center(
                                      child: SpinKitFadingCube(
                                        size: 50,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                height: height * .18,
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  children: [
                                    Text(
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700)),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            snapshot.data!.articles![index]
                                                .source!.name
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w700)),
                                        /*Text(format.format(dateTime),
                                                style : GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500
                                                )
                                            ),*/
                                      ],
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ),
                        );
                      });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

const spinKit = SpinKitFadingCircle(
  color: Colors.amber,
);
