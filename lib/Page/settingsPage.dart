import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uas_ambw/pin.dart';

class SettingsPage extends StatelessWidget {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              decoration: InputDecoration(labelText: 'New PIN'),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pinBox = Hive.box<Pin>('pin');
                pinBox.putAt(0, Pin(pin: _pinController.text));
                Navigator.pop(context);
              },
              child: Text('Change PIN'),
            ),
          ],
        ),
      ),
    );
  }
}