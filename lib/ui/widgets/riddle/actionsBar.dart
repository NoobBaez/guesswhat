//Flutter import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Tekel/core/model/love.dart';
import 'package:Tekel/core/services/db.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/simple_line_icons.dart';

//Self import
import 'package:Tekel/core/model/riddle.dart';
import 'package:share_extend/share_extend.dart';
import 'package:Tekel/core/custom/customCacheManager.dart';
import 'package:Tekel/core/services/auth.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({
    Key key,
    @required this.riddle,
  }) : super(key: key);

  final Riddle riddle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StreamBuilder<FirebaseUser>(
          stream: Provider.of<AuthenticationServices>(context).user(),
          builder: (context, userSnap) {
            if (userSnap.data != null)
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  StreamBuilder<Love>(
                    stream: Provider.of<DatabaseServices>(context).loveStream(
                        riddleId: riddle.id, userId: userSnap.data.uid),
                    builder: (context, loveSnap) {
                      var loveState = loveSnap?.data?.state ?? false;

                      return FlatButton.icon(
                        icon: loveState
                            ? Icon(
                                Icons.favorite,
                                color: Colors.yellow,
                              )
                            : Icon(
                                SimpleLineIcons.getIconData('heart'),
                              ),
                        label: Text(
                          'Love',
                        ),
                        onPressed: () {
                          if (userSnap.data == null) {
                            Scaffold.of(context).openDrawer();
                            return null;
                          }

                          Provider.of<DatabaseServices>(context)
                              .updateLoveState(
                            riddleId: riddle.id,
                            love: Love(
                              state: !loveState,
                              userId: userSnap.data.uid,
                              riddleId: riddle.id,
                              thumbnailUrl: riddle.thumbnailUrl,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  FlatButton.icon(
                    icon: Icon(
                      SimpleLineIcons.getIconData('bubbles'),
                    ),
                    label: Text(
                      'Comment',
                    ),
                    onPressed: () {
                      //?This is not working
                      if (userSnap.data == null) {
                        Scaffold.of(context).openDrawer();
                        return null;
                      }
                      Navigator.of(context)
                          .pushNamed('commentsPage', arguments: riddle);
                    },
                  ),
                  FlatButton.icon(
                    icon: Icon(
                      SimpleLineIcons.getIconData('share'),
                    ),
                    label: Text(
                      'Share',
                    ),
                    onPressed: () async {
                      var f = await CustomCacheManager().getSingleFile(
                          '${riddle.imageUrl ?? riddle.videoUrl}');
                      var mimeType = lookupMimeType(f.path.split('/').first);
                      ShareExtend.share(f.path, mimeType);
                    },
                  ),
                ],
              ); //unattainable
            return Container(); //unattainable
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            riddle.loves.isNotEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${riddle.loves} Loves',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Container(),
            riddle.comments.isNotEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed('commentsPage', arguments: riddle),
                      child: Text(
                        '${riddle.comments} Comments',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }
}
