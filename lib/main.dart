// import 'dart:async';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:location/location.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Speedometer',
        home: MyHomePage(title: 'Speedometer'),
        debugShowCheckedModeBanner: false);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  Geolocator _geolocator;
  Position _position;
  String stringSpeed = "";
   final Distance distance = new Distance();
  Position initPosition;
  Position pf;
  var time10;
  var time30;
  var speed1;

  @override
  void initState() {
    super.initState();

    _geolocator = Geolocator();
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

     _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
 
      _position = position;
    });
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {

        _position = newPosition;
        stringSpeed = (_position.speed * 3.6).toStringAsFixed(4);
        if (_position.speed == 10 && speed1 <= _position.speed) {
          initPosition = _position;
        }
        if (_position.speed == 10 && speed1 > _position.speed) {
          pf = _position;
             int meter = distance(
        new LatLng(_position.latitude,_position.longitude),
        new LatLng(initPosition.latitude,initPosition.longitude)
        );
        // 20 depends on (initial speed - final speed) as we assumed that initial speed 30 and final 10 ===> (30-10)=20
          time10 = meter /(0.5*(20));
        }
        if (_position.speed == 30 && speed1 >= _position.speed) {
          initPosition = _position;
        }
        if (_position.speed == 30 && speed1 < _position.speed) {
          pf = _position;
          //var dis = pf - p0;
                int meter = distance(
        new LatLng(_position.latitude,_position.longitude),
        new LatLng(initPosition.longitude,initPosition.longitude)
        );
        // 40 depends on (initial speed + final speed) as we assumed that initial speed 10 and final 30 ===> (10+30)=40
          time30 = meter /(0.5*40);
        }
        speed1 = _position.speed;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  Widget build(BuildContext context) {
    updateLocation();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: Text(
                'Current Speed',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Text(
              '${stringSpeed != null ? stringSpeed : '0'}', // hna el geolocation
              style: TextStyle(
                  fontSize: 70, color: Colors.green, fontFamily: 'DSDigital'),
            ),
            Text(
              "kmh", // hna el geolocation
              style: TextStyle(fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 80,
              ),
              child: Text(
                "From 10 to 30",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Text(
              '${time30 != null ? time30.toString() : '0'}', // hna el geolocation
              style: TextStyle(
                  fontSize: 50, color: Colors.green, fontFamily: 'DSDigital'),
            ),
            Text(
              "Seconds", // hna el geolocation
              style: TextStyle(fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 60,
              ),
              child: Text(
                "From 30 to 10",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Text(
               '${time10 != null ? time10.toString() : '0'}', // hna el geolocation
              style: TextStyle(
                  fontSize: 50, color: Colors.green, fontFamily: 'DSDigital'),
            ),
            Text(
              "Seconds", // hna el geolocation
              style: TextStyle(fontSize: 30),
            )
          
          ],
        ),
      ),
    );
  }
}
