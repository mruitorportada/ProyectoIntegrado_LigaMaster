import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/generic/generic_widgets/mydrawer.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _backgroundColor = AppColors.background;
  @override
  Widget build(BuildContext context) {
    var homeScreenViewModel =
        Provider.of<HomeScreenViewmodel>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      appBar: myAppBar("Detalles del perfil", _backgroundColor, [], null),
      body: Placeholder(),
      drawer: myDrawer(context, homeScreenViewModel.user),
    ));
  }
}
