import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';

const openweatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';
const apikey = '00c9322ac7962206444b5a42a034391e';

//https://api.openweathermap.org/data/2.5/weather?lat=19.207207207207208&lon=84.75386009948804&appid=00c9322ac7962206444b5a42a034391e
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentLatitude;
  var currentLongitude;
  var weathertype, description;
  var windspeed;
  var grndLevel, seaLevel, temp_min, temp_max;
  var timezone, placename, temperature, humidity, country;
  bool visibleContainer = true;

  Future getLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      permission = await Geolocator.checkPermission();

      // serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // if (!serviceEnabled) {
      //   return Future.error('Location services are disabled.');
      // }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      try {
        LocationPermission permission = await Geolocator.requestPermission();
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);
        print(position);
        setState(() {});
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
      } catch (e) {
        print(e);
      }
      await getDataFromJson();
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print(e);
    }
  }

  Future getDataFromJson() async {
    var client = http.Client();
    var url =
        '$openweatherMapURL?lat=${currentLatitude}&lon=${currentLongitude}&appid=$apikey';
    try {
      Response response = await client.get(Uri.parse(url));
      print(response.body);
      var values = jsonDecode(response.body);
      setState(() {
        if (values == null) {
          currentLatitude = 0;
          currentLongitude = 'Error';
          weathertype = 'Unable to get weather data';
          windspeed = '';
          timezone = '--';
          placename = '';
          temperature = 0;
          humidity = 0;
          country = '';
          return;
        }
        currentLatitude = values["coord"]["lat"];
        currentLongitude = values["coord"]["lon"];
        placename = values["name"];
        country = values["sys"]["country"];
        description = values["weather"][0]["description"];

        weathertype = values["weather"][0]["main"];
        seaLevel = values["main"]["sea_level"];
        grndLevel = values["main"]["grnd_level"];
        windspeed = values["wind"]["speed"];
        timezone = values["timezone"];

        temperature = values["main"]["temp"];
        temp_min = values["main"]["temp_min"];
        temp_max = values["main"]["temp_max"];
        humidity = values["main"]["humidity"];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/sky.webp"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Container(
                    //     width: size.width * 0.75,
                    //     child: TextField(
                    //       onChanged: (value) {},
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //       ),
                    //       textInputAction: TextInputAction.search,
                    //       onSubmitted: (value) {},
                    //       decoration: InputDecoration(
                    //         suffixIcon: Icon(
                    //           Icons.search,
                    //           color: Colors.white,
                    //         ),
                    //         hintText: "Search".toUpperCase(),
                    //         hintStyle: TextStyle(color: Colors.white),
                    //         border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(10),
                    //             borderSide: BorderSide(color: Colors.white)),
                    //         focusedBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(10),
                    //             borderSide: BorderSide(color: Colors.white)),
                    //         enabledBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(10),
                    //             borderSide: BorderSide(color: Colors.white)),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Align(
                      alignment: Alignment(0, 1.25),
                      child: SizedBox(
                        height: 10,
                        width: 10,
                        child: OverflowBox(
                          minWidth: 0,
                          minHeight: 0,
                          maxHeight: size.height / 3,
                          maxWidth: size.width,
                          child: Stack(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                width: double.infinity,
                                height: double.infinity,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${placename}'.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          DateFormat()
                                              .add_MMMMEEEEd()
                                              .format(DateTime.now()),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "$description",
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                if (temperature != null)
                                                  Text(
                                                    '${(temperature - 273.15).round().toString()}\u2103',
                                                    style: TextStyle(
                                                      fontSize: 45,
                                                      color: Colors.black45,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                if (temp_min != null)
                                                  Text(
                                                    'min: ${(temp_min - 275.15).round().toString()}\u2103',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black38,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                if (temp_max != null)
                                                  Text(
                                                    'max:${(temp_max - 272.15).round().toString()}\u2103',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black38,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  height: 120,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          "images/sticker.jpg"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Wind :${windspeed}m/s',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black38,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 250),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: double.infinity,
                        // decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //         image: AssetImage('images/scene.jpg'),
                        //         fit: BoxFit.cover)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Other Details',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Latitude: ${currentLatitude}',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black45,
                              ),
                            ),
                            Text(
                              'Longitude: ${currentLongitude}',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black45,
                              ),
                            ),
                            Text(
                              'SeaLevel: ${seaLevel}',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black45,
                              ),
                            ),
                            Text(
                              'GroundLevel: ${grndLevel}',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
