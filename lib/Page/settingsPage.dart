import 'package:flutter/material.dart';
import 'package:uas_ambw/Page/registerPin.dart';
import 'package:uas_ambw/Theme/lightMode.dart';

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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPin()),
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.lock_open_outlined,
                  ),
                  SizedBox(width: 30.0),
                  Text(
                    'Change New Pin',
                    style: TextStyle(
                      color: getFontColor(),
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
