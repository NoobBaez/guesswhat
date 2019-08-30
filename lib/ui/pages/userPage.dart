//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:Tekel/ui/widgets/custom/customGridView.dart';
import 'package:Tekel/core/model/user.dart';
import 'package:Tekel/core/services/db.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  final User user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserPage({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(SimpleLineIcons.getIconData('arrow-left')),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Tekel'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 2.7,
            ),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/noiseTv.gif',
                            image: user.photoURL,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '${user.displayName}',
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '1.000.000 Members',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit,'
                      'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip'
                      'ex ea commodo consequat',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton.icon(
                          icon:
                              Icon(SimpleLineIcons.getIconData('user-follow')),
                          color: Colors.yellow,
                          label: Text(
                            'Join',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {},
                        ),
                        RaisedButton.icon(
                          icon: Icon(SimpleLineIcons.getIconData('trophy')),
                          label: Text(
                            'Leaderboard',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: Provider.of<DatabaseServices>(context).fectchUserRidlle(userId: user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) //return Text('${snapshot.data}');
                return Expanded(
                  child: CustomGridView(
                    list: snapshot.data,
                  ),
                );
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
