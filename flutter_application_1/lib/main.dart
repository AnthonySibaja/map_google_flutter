import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Marker> _ontapMarkers = [];

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _ontapMarkers.clear();
      for (final location in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(location.name),
          position: LatLng(location.lat, location.lng),
          infoWindow: InfoWindow(
            title: location.name,
            snippet: location.address,
          ),
        );
        _ontapMarkers.add(marker);
      }
    });
  }

  final LatLng position = LatLng(37.422, -122.084);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Office Locations'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: position, zoom: 12),
          markers: Set<Marker>.of(_ontapMarkers),
          onTap: (argument) {
            Marker(
              markerId: MarkerId('marker'),
              position: argument,
              infoWindow: InfoWindow(title: 'Marker Title'),
            );
          },
        ),
      ),
    );
  }
}
