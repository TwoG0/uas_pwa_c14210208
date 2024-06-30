import 'package:flutter/material.dart';
import 'package:uas_ambw/Page/homePage.dart';
import 'package:uas_ambw/Page/registerPin.dart';
import 'package:uas_ambw/Theme/lightMode.dart';
import 'package:uas_ambw/main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

Future<void> changeMode() async {}

class _SettingsPageState extends State<SettingsPage> {
  void updateMode() async {
    bool currentValue = lightModeBox.get(0)!;
    bool newValue = !currentValue;

    await lightModeBox.putAt(0, newValue);

    setState(() {
      isLightMode = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: getFontColor()),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: getFontColor(),),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        backgroundColor: getBackgroundColor(),
      ),
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
                    color: getFontColor(),
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
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: updateMode,
              child: Row(
                children: [
                  Icon(
                    isLightMode ? Icons.light_mode : Icons.dark_mode,
                    color: getFontColor(),
                  ),
                  SizedBox(width: 30.0),
                  Text(
                    isLightMode ? 'Light Mode' : 'Dark Mode',
                    style: TextStyle(
                      color: getFontColor(),
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
