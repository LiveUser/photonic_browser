import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photonic_browser/functions.dart';
import 'package:photonic_browser/location_browser.dart';
import 'package:photonic_browser/search_screen.dart';
import 'package:photonic_browser/widgets.dart';
import 'dart:io';


class SearchResultsBrowser extends StatefulWidget {
  const SearchResultsBrowser({
    super.key,
    required this.photosDirectory,
    required this.searchQuery,
  });
  final String photosDirectory;
  final String searchQuery;
  @override
  State<SearchResultsBrowser> createState() => _SearchResultsBrowserState();
}

class _SearchResultsBrowserState extends State<SearchResultsBrowser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: FutureBuilder(
          future: getMatchingItems(MatchingItemsSettings(
            photosDirectory: Directory(widget.photosDirectory), 
            searchQuery: widget.searchQuery,
          )), 
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    snapshot.error.toString(),
                  ),
                  GestureDetector(
                    onTap: ()async{
                      setState(() {
                        
                      });
                    },
                    child: Container(
                      color: Colors.deepPurple,
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Retry",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }else if(snapshot.connectionState == ConnectionState.done){
              return Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: widgetizeImages(snapshot.data as List<PhotonicItem>),
                ),
              );
            }else{
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}