import 'package:flutter/material.dart';
import 'package:flutter_foyer_demo/models/profile_settings_model.dart';

import '../database/database.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final ProfileSettings devprofile;

  ProfileSettingsScreen({super.key, required this.devprofile});

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String? _profileName;
  Color? _themeColor;
  double? _textSize;

  @override
  void initState() {
    super.initState();

    _profileName = widget.devprofile.profileName;
    _themeColor = widget.devprofile.themeColor ?? Colors.blue;
    _textSize = widget.devprofile.textSize ?? 16.0;
  }

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile Name: $_profileName',
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Choose the theme"),
                ),
                DropdownButton<Color>(
                  value: _themeColor,
                  onChanged: (value) {
                    setState(() {
                      _themeColor = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Colors.blue,
                      child: Text('Blue Theme'),
                    ),
                    DropdownMenuItem(
                      value: Colors.red,
                      child: Text('Red Theme'),
                    ),
                    DropdownMenuItem(
                      value: Colors.green,
                      child: Text('Green Theme'),
                    ),
                    DropdownMenuItem(
                      value: Colors.grey,
                      child: Text('Grey Theme'),
                    ),
                  ],
                ),
              ],
            ),
            Slider(
              value: widget.devprofile.textSize,
              onChanged: (value) {
                setState(() {
                  widget.devprofile.textSize = value;
                });
              },
              min: 12.0,
              max: 40.0,
            ),
            Text(
              'Text Size: ${widget.devprofile.textSize.toStringAsFixed(1)}',
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
