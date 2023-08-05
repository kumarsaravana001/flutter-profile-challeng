import 'package:flutter/material.dart';

class PlaceProfile {
  int? id;
  String profileName;
  double latitude;
  double longitude;
  List<String> customeNote;
  final String? createdTime;

  PlaceProfile(
      {this.id,
      required this.profileName,
      required this.latitude,
      required this.longitude,
      required this.customeNote,
      this.createdTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placeName': profileName,
      'latitude': latitude,
      'longitude': longitude,
      'favoriteActivities': customeNote.join(','),
    };
  }

  factory PlaceProfile.fromMap(Map<String, dynamic> map) {
    return PlaceProfile(
      id: map['id'],
      profileName: map['placeName'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      customeNote: map['favoriteActivities'].split(','),
    );
  }
}
