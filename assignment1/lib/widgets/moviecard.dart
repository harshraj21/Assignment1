import 'package:flutter/material.dart';

// import '../providers/movieprovider.dart';
import '../models/moviemodel.dart';

class MovieCard extends StatelessWidget {
  final List<MovieModel> movies;
  final bool isPortraid;
  final double height;
  final double width;
  MovieCard({
    required this.movies,
    required this.isPortraid,
    required this.height,
    required this.width,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (_, idx) {
        String genre = movies[idx].genre.join(' | ');
        double rating = double.parse(movies[idx].imdbstar);
        return Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Image(
                      image: NetworkImage(
                        movies[idx].imageuri,
                      ),
                      fit: BoxFit.cover,
                      width: isPortraid ? width * 0.3 : width * 0.23,
                      height: isPortraid ? height * 0.15 : height * 0.25,
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.41,
                          child: Text(
                            movies[idx].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.fade,
                            // softWrap: true,
                          ),
                        ),
                        Container(
                          width: width * 0.41,
                          child: Text(
                            genre,
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Container(
                          width: isPortraid ? width * 0.18 : width * 0.09,
                          height: isPortraid ? height * 0.02 : height * 0.045,
                          child: Text(
                            '${movies[idx].imdbstar} IMDB',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            color: rating > 6.9 ? Colors.green : Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
          ],
        );
      },
      itemCount: movies.length,
    );
  }
}
