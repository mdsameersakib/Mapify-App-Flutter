import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapify/screens/entity_form.dart';

class EntityList extends StatefulWidget {
  const EntityList({super.key});

  @override
  _EntityListState createState() => _EntityListState();
}

class _EntityListState extends State<EntityList> {
  List<dynamic> entities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEntities();
  }

  Future<void> fetchEntities() async {
    const String apiUrl = 'https://labs.anontech.info/cse489/t3/api.php';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          entities = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load entities');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> deleteEntity(int id) async {
    const String apiUrl = 'https://labs.anontech.info/cse489/t3/api.php';
    try {
      final response = await http.delete(Uri.parse('$apiUrl?id=$id'));

      if (response.statusCode == 200) {
        if (response.body.contains('invalid_request')) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Authentication Required"),
              content: const Text(
                  "Server does not allow deletion without proper authentication."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        } else {
          setState(() {
            entities.removeWhere((entity) => entity['id'] == id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Entity deleted successfully!')),
          );
        }
      } else {
        throw Exception('Failed to delete entity');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entity List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EntityForm(),
                ),
              ).then((value) => fetchEntities());
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : entities.isEmpty
              ? const Center(child: Text('No entities found'))
              : ListView.builder(
                  itemCount: entities.length,
                  itemBuilder: (context, index) {
                    final entity = entities[index];
                    return ListTile(
                      leading:
                          entity['image'] != null && entity['image'].isNotEmpty
                              ? Image.network(
                                  'https://labs.anontech.info/cse489/t3/${entity['image']}',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 50,
                                    height: 50,
                                    alignment: Alignment.center,
                                    color: Colors.grey[300],
                                    child: const Text(
                                      'Image Error',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.center,
                                  color: Colors.grey[300],
                                  child: const Text(
                                    'No Image',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black54),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                      title: Text(entity['title']),
                      subtitle:
                          Text('Lat: ${entity['lat']}, Lon: ${entity['lon']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EntityForm(entity: entity),
                                ),
                              ).then((value) => fetchEntities());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteEntity(entity['id']),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
