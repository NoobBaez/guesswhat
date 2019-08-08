import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:guess_what/core/viewModel/DrawerViewModel.dart';
import 'package:guess_what/ui/widgets/costum/costumDrawer.dart';
import 'package:provider/provider.dart';

//Coustom import
import 'package:guess_what/core/viewModel/guessModel.dart';
import 'package:guess_what/ui/widgets/costum/costumListGuess.dart';
import '../widgets/costum/buttonPress.dart';

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
            icon: Icon(SimpleLineIcons.getIconData('plus')),
            onPressed: () => onButtonPressed(context), //Add multimedia
          )
        ],
        title: Text(
          'Tekel',
          style: TextStyle(color: Colors.yellowAccent),
        ),
        centerTitle: true,
      ),
      drawer: ChangeNotifierProvider<DrawerViewModel>.value(
        value: DrawerViewModel(authentication: Provider.of(context)),
        child: Consumer<DrawerViewModel>(
          builder: (context, model, child) {
            return CostumDrawer(model: model);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: ChangeNotifierProvider<GuessModel>.value(
        value: GuessModel(
          databaseServices: Provider.of(context),
        ),
        child: Consumer<GuessModel>(
          builder: (context, model, child) {
            return CostumListGuess(
              model: model,
              onModelReady: () => model.getAllGuesses(),
            );
          },
        ),
      ),
    );
  }
}

