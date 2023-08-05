import 'package:flutter/material.dart';
import 'package:flutter_foyer_demo/database/database.dart';
import 'package:flutter_foyer_demo/models/profile_settings_model.dart';
import 'package:flutter_foyer_demo/provider/profile_provider.dart';
import 'package:flutter_foyer_demo/screens/locationinput_screen.dart';
import 'package:flutter_foyer_demo/screens/database_retrival.dart';
import 'package:flutter_foyer_demo/screens/profilesetting_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device_settings_model.dart.dart';

class ProfileDisplayScreen extends ConsumerWidget {
  Future<List<PlaceProfile>> _getProfilesFromDatabase() async {
    final dbHelper = DatabaseHelper();
    List<PlaceProfile> profiles = await dbHelper.retrieveProfiles();

    if (profiles.isEmpty) {
      return [];
    }

    profiles.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));

    return [profiles.first];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Profile Details'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DatabaseDisplayPage(),
                ),
              );
            },
            icon: const Icon(Icons.data_exploration_outlined),
          )
        ],
      ),
      body: profiles.isEmpty
          ? FutureBuilder<List<PlaceProfile>>(
              future: _getProfilesFromDatabase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text(
                    'No profile created\nCreate a new profile',
                    textAlign: TextAlign.center,
                  ));
                } else {
                  final lastProfile = snapshot.data!.last;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue[100],
                        ),
                        child: ListTile(
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Current User',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      'Profile Name: ${lastProfile.profileName}'),
                                  Text('Latitude: ${lastProfile.latitude}'),
                                  Text('Longitude: ${lastProfile.longitude}'),
                                  Text(
                                      'Favorite Activities: ${lastProfile.customeNote.join(', ')}'),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  _showProfileDetailsDialog(
                                      context, lastProfile);
                                },
                                icon: const Icon(
                                  Icons.person_2_sharp,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            )
          : ListView.builder(
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];

                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue[100],
                  ),
                  child: ListTile(
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Text(
                            //   'New User',
                            //   style: TextStyle(
                            //       fontSize: 18, fontWeight: FontWeight.bold),
                            // ),
                            Text('Latitude: ${profile.latitude}'),
                            Text('Longitude: ${profile.longitude}'),
                            Text('Profile Name: ${profile.profileName}'),
                            Text(
                                'Favorite Activities: ${profile.customeNote.join(', ')}'),
                          ],
                        ),
                        IconButton(
                            onPressed: () async {
                              final deviceProfile = await ProfileSettings(
                                profileName: profile.profileName,
                                themeColor: Colors.blue,
                                textSize: 16.0,
                              );

                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileSettingsScreen(
                                      devprofile: deviceProfile),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.settings,
                            ))
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final profile = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocationInputScreen(),
            ),
          );

          if (profile != null) {
            final dbHelper = DatabaseHelper();
            await dbHelper.insertProfile(profile);
            ref.read(profileProvider.notifier).addProfile(profile);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void _showProfileDetailsDialog(BuildContext context, PlaceProfile profile) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Profile Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Profile Name: ${profile.profileName}'),
            Text('Latitude: ${profile.latitude}'),
            Text('Longitude: ${profile.longitude}'),
            Text('Favorite Activities: ${profile.customeNote.join(', ')}'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}
