//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:guess_what/ui/widgets/custom/customDrawer.dart';
import 'package:guess_what/ui/widgets/custom/customListGuess.dart';
import '../widgets/custom/buttonPress.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('menu')),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              SimpleLineIcons.getIconData('plus'),
              color: Colors.yellow,
            ),
            onPressed: () => onButtonPressed(context), //Add multimedia
          )
        ],
        title: Text(
          'Tekel',
        ),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      backgroundColor: Colors.black,
      body: CustomListGuess(),
    );
  }
}