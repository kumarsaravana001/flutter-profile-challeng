import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_foyer_demo/models/device_settings_model.dart.dart';
import 'package:flutter_foyer_demo/provider/profile_provider.dart';
import 'package:flutter_foyer_demo/screens/profiledisplay_screen.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, List<PlaceProfile>>(
  (ref) => ProfileNotifier(),
);

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Challenge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProfileDisplayScreen(),
    );
  }
}
