import 'package:flutter/material.dart';
import 'package:liga_master/models/user/user.dart';
import 'package:liga_master/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  @override
  void initState() {
    User user = Provider.of<User>(context, listen: false);
    var navigator = Navigator.of(context);
    user.load().then((value) => {
          navigator.pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          )
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      );
}
