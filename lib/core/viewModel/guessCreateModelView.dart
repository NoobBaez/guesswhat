import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guess_what/core/services/db.dart';

class GuessCreateViewModel extends ChangeNotifier {
  final DatabaseServices _databaseServices;
  GuessCreateViewModel({@required DatabaseServices databaseServices})
      : _databaseServices = databaseServices;

  Future<String> uploadFireStore({File file, BuildContext context}) async {
    //Upload Image/video
    var url = await _databaseServices.uploadToFireStore(file).whenComplete(() {
      print('FIREBASE DONE0.');
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Uploaded Successfully'),
        ),
      );
    });

    return url;
    //TODO: Show snackBar when upload is complete
  }

  void uploadFireBase({Map<String, dynamic> guess}) {
    return _databaseServices.uploadGuess(guess: guess);
  }
}
