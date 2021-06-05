
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class ChewiListItem extends StatefulWidget {

  final VideoPlayerController videoPlayerController;
  final bool looping;

  ChewiListItem({
    @required this.videoPlayerController,this.looping,Key key,
  }) : super(key: key);

  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<ChewiListItem> {

  ChewieController _chewieController;

  @override
  void initState(){
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: widget.videoPlayerController.value.aspectRatio,
        autoInitialize: true,
        looping: widget.looping,

        errorBuilder: (context,errMsg){
          return Center(
            child: Text(errMsg),
          );
        }

    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Chewie(
          controller: _chewieController,
        )
    );
  }

  @override
  void dispose(){
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
