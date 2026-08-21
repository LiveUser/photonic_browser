import 'package:flutter/material.dart';
import 'package:photonic_browser/search_results.dart';
import 'package:photonic_browser/widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.photosDirectory,
  });
  final String photosDirectory;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchQuery = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchBar(
                      controller: searchQuery,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SearchResultsBrowser(
                      photosDirectory: widget.photosDirectory, 
                      searchQuery: searchQuery.text,
                    ),
                  ));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  color: Colors.deepPurple,
                  child: Text(
                    "Search",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}