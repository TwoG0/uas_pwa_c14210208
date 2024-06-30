import 'package:flutter/material.dart';

bool isLightMode = true;


Color getFontColor() {
  if (isLightMode) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

Color getBackgroundColor() {
  if (isLightMode) {
    return Colors.white;
  } else {
    return Color.fromARGB(255, 18, 18, 18);
  }
}

Color getCardColor(){
  if (isLightMode) {
    return Colors.grey.shade200;
    } else {
      return Color.fromARGB(255, 35, 35, 35);
    }
}

Color getHintColor(){
  if (isLightMode) {
    return Colors.grey.shade500;
  }else{
    return Color.fromARGB(255, 149, 149, 149);
  }
}

Color getFloatColor(){
  if (isLightMode) {
    return Colors.blue.shade200;
  }else{
    return Colors.blue.shade900;
  }
}