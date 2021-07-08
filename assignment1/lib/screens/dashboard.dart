import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/moviemodel.dart';
import '../providers/movieprovider.dart';
import '../widgets/moviecard.dart';
import '../widgets/searchbar.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late double height, width;
  late TextEditingController textEditingController;
  late var isPortraid;

  void snackBar(String msg, int seconds) {
    try {
      final snackBar = SnackBar(
        duration: Duration(seconds: seconds),
        content: Text(
          msg,
          style: TextStyle(fontSize: 15),
          // textAlign: TextAlign.center,
        ),
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        snackBar,
      );
    } catch (e) {
      print('snackbar context not found');
    }
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController.text = '';
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration.zero, () {
      try {
        snackBar('Loaded dummy data', 2);
      } catch (e) {
        print(e);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviehandle = Provider.of<MovieProvider>(context);
    final List<MovieModel> movies = moviehandle.items;
    var mq = MediaQuery.of(context);
    isPortraid = mq.orientation == Orientation.portrait;
    height = mq.size.height;
    width = mq.size.width;
    bool _loaded = moviehandle.loadState;
    bool _error = moviehandle.errorState;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Home'),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: height * 0.04,
            left: width * 0.07,
            right: width * 0.07,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              _loaded
                  ? SearchBar(
                      textEditingController: textEditingController,
                    )
                  : Container(),
              SizedBox(
                height: height * 0.03,
              ),
              _loaded
                  ? Container(
                      height: isPortraid ? height * 0.8 : height * 0.69,
                      width: double.infinity,
                      child: movies.length > 0
                          ? MovieCard(
                              movies: movies,
                              isPortraid: isPortraid,
                              height: height,
                              width: width,
                            )
                          : _error
                              ? Center(
                                  child: Text(
                                    'Error occured',
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'No content available',
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                    )
                  : Container(
                      height: height * 0.8,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
