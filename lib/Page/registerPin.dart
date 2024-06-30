import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uas_ambw/main.dart';
import 'package:uas_ambw/pin.dart';
import 'package:uas_ambw/Theme/lightMode.dart';

class RegisterPin extends StatefulWidget {
  @override
  _RegisterPinState createState() => _RegisterPinState();
}

class _RegisterPinState extends State<RegisterPin> {
  final TextEditingController _pinController = TextEditingController();
  List<String> newPin = [];

  Future<void> _savePin() async {
    final pinBox = await Hive.openBox<Pin>('pin');
    if (pinBox != null && newPin.length == 4) {
      if (pinBox.isEmpty) {
        pinBox.add(Pin(pin: _pinController.text));
      } else {
        pinBox.putAt(0, Pin(pin: _pinController.text));
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
  }

  void _updatePin(String number) {
    setState(() {
      if (newPin.length < 4) {
        newPin.add(number);
        _pinController.text = newPin.join();
        if (newPin.length == 4) {
          _savePin();
        }
      }
    });
  }

  void _removeLastDigit() {
    setState(() {
      if (newPin.isNotEmpty) {
        newPin.removeLast();
        _pinController.text = newPin.join();
      }
    });
  }

  Color getPinColor(List pin, int index) {
    if (pin.length >= index) {
      return Colors.grey.shade700;
    } else {
      return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        title: Text(
          'Register New Pin',
          style: TextStyle(color: getFontColor()),
        ),
        backgroundColor: getBackgroundColor(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  color: getPinColor(newPin, 1),
                  size: 50,
                ),
                SizedBox(
                  width: 15,
                ),
                Icon(
                  Icons.circle,
                  color: getPinColor(newPin, 2),
                  size: 50,
                ),
                SizedBox(
                  width: 15,
                ),
                Icon(
                  Icons.circle,
                  color: getPinColor(newPin, 3),
                  size: 50,
                ),
                SizedBox(
                  width: 15,
                ),
                Icon(
                  Icons.circle,
                  color: getPinColor(newPin, 4),
                  size: 50,
                ),
              ],
            ),
            SizedBox(height: 40),
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              shrinkWrap: true,
              children: List.generate(11, (index) {
                if (index == 9) {
                  return ElevatedButton(
                    onPressed: _removeLastDigit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: getFontColor(),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Icon(Icons.backspace),
                  );
                } else if (index == 10) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (newPin.length < 4) {
                        _updatePin('0');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: getFontColor(),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Text(
                      '0',
                      style: TextStyle(fontSize: 30),
                    ),
                  );
                } else {
                  int number = index + 1;
                  if (number == 10) number = 0;
                  return ElevatedButton(
                    onPressed: () async {
                      if (newPin.length < 4) {
                        _updatePin(number.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: getFontColor(),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Text(
                      number.toString(),
                      style: TextStyle(fontSize: 30),
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
