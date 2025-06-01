import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/generic/generic_widgets/mydrawer.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  final HomeScreenViewmodel homeScreenViewmodel;
  const ProfileScreen({super.key, required this.homeScreenViewmodel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser get _user => widget.homeScreenViewmodel.user;
  final _imagePicker = ImagePicker();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(context, "Detalles del perfil", [], null),
        body: _body,
        drawer: myDrawer(context, widget.homeScreenViewmodel),
      ),
    );
  }

  Widget get _body => ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              await _imagePicker
                  .pickImage(
                source: ImageSource.gallery,
                preferredCameraDevice: CameraDevice.rear,
              )
                  .then(
                (value) {
                  if (value != null) {
                    _cropImage(File(value.path));
                  }
                },
              );
            },
            child: _user.image != null
                ? Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                          File(_user.image!),
                        ),
                        fit: BoxFit.contain,
                      ),
                      shape: BoxShape.circle,
                    ),
                  )
                : CircleAvatar(
                    radius: 60,
                    child: Icon(
                      Icons.person,
                      size: 60,
                    ),
                  ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: _user.name,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Nombre",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: _user.surname,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Apellidos",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: _user.username,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Nombre de usuario",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: _user.email,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Email",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: "${_user.competitions.length}",
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Competiciones guardadas",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: "${_user.teams.length}",
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Equipos guardados",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: "${_user.players.length}",
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Jugadores guardados",
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      );

  void _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: "Ajusta la imagen",
            toolbarColor: Theme.of(context).appBarTheme.backgroundColor,
            toolbarWidgetColor: Theme.of(context).appBarTheme.foregroundColor,
            lockAspectRatio: true),
        IOSUiSettings(
          title: "Ajusta la imagen",
          aspectRatioLockEnabled: true,
        )
      ],
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (croppedFile != null) {
      imageCache.clear();
      setState(() {
        _selectedImage = File(croppedFile.path);
        _user.image = _selectedImage!.path;
      });
    }
  }
}
