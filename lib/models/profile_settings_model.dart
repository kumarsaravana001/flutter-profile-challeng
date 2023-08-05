import 'dart:ui';

class ProfileSettings {
  // int id;
  String profileName;
  Color themeColor;
  double textSize;

  ProfileSettings({
    // required this.id,
    required this.profileName,
    required this.themeColor,
    required this.textSize,
  });

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'profileName': profileName,
      'themeColor': themeColor.value,
      'textSize': textSize,
    };
  }

  static ProfileSettings fromMap(Map<String, dynamic> map) {
    return ProfileSettings(
      //  id: map['id'],
      profileName: map['profileName'],
      themeColor: Color(map['themeColor']),
      textSize: map['textSize'],
    );
  }
}
