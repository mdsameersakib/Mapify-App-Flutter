import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../widgets/map_picker_screen.dart';

class EntityForm extends StatefulWidget {
  final Map<String, dynamic>? entity;

  const EntityForm({Key? key, this.entity}) : super(key: key);

  @override
  _EntityFormState createState() => _EntityFormState();
}

class _EntityFormState extends State<EntityForm> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String latitude = '';
  String longitude = '';
  File? imageFile;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.entity != null) {
      title = widget.entity!['title'];
      latitude = widget.entity!['lat'].toString();
      longitude = widget.entity!['lon'].toString();
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      final url = Uri.parse('https://labs.anontech.info/cse489/t3/api.php');
      if (widget.entity == null) {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {
            'title': title,
            'lat': latitude,
            'lon': longitude,
          },
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Entity created successfully!')),
          );
          Navigator.of(context).pop();
        } else {
          throw Exception('Failed to create entity: ${response.body}');
        }
      } else {
        final response = await http.put(
          url,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {
            'id': widget.entity!['id'].toString(),
            'title': title,
            'lat': latitude,
            'lon': longitude,
            'image': imageFile != null ? 'images/' : '',
          },
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Entity updated successfully!')),
          );
          Navigator.of(context).pop();
        } else {
          throw Exception('Failed to update entity: ${response.body}');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void openMapPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(
          initialLat: double.tryParse(latitude) ?? 23.6850,
          initialLon: double.tryParse(longitude) ?? 90.3563,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        latitude = result['lat'].toString();
        longitude = result['lon'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entity == null ? 'Add New Entity' : 'Edit Entity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                onChanged: (value) => title = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Latitude & Longitude',
                  hintText: '$latitude, $longitude',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: openMapPicker,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Select Image'),
              ),
              if (imageFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.file(
                    imageFile!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isSubmitting ? null : submitForm,
                child: Text(isSubmitting ? 'Submitting...' : 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
