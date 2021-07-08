import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/movieprovider.dart';
import './screens/dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieProvider(),
      child: MaterialApp(
        title: 'Asssignment1',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.grey,
          fontFamily: 'Oswald',
        ),
        home: Dashboard(),
      ),
    );
  }
}
