import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CityData extends StatefulWidget {
  var city;
  CityData({this.city});

  @override
  State<CityData> createState() => _CityDataState();
}

class _CityDataState extends State<CityData> {
  void fivecities() {
    List<String> cities = ['London', 'Jharkhand', 'Paris', 'Ranchi', 'Tokyo'];
    cities.forEach((element) {
      //send city name to api
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
