
import 'package:chewie/chewie.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import '../Widgets/customAppBar.dart';
import '../Widgets/chewiePlayer.dart';

class SearchService {
}

class SearchProduct extends StatefulWidget {

  final VideoPlayerController videoPlayerController;
  final bool looping;

  SearchProduct({
    @required this.videoPlayerController,this.looping,Key key,
  }) : super(key: key);

  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {


    @override
    Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: <Widget>[
            ChewiListItem(
                videoPlayerController: VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',),
            ),
          ],
        ),
    );
  }

  }
