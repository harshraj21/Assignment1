import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/movieprovider.dart';
// import '../models/moviemodel.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController textEditingController;
  SearchBar({
    required this.textEditingController,
  });
  @override
  Widget build(BuildContext context) {
    final moviehandle = Provider.of<MovieProvider>(context, listen: false);
    return TextField(
      // autofocus: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black12,
        )),
        prefix: SizedBox(
          width: 20,
        ),
        suffixIcon: InkWell(
            onTap: () {
              try {
                moviehandle.loadStateHandler(false);
                moviehandle.errorStateHandler(false);
                moviehandle.getData(textEditingController.text).then((value) {
                  moviehandle.loadStateHandler(true);
                  moviehandle.errorStateHandler(false);
                }, onError: (e) {
                  moviehandle.loadStateHandler(true);
                  moviehandle.errorStateHandler(true);
                });
              } catch (e) {
                moviehandle.loadStateHandler(true);
                moviehandle.errorStateHandler(true);
              }
            },
            child: Icon(Icons.search)),
        filled: true,
        fillColor: Colors.white10,
        hintText: 'Search for movies',
      ),
      controller: textEditingController,
      onSubmitted: (val) {
        try {
          moviehandle.loadStateHandler(false);
          moviehandle.errorStateHandler(false);
          moviehandle.getData(textEditingController.text).then((value) {
            moviehandle.loadStateHandler(true);
            moviehandle.errorStateHandler(false);
          }, onError: (e) {
            moviehandle.loadStateHandler(true);
            moviehandle.errorStateHandler(true);
          });
        } catch (e) {
          moviehandle.loadStateHandler(true);
          moviehandle.errorStateHandler(true);
        }
      },
    );
  }
}
