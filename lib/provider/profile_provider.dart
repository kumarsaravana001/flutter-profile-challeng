import 'package:flutter/material.dart';
import 'package:flutter_foyer_demo/models/profile_settings_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_foyer_demo/models/device_settings_model.dart.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, List<PlaceProfile>>(
        (ref) => ProfileNotifier());

class ProfileNotifier extends StateNotifier<List<PlaceProfile>> {
  ProfileNotifier() : super([]);

  void addProfile(PlaceProfile profile) {
    state = [...state, profile];
  }

  bool isProfileDuplicate(PlaceProfile profile) {
    return state.any((savedProfile) =>
        savedProfile.profileName == profile.profileName &&
        //   savedProfile.latitude == profile.latitude &&
        // savedProfile.longitude == profile.longitude &&
        savedProfile.customeNote.toSet().containsAll(profile.customeNote) &&
        savedProfile.customeNote.length == profile.customeNote.length);
  }

  void updateProfile(int profileId, String newProfileName) {
    state = state.map((profile) {
      if (profile.id == profileId) {
        return PlaceProfile(
          //id: profile.id,
          profileName: newProfileName,
          latitude: profile.latitude,
          longitude: profile.longitude,
          customeNote: profile.customeNote,
        );
      } else {
        return profile;
      }
    }).toList();
  }
}
