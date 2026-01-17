import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

class AvailableMaps extends StatefulWidget {
  const AvailableMaps({super.key});

  @override
  State<AvailableMaps> createState() => _AvailableMapsState();
}

class _AvailableMapsState extends State<AvailableMaps> {
  List<AvailableMap> maps = [];

  @override
  void initState() {
    _getMaps();
    super.initState();
  }

  void _getMaps() async {
    final availableMap = await MapLauncher.installedMaps;
    setState(() {
      maps = availableMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('可用地图')),
      body: ListView.builder(
        itemCount: maps.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(maps[index].mapName),
            onTap: () {
              maps[index].showMarker(
                coords: Coords(37.7749, -122.4194),
                title: 'San Francisco',
              );
            },
          );
        },
      ),
    );
  }
}
