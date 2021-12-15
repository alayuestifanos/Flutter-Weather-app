import 'package:flutter/material.dart';
import 'package:weatherapp/screens/city_screen.dart';
import 'package:weatherapp/screens/loading_screen.dart';
import 'package:weatherapp/services/networking.dart';
import 'package:weatherapp/services/weather.dart';
import 'package:weatherapp/utilities/constants.dart';
class LocationScreen extends StatefulWidget {
  LocationScreen(this.locationWeather);
  final locationWeather;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  double temperature = 0;
  String weatherIcon = '';
  String weatherMessage = '';
  String cityName = '';
  int pressure = 0;
  int humidity = 0;
  double windSpeed = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather);
  }
  void updateUI(dynamic weatherData){
    setState(() {
      if(weatherData == null){
        temperature = 0;
        weatherIcon = "";
        weatherMessage = "Unable to get weather data";
        cityName = 'your location';
        humidity = 0;
        pressure = 0;
        windSpeed = 0;
        return ;
      }
      temperature = weatherData['main']['temp'];
      pressure =weatherData['main']['pressure'];
      humidity =weatherData['main']['humidity'];
      windSpeed =weatherData['wind']['speed'];
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      weatherMessage = weatherModel.getMessage(temperature.toInt());

      cityName = weatherData['name'];
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async{
                      var weatherData = await weatherModel.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async{
                     var typedName = await Navigator.push(context, MaterialPageRoute(builder: (context)=>CityScreen()));
                     if(typedName != null){
                       var weatherData = await weatherModel.getCityWeather(typedName);
                       updateUI(weatherData);
                     }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WeatherTerms(unit: "Hg",weatherTerm: "Pressure",value: pressure,),
                    SizedBox(width: 20,),
                    WeatherTerms(unit:"m/s",weatherTerm: "WindSpeed",value: windSpeed,),
                    SizedBox(width: 20,),
                    WeatherTerms(unit: "g/Kg",weatherTerm: "Humidity",value: humidity,),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${temperature.toStringAsFixed(1)}°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$weatherIcon',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $cityName",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherTerms extends StatelessWidget {
    WeatherTerms({required this.weatherTerm,required this.value,required this.unit});
    final String weatherTerm;
    final dynamic value;
    final String unit;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Text(weatherTerm,style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'ZenLoop'
          ),),
          SizedBox(height: 20,),
          Text('${value.runtimeType == double? value.toStringAsFixed(1):value} $unit',style: TextStyle(
            fontSize: 20
          ),)
        ],
      ),
    );
  }
}
