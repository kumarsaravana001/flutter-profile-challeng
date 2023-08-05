import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile_settings_model.dart';

class ProfileSettingsNotifier extends StateNotifier<ProfileSettings> {
  ProfileSettingsNotifier(ProfileSettings profileSettings)
      : super(profileSettings);

  void updateProfileSettings(ProfileSettings updatedProfileSettings) {
    state = updatedProfileSettings;
  }
}

final profileSettingsProvider =
    StateNotifierProvider<ProfileSettingsNotifier, ProfileSettings>((ref) {
  return ProfileSettingsNotifier(ProfileSettings(
    profileName: 'Default Profile',
    themeColor: Colors.blue,
    textSize: 16.0,
  ));
});
