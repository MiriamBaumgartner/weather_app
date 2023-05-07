import 'package:flutter/material.dart';
import 'package:weather_app/settings_screen.dart';
import 'package:weather_app/style.dart';
import 'package:weather_app/weather_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService weatherService = WeatherService();
  double? temperature;
  String city = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: _buildAppbar(context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          _buildSearchbar(),
          const SizedBox(height: 50),
          if (weatherService.isLoading)
            CircularProgressIndicator()
          else
            _buildWeatherWidget()
        ],
      ),
    );
  }

  Widget _buildSearchbar() {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 6,
      child: TextField(
        onChanged: (value) {
          city = value;
          print(city);
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () async {
              setState(() {
                weatherService.isLoading = true;
              });
              temperature = await weatherService.getWeather(city);
              setState(() {});
            },
            icon: Icon(
              Icons.search,
              color: Colors.pink,
            ),
          ),
          label: const Text(
            'Search',
            style: TextStyle(fontSize: 22),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    var textStyle = const TextStyle(fontSize: 24, color: Colors.white);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.pink[500],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Icon(
              Icons.sunny,
              size: 50,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  city,
                  style: textStyle,
                ),
                Text(
                  '$temperature degrees',
                  style: textStyle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text('Cool Weather App'),
      actions: [
        IconButton(
          onPressed: () => onSettingsPressed(context),
          icon: const Icon(Icons.self_improvement_outlined),
        ),
      ],
    );
  }

  onSettingsPressed(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: ((context) => const SettingsScreen())));
  }

  void onSearch(String value) {}
}
