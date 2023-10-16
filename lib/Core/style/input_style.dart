import 'package:flutter/material.dart';

// class InputStyleManager {
//   static final inputDecoration = InputDecoration(
//     isDense: true,
//     contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//     counter: const Offstage(),
//     errorBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.red),
//         borderRadius: BorderRadius.circular(10)),
//     focusedErrorBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.red),
//         borderRadius: BorderRadius.circular(10)),
//     enabledBorder: OutlineInputBorder(
//         borderSide: const BorderSide(width: 2, color: Colors.black12),
//         borderRadius: BorderRadius.circular(12)),
//     focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(width: 2, color: Colors.blue),
//         borderRadius: BorderRadius.circular(12)),
//   );
// }

OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderSide: const BorderSide(width: 2, color: Colors.black12),
    borderRadius: BorderRadius.circular(12));
OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderSide: const BorderSide(width: 2, color: Colors.blue),
    borderRadius: BorderRadius.circular(12));
OutlineInputBorder fucsedErrorBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red),
    borderRadius: BorderRadius.circular(10));
OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red),
    borderRadius: BorderRadius.circular(10));
