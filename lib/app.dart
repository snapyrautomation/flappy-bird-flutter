import 'package:flappyBird/utils/bird_pos.dart';
import 'package:flappyBird/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    identify("bonedog", {
      'name': "brian",
      'email': "bone@alumni.brown.edu",
      'mobilePhone': "+12155886024"
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => BirdPos(),
        child: HomeScreen(),
      ),
    );
  }
}

Future<void> identify(String userId, Map traits) async {
  const platform = const MethodChannel('snapyr.com/data');
  await platform.invokeMethod('identify', {'userId': userId, 'traits': traits});
}
