import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/location_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Map<String, dynamic>> locations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    try {
      final response = await http
          .get(Uri.parse('https://labs.anontech.info/cse489/t3/api.php'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data');

        setState(() {
          locations = List<Map<String, dynamic>>.from(data.map((item) => {
                "id": item['id'],
                "title": item['title'],
                "lat": double.parse(item['lat'].toString()),
                "lon": double.parse(item['lon'].toString()),
                "image":
                    'https://labs.anontech.info/cse489/t3/${item['image']}',
              }));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapify'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                center: locations.isNotEmpty
                    ? LatLng(locations.first['lat'], locations.first['lon'])
                    : LatLng(23.6850, 90.3563),
                zoom: 7.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: locations.map((location) {
                    return Marker(
                      point: LatLng(location['lat'], location['lon']),
                      width: 80,
                      height: 80,
                      builder: (context) => LocationMarker(location: location),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}
