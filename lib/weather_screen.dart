import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Secrets.dart';
import 'additional_info.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;



class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String,dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async{

    try{

    String cityName = 'Bokaro';

   final res = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey')
     );

   final data = jsonDecode(res.body);

   if(data['cod']!= '200'){
     throw 'an unexpected error occurred';
   }
   return data;
     //temp =(data['list'][0]['main']['temp']);

    }catch(e){
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontSize: 24, ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body:FutureBuilder(
        future: weather,
        builder:(context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child:CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return  Center(child: Text(snapshot.error.toString()));
          }

          final data= snapshot.data!;

          final currentWeatherData = data['list'][0];

          final currentTemp =currentWeatherData['main']['temp'];

          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];

          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Card
              SizedBox(
                width: double.infinity,
                child: Card(
                  // color:const Color.fromRGBO(47, 50, 71, 1.0),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              '$currentTemp k',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Icon(
                              currentSky == 'Cloud' || currentSky == 'Rain' ? Icons.cloud : Icons.sunny,
                              size: 72,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              currentSky,
                              style:const  TextStyle(
                                fontSize: 24,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Hourly Forecast',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              //Weather forecast Cards

              const SizedBox(height: 8),
              //  SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       for(int i=0;i<10;i++)
              //       //--------------------------------------------Card 1 ---------------------------------------
              //       HourlyForecastItem(
              //         time: data['list'][i+1]['dt'].toString()  ,
              //         icon:data['list'][i+1]['weather'][0]['main']== 'Clouds' || data['list'][i+1]['weather'][0]['main'] == 'Rains' ?Icons.cloud: Icons.sunny,
              //         temperature: data['list'][i+1]['main']['temp'].toString(),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount:8 ,
                  scrollDirection: Axis.horizontal,
                  itemBuilder:(context,index){
                    final hourlyForecast = data['list'][index+1];
                    final hourlySky = data['list'][index+1]['weather'][0]['main'];
                    final hourlyTemp = hourlyForecast['main']['temp'].toString();
                    final time = DateTime.parse(hourlyForecast['dt_txt']);

                    return HourlyForecastItem(
                    time: DateFormat.j().format(time),
                        temperature: hourlyTemp,
                        icon:hourlySky == 'Clouds' || hourlySky == 'Rains' ?Icons.cloud: Icons.sunny);
                  },
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              //Additional information
              const Text('Additional Information',style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),

              const SizedBox(height: 8,),
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //--------------------------------------------Card 1 ---------------------------------------
                    AdditionalInfo(
                      icon: Icons.water_drop,
                      label:"Humidity" ,
                      value: currentHumidity.toString(),
                    ),
                    //----------------------------------------------Card 2 ----------------------------------------
                    AdditionalInfo(
                      icon: Icons.air,
                      label:"Wind Speed" ,
                      value: currentWindSpeed.toString() ,
                    ),
                    //-----------------------------------------Card 3--------------------------------------
                    AdditionalInfo(
                      icon: Icons.beach_access,
                      label:"Pressure" ,
                      value: currentPressure.toString(),
                    ),

                  ],
                ),
            ],
          ),
        );
        },
      ),
    );
  }
}



