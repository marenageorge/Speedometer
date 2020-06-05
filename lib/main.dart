// import 'dart:async';
import 'dart:async';

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
  Stopwatch stopwatch10 = new Stopwatch();
  Stopwatch stopwatch30 = new Stopwatch();
  String time30 = "";
  String time10 = "";
  double newSpeed = 0.0;
  var boolenTime30 = 0;
  var boolenTime10 = 0;
  double start =0.0;
  double end=30.0;

  @override
  void initState() {
    super.initState();

    _geolocator = Geolocator();
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

    _geolocator.getPositionStream(locationOptions).listen((Position position) {
      _position = position;
    });
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _position = newPosition;
        newSpeed = (_position.speed * 3.6).floorToDouble();

        stringSpeed = newSpeed.toString();

        if (newSpeed < start || newSpeed > end) {
          stopwatch30.reset();
          stopwatch10.reset();
          if (newSpeed < start) {
            boolenTime30 = 1;
            boolenTime10 = 0;
          } else if (newSpeed > end) {
            boolenTime30 = 0;
            boolenTime10 = 1;
          }
        } else if (newSpeed >= start && newSpeed <= end) {
          if (newSpeed == end) {
            boolenTime30 = 0;
            boolenTime10 = 1;
          }
          if (newSpeed == start) {
            boolenTime30 = 1;
            boolenTime10 = 0;
          }
          if (boolenTime30 == 1 && stopwatch30.isRunning != true) {
            boolenTime30 = 0;
            boolenTime10 = 0;
            stopwatch30.start();
            stopwatch10.stop();
            stopwatch10.reset();
          } else if (boolenTime10 == 1 && stopwatch10.isRunning != true) {
            boolenTime30 = 0;
            boolenTime10 = 0;
            stopwatch10.start();
            stopwatch30.stop();
            stopwatch30.reset();
          }
        }
      });

      setState(() {
        time30 = (stopwatch30.elapsedMilliseconds * 0.001).toStringAsFixed(0);
        time10 = (stopwatch10.elapsedMilliseconds * 0.001).toStringAsFixed(0);
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
        body: new OrientationBuilder(builder: (context, orientation) {
          // return Center(

          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      GridView.count(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 1 : 1,

                        // MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 1,
                        shrinkWrap: true,
                        // physics: new NeverScrollableScrollPhysics()
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 0),
                        child: Text(
                          'Current Speed',
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        '${stringSpeed != null ? stringSpeed : '0'}', // hna el geolocation
                        style: TextStyle(
                            fontSize: 70,
                            color: Colors.green,
                            fontFamily: 'DSDigital'),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "kmh", // hna el geolocation
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 80, left: 0),
                        child: Text(
                          "From 10 to 30",
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        '${time30 != null ? time30 : '0'}', // hna el geolocation
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.green,
                            fontFamily: 'DSDigital'),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Seconds", // hna el geolocation
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 60, left: 0),
                        child: Text(
                          "From 30 to 10",
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        '${time10 != null ? time10 : '0'}', // hna el geolocation
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.green,
                            fontFamily: 'DSDigital'),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Seconds", // hna el geolocation
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              ]));
        }));
  }
}
