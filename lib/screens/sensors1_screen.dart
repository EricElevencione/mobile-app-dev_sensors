import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Sensors1Screen extends StatefulWidget {
  const Sensors1Screen({super.key});

  @override
  State<Sensors1Screen> createState() => _Sensors1ScreenState();
}

class _Sensors1ScreenState extends State<Sensors1Screen> {
  // sensor data variables
  GyroscopeEvent? _gyroscopeEvent;
  // User Accelerometer describes the acceleration without gravity
  UserAccelerometerEvent? _accelerometerEvent;
  AccelerometerEvent? _accelerometerEvent2;
  MagnetometerEvent? _magnetometerEvent;
  BarometerEvent? _barometerEvent;
  Position? _currentPosition;

  // A stream is needed to listen to the sensor data
  // and update the UI accordingly
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  // Interval to update the sensor data
  // Different types of intervals are available, for games, normal, and UI
  // The normal interval is used for most applications
  Duration sensorInterval = SensorInterval.normalInterval;

  // initialize the sensors
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Add the sensor data streams to the list of subscriptions
    // User Accelerometer
    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _accelerometerEvent = event;
          });
        },
        onError: (error) {
          // Handle error if needed
          print('Error: $error');
        },
        onDone: () {
          // Handle stream completion if needed
          print('Stream completed');
        },
      ),
    );

    // Accelerometer
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerEvent2 = event;
          });
        },
        onError: (error) {
          // Handle error if needed
          print('Error: $error');
        },
        onDone: () {
          // Handle stream completion if needed
          print('Stream completed');
        },
      ),
    );

    // Magnetometer
    _streamSubscriptions.add(
      magnetometerEventStream(samplingPeriod: sensorInterval).listen(
        (MagnetometerEvent event) {
          setState(() {
            _magnetometerEvent = event;
          });
        },
        onError: (error) {
          // Handle error if needed
          print('Error: $error');
        },
        onDone: () {
          // Handle stream completion if needed
          print('Stream completed');
        },
      ),
    );

    // Barometer
    _streamSubscriptions.add(
      barometerEventStream(samplingPeriod: sensorInterval).listen(
        (BarometerEvent event) {
          setState(() {
            _barometerEvent = event;
          });
        },
        onError: (error) {
          // Handle error if needed
          print('Error: $error');
        },
        onDone: () {
          // Handle stream completion if needed
          print('Stream completed');
        },
      ),
    );

    // Gyropscope
    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeEvent = event;
          });
        },
        onError: (error) {
          // Handle error if needed
          print('Error: $error');
        },
        onDone: () {
          // Handle stream completion if needed
          print('Stream completed');
        },
      ),
    );
  }

  // Retrieve the GPS coordinates
  // This function checks if the location services are enabled and if the permissions are granted
  // If not, it returns an error message
  // If everything is fine, it returns the current position
  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return an error message
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, return an error message
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, return an error message
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can get the location
    Position curPos = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = curPos;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // Cancel all the subscriptions to the sensor data streams
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sensors Demo')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('GPS Location'),
            _currentPosition == null
                ? CircularProgressIndicator()
                : Text(
                  'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}',
                  style: const TextStyle(fontSize: 16),
                ),

            SizedBox(height: 10),

            const Text('User Accelerometer Sensor Data'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('X: ${_accelerometerEvent?.x.toStringAsFixed(2)}'),
                Text('Y: ${_accelerometerEvent?.y.toStringAsFixed(2)}'),
                Text('Z: ${_accelerometerEvent?.z.toStringAsFixed(2)}'),
              ],
            ),

            SizedBox(height: 10),

            const Text('Accelerometer Sensor Data'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('X: ${_accelerometerEvent2?.x.toStringAsFixed(2)}'),
                Text('Y: ${_accelerometerEvent2?.y.toStringAsFixed(2)}'),
                Text('Z: ${_accelerometerEvent2?.z.toStringAsFixed(2)}'),
              ],
            ),

            SizedBox(height: 10),

            const Text('Gyroscope Sensor Data'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('X: ${_gyroscopeEvent?.x.toStringAsFixed(2)}'),
                Text('Y: ${_gyroscopeEvent?.y.toStringAsFixed(2)}'),
                Text('Z: ${_gyroscopeEvent?.z.toStringAsFixed(2)}'),
              ],
            ),

            SizedBox(height: 10),

            const Text('Magnetometer Sensor Data'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('X: ${_magnetometerEvent?.x.toStringAsFixed(2)}'),
                Text('Y: ${_magnetometerEvent?.y.toStringAsFixed(2)}'),
                Text('Z: ${_magnetometerEvent?.z.toStringAsFixed(2)}'),
              ],
            ),

            SizedBox(height: 10),

            const Text('Barometer Sensor Data'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Pressure: ${_barometerEvent?.pressure.toStringAsFixed(2)}',
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add your onPressed code here!
          _determinePosition();
        },
        tooltip: 'Get GPS Location',
        child: const Icon(Icons.location_pin),
      ),
    );
  }
}
