import 'package:flutter/material.dart';
import 'package:guess_what/core/viewModel/videoViewModel.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';

class VideoLayaout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoViewModel>.value(
      value: VideoViewModel(dbServices: Provider.of(context)),
      child: Consumer<VideoViewModel>(builder: (context, model, child) {
        //Init the videoController if it is NULL
        model.videoController?.value ?? model.getVideoController();
        return Stack(
          children: <Widget>[
            model.videoController != null
                ? VideoPlayer(model.videoController)
                : Center(child: CircularProgressIndicator()),
            BuildAvatarIcon(),
          ],
        );
      }),
    );
  }
}

class BuildAvatarIcon extends StatelessWidget {
  const BuildAvatarIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.yellow,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                'User Name',
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
