import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/weather_data.dart';

class WeatherService {
  bool isLoading = false;

  Future<double?> getWeather(String city) async {
    print('before');

    isLoading = true;
    final response = await http.post(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=4bc4b7a72e95887bf2f0215090d49479&units=metric'));
    print('after: $response');

    isLoading = false;

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final weather = WeatherData.fromJson(jsonDecode(response.body));
      print(weather.main.temp);
      return weather.main.temp;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('not working');
    }
  }
}
