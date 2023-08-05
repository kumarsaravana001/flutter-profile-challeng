import 'package:flutter/material.dart';
import 'package:flutter_foyer_demo/database/database.dart';
import 'package:flutter_foyer_demo/models/device_settings_model.dart.dart';

class DatabaseDisplayPage extends StatefulWidget {
  const DatabaseDisplayPage({super.key});

  @override
  _DatabaseDisplayPageState createState() => _DatabaseDisplayPageState();
}

class _DatabaseDisplayPageState extends State<DatabaseDisplayPage> {
  List<PlaceProfile> profiles = [];

  Future<void> _deleteProfile(PlaceProfile profile) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteProfile(profile.id!);
    retrieveData();
  }

  @override
  void initState() {
    super.initState();
    retrieveData();
  }

  Future<void> retrieveData() async {
    final dbHelper = DatabaseHelper();
    List<PlaceProfile> retrievedProfiles = await dbHelper.retrieveProfiles();
    setState(() {
      profiles = retrievedProfiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Display'),
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return ListTile(
            title: Text(
              profile.profileName,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Latitude: ${profile.latitude}'),
                Text('Longitude: ${profile.longitude}'),
                Text(
                  'Favorite Activities: ${profile.customeNote.join(', ')}',
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteProfile(profile),
            ),
          );
        },
      ),
    );
  }
}
