import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:liga_master/firebase_options.dart';
import 'package:liga_master/screens/myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Myapp());
}
