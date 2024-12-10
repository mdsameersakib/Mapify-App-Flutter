import 'package:flutter/material.dart';

class LocationMarker extends StatelessWidget {
  final Map<String, dynamic> location;

  const LocationMarker({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(location['title']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  location['image'],
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 40);
                  },
                ),
                const SizedBox(height: 10),
                Text('Latitude: ${location['lat']}'),
                Text('Longitude: ${location['lon']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      child: const Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 40,
      ),
    );
  }
}
