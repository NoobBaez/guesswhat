import 'package:flutter/material.dart';
import 'package:guess_what/core/services/db.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  DatabaseServices _dbServices;
  VideoPlayerController videoController;
  bool _isNotDone = true;

  VideoViewModel({@required DatabaseServices dbServices})
      : _dbServices = dbServices;

  Future getVideoController() async {
    if (_isNotDone) {
      videoController = VideoPlayerController.network(
          'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
        ..initialize().then(
          (_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            videoController.setLooping(true);
            videoController.play();

            _isNotDone = false;
            notifyListeners();
          },
        );
    }
  }
}
