import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_foyer_demo/database/database.dart';
import 'package:flutter_foyer_demo/models/device_settings_model.dart.dart';
import 'package:flutter_foyer_demo/provider/profile_provider.dart';
import 'package:flutter_foyer_demo/screens/profiledisplay_screen.dart';
import 'package:intl/intl.dart';

class ProfileSetupScreen extends ConsumerWidget {
  ProfileSetupScreen(
      {super.key, required this.latitude, required this.longitude});

  TextEditingController activitiesController = TextEditingController();
  final dbHelper = DatabaseHelper();
  final double latitude;
  final double longitude;
  TextEditingController placeNameController = TextEditingController();

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: placeNameController,
              decoration: const InputDecoration(labelText: 'Profile Name'),
            ),
            TextField(
              controller: activitiesController,
              decoration: const InputDecoration(labelText: 'Custome Note'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                String profileName = placeNameController.text.trim();
                List<String> customeNote = activitiesController.text.split(',');

                bool isCustomeNoteValid = true;
                for (String note in customeNote) {
                  if (note.trim().isEmpty) {
                    isCustomeNoteValid = false;
                    break;
                  }
                }
                if (profileName.isNotEmpty && isCustomeNoteValid) {
                  PlaceProfile profile = PlaceProfile(
                    profileName: profileName,
                    latitude: latitude,
                    longitude: longitude,
                    customeNote: customeNote,
                    createdTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(DateTime.now()),
                  );

                  final dbHelper = DatabaseHelper();
                  bool isDuplicate = await dbHelper.isProfileDuplicate(profile);
                  if (!isDuplicate) {
                    try {
                      await dbHelper.insertProfile(profile);

                      final profileProviderDuplicateChecker =
                          ref.read(profileProvider.notifier);
                      profileProviderDuplicateChecker.addProfile(profile);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileDisplayScreen(),
                        ),
                      );
                    } catch (e) {
                      print('Error inserting profile into the database: $e');

                      _showErrorDialog(context,
                          'An error occurred while saving the profile.');
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Duplicate Profile'),
                          content: const Text(
                              'A profile with the same coordinates already exists.\nplease use different location to create new profile'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  _showErrorDialog(context, 'Please fill in all the fields.');
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
