import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/moviemodel.dart';

class MovieProvider with ChangeNotifier {
  bool _error = false;
  bool _loaded = true;

  List<MovieModel> _movies = [
    //dummy data
    MovieModel(
      name: 'Shaadi Mein Zaroor Aana',
      imageuri:
          'https://m.media-amazon.com/images/M/MV5BODFkMDRjMWQtNDllMC00NjMwLWFlYzQtMWY5YWFkM2Y1NzhlXkEyXkFqcGdeQXVyNzkxOTEyMjI@._V1_.jpg',
      imdbstar: '7.6',
      genre: ["Drama", "Romance"],
    ),
    MovieModel(
      name: 'Shaadisthan',
      imageuri:
          'https://m.media-amazon.com/images/M/MV5BMWZjMjk5YWQtNTFkOC00N2VmLWJlOTUtYWU5MGFkZTc1MGI5XkEyXkFqcGdeQXVyMTI1NDAzMzM0._V1_.jpg',
      imdbstar: '5.8',
      genre: ["Drama", "Musical"],
    ),
    MovieModel(
      name: 'Band Baaja Baaraat',
      imageuri:
          'https://m.media-amazon.com/images/M/MV5BOTJlMWYwYTYtZGFjYS00NmY1LWFhNGEtNWMxZTVmZGY1N2MwXkEyXkFqcGdeQXVyNTkzNDQ4ODc@._V1_.jpg',
      imdbstar: '7.2',
      genre: ["Comedy", "Drama", "Romance"],
    ),
    MovieModel(
      name: 'Shaadi Mubarak',
      imageuri:
          'https://m.media-amazon.com/images/M/MV5BZTQ3MWQzNTgtNTAwZC00MmVhLThlZTktZmYwM2M2NzIyMTAxXkEyXkFqcGdeQXVyNTgxODY5ODI@._V1_.jpg',
      imdbstar: '7.1',
      genre: ["Comedy", "Romance"],
    ),
  ];

  List<MovieModel> get items {
    return [..._movies];
  }

  bool get loadState {
    return _loaded;
  }

  bool get errorState {
    return _error;
  }

  void errorStateHandler(bool val) {
    _error = val;
    notifyListeners();
  }

  void loadStateHandler(bool val) {
    _loaded = val;
    notifyListeners();
  }

  Future<void> getData(String query) async {
    var url = Uri.parse('http://breezing.me:8000/getinfo');
    try {
      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'movie': query,
          }));
      final decodedResp = json.decode(resp.body);
      List<MovieModel> retrived = [];
      decodedResp.forEach((elem) {
        List genres = elem['moviedata']['genre'];
        int till = 3;
        if (genres.length <= 3) {
          till = genres.length;
        }
        retrived.add(MovieModel(
          name: elem['name'],
          imageuri: elem['imgurl'],
          imdbstar: elem['moviedata']['imdb'],
          genre: genres.sublist(0, till),
        ));
      });
      _movies = retrived;
      notifyListeners();
    } catch (e) {
      // print(e);
      throw 'error occured';
    }
  }
}
