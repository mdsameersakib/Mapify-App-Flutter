import 'package:flutter/material.dart';
import 'package:mapify/screens/entity_list.dart';
import 'package:mapify/screens/mapscreen.dart';

void main() {
  runApp(const MapifyApp());
}

class MapifyApp extends StatelessWidget {
  const MapifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapify',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget currentScreen = const MapScreen();

  void switchScreen(Widget screen) {
    setState(() {
      currentScreen = screen;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapify'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Mapify Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Map View'),
              onTap: () => switchScreen(const MapScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Entity List'),
              onTap: () => switchScreen(const EntityList()),
            ),
          ],
        ),
      ),
      body: currentScreen,
    );
  }
}
