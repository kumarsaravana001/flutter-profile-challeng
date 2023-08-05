import 'package:flutter/material.dart';
import 'package:flutter_foyer_demo/database/database.dart';
import 'package:flutter_foyer_demo/screens/profilesetup_screen.dart';

class LocationInputScreen extends StatefulWidget {
  @override
  State<LocationInputScreen> createState() => _LocationInputScreenState();
}

class _LocationInputScreenState extends State<LocationInputScreen> {
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  bool _isValidLatitude(double latitude) {
    return latitude >= -90.0 && latitude <= 90.0;
  }

  bool _isValidLongitude(double longitude) {
    return longitude >= -180.0 && longitude <= 180.0;
  }

  bool _isValidDecimalFormat(String value) {
    final regex = RegExp(r'^[-+]?([0-9]+([.][0-9]*)?|[.][0-9]+)$');
    if (!regex.hasMatch(value)) {
      return false;
    }

    final parts = value.split('.');
    if (parts.length == 2 && parts[1].length > 6) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Location Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInputField(
              label: 'Latitude',
              controller: latitudeController,
            ),
            _buildInputField(
              label: 'Longitude',
              controller: longitudeController,
            ),
            ElevatedButton(
              onPressed: () async {
                String latitudeString = latitudeController.text.trim();
                String longitudeString = longitudeController.text.trim();

                if (latitudeString.isNotEmpty &&
                    longitudeString.isNotEmpty &&
                    _isValidDecimalFormat(latitudeString) &&
                    _isValidDecimalFormat(longitudeString)) {
                  double latitude = double.tryParse(latitudeString) ?? 0.0;
                  double longitude = double.tryParse(longitudeString) ?? 0.0;

                  if (_isValidLatitude(latitude) &&
                      _isValidLongitude(longitude)) {
                    final dbHelper = DatabaseHelper();
                    bool isDuplicate =
                        await dbHelper.isProfileDuplicateByCoordinates(
                      latitude: latitude,
                      longitude: longitude,
                    );
                    if (isDuplicate) {
                      _showDuplicateLocationDialog();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileSetupScreen(
                            latitude: latitude,
                            longitude: longitude,
                          ),
                        ),
                      );
                    }
                  } else {
                    _showInvalidLocationDialog();
                  }
                } else {
                  _showEmptyFieldsDialog();
                }
              },
              child: const Text('Create a Profile'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDuplicateLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Duplicate Location'),
          content: const Text(
            'A profile with the same location already exists, please provide new location.',
            textAlign: TextAlign.center,
          ),
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

  void _showInvalidLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid Location'),
          content: const Text(
              'Please enter valid latitude (-90 to 90) and longitude (-180 to 180).'),
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

  void _showEmptyFieldsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Empty Fields'),
          content:
              const Text('Please enter both latitude and longitude values.'),
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? errorMessage,
  }) {
    return TextField(
      controller: controller,
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }

  bool _isFieldEmpty(String value) {
    return value.isEmpty;
  }
}
