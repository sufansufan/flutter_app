 import 'package:flutter/material.dart';

 class CurrentIndexProvide with ChangeNotifier {
   int currnetIndex = 0;

   changeIndex(int newIndex) {
     currnetIndex = newIndex;
     notifyListeners();
   }
 }
