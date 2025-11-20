import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AppUtils {
  // Format price
  static String formatPrice(num number) {
    final format = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return format.format(number);
  }

  // Show toast
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Validate email
  static bool validateEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  // Check if user is admin
  // Accepting dynamic for now as UserModel might not be fully defined
  static bool isAdmin(dynamic user) {
    if (user == null) return false;
    
    // Check if user is a Map
    if (user is Map) {
      return user['role'] == 'admin' || user['isAdmin'] == true;
    }
    
    // Check if user has a role property (using reflection or dynamic access)
    try {
      return user.role == 'admin' || user.isAdmin == true;
    } catch (e) {
      return false;
    }
  }
}
