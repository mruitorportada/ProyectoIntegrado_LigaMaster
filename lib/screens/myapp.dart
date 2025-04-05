import 'package:flutter/material.dart';
import 'package:liga_master/models/user/user.dart';
import 'package:liga_master/screens/boot/boot_screen.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        InheritedProvider(
            create: (context) => User(
                id: "1",
                name: "Mario",
                surname: "Ruiz",
                username: "mruitor",
                email: "mruitor@gmail.com",
                password: "password")),
        InheritedProvider(
          create: (context) =>
              HomeScreenViewmodel(Provider.of<User>(context, listen: false)),
        )
      ],
      child: MaterialApp(
        title: "Liga Master",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BootScreen(),
      ),
    );
  }
}
