
import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';

void main(){
  runApp(const Myapp());
}
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData.dark(useMaterial3: true).copyWith(
        // appBarTheme: const AppBarTheme(color: Color.fromRGBO(26, 36, 46, 1.0))
      ),
      home: const WeatherScreen(),
    );
  }
}
