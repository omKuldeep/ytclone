import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../view/video_player_view/enum.dart';


class VideoPlayerProvider extends ChangeNotifier{

  static String Api_KEY = "AIzaSyAaATaZ1TE5aeCFY4SWx6p70KWWQVL5K1M";
  final YoutubeAPI _yt = YoutubeAPI(Api_KEY, maxResults: 150, type: "video",);
  List<Response<YouTubeVideo>> response=[];

  late YoutubePlayerController _playerController;
   YoutubePlayerController get playerController=>_playerController;

  late PlayerState _playerState;
   PlayerState get playerState=> _playerState;

  late YoutubeMetaData _videoMetaData;
   YoutubeMetaData get videoMetaData=> _videoMetaData;

  double _volume = 50.0;
  double get volume => _volume;
  bool _muted = false;
  bool get muted => _muted;
  bool _isPlayerReady = false;
  bool get isPlayerReady => _isPlayerReady;

  bool _isPlay=true;
  bool get isPlay=>_isPlay;

  double _bottomSheetHeight = 100.0;
  double get bottomSheetHeight => _bottomSheetHeight;

  bool _isFavSheetOpen=false;
  bool get isFavSheetOpen=>_isFavSheetOpen;
  double _bottomFavSheetHeight = 140.0;
  double get bottomFavSheetHeight => _bottomFavSheetHeight;

  bool _fullScreen=false;
  bool get fullScreen=>_fullScreen;

  bool _isRepeat=false;
  bool get isRepeat=>_isRepeat;

  bool _showPlayer=false;
  bool get showPlayer=>_showPlayer;

  bool _isPlayList=false;
  bool get isPlayList=>_isPlayList;

  String _getVideoId="";
  String get getVideoId=>_getVideoId;

  late List _videoList;
  List get videoList=>_videoList;


  setResponse(List<Response<YouTubeVideo>> data){
    try {
      response=data;
     // log(data.toString());
    } on Exception catch (e) {
      log("error load data");
    }
    notifyListeners();
  }


  Future<void> searchVideo(String input) async {
    setResponse([Response<YouTubeVideo>.loading()]);

    log("message ");
    try {
      await _yt.search(input).then((onValue){

        // log("datas "+onValue.toString());
        // List<YouTubeVideo> videoList = [];
        // for (var item in onValue) {
        //   videoList.add(item);
        // }

        setResponse([Response.complete(onValue)]);


      });
    } on SocketException catch (e) {
      print(" eee " + e.message);
      setResponse([Response.error("Check Internet Connection")]);
    }on TimeoutException catch (e) {
      setResponse([Response.error("Connection time out")]);
      log(" eee " + e.toString());

    }catch(e){
      log(" cat " + e.toString());
    if (e.toString() == "Null check operator used on a null value") {
      setResponse([Response.complete([])]);
    }else{
      setResponse([Response.error("Error while loading video")]);
    }
    }
  }
  void initController(String videoId,vList){
    _bottomSheetHeight=100.0;
log(isPlayerReady.toString());
    // Initialize WebView settings
    if (!isPlayerReady) {
      _fullScreen=false;
      _bottomSheetHeight=100.0;
      InAppWebViewSettings  settings = InAppWebViewSettings(

        javaScriptEnabled: true,
        mediaPlaybackRequiresUserGesture: false,
        preferredContentMode: UserPreferredContentMode.MOBILE,
        useHybridComposition: true,
        allowsInlineMediaPlayback: true,

      );

      _playerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: false,
          controlsVisibleAtStart: false,
        ),
      )..addListener(listener);

      _playerController.value.webViewController?.setSettings(settings: settings );
      _playerController.value.webViewController?.evaluateJavascript(
          source: 'document.getElementById("elementId").innerText');
    }else{
      playerController.pause();
      playerController.load(videoId);
    }
    _getVideoId=videoId;
    _videoList=vList;
  }

  void listener() {
//unknown

    if(!playerController.value.hasPlayed){
      notifyListeners();
      //log("no played");
    }


   // log(("state "+ playerController.value.playerState.name.toString()));

    if (_isPlayerReady && !_playerController.value.isFullScreen) {
      //  setState(() {
      _playerState = _playerController.value.playerState;
      _videoMetaData = _playerController.metadata;
      //  });
    //  notifyListeners();
    }else{
      notifyListeners();
    }
    if(_playerController.value.isPlaying){
      _isPlay=true;
    }else{
      _isPlay=false;
    }

    if(playerController.value.playerState.name.toString()=="paused"){
      _isPlay=true;
      notifyListeners();
    }else if(playerController.value.playerState.name.toString()=="buffering"){
      _isPlay=true;
      notifyListeners();
    }else if(playerController.value.playerState.name.toString()=="unknown"){
      notifyListeners();
    }

  }

  void disposeData(){
    _playerController.pause();
    _playerController.dispose();
    _isPlayerReady=false;
    _isPlay=true;
    _isRepeat=false;
  }

  void setVolumes(volume){
    _volume=volume;
    notifyListeners();
  }
  void setMuted(){
    _muted=!_muted;
    notifyListeners();
  }

  void changeBottomSheetHeight(double height) {
    if (_bottomSheetHeight == 100.0) {
      _fullScreen=true;
      _bottomSheetHeight = height;
    } else {
      _fullScreen=false;
      _bottomSheetHeight = 100.0;
    }
    notifyListeners();
  }

  void playerReady(value){
    _isPlayerReady=true;
    notifyListeners();
  }

  void showPlayerBottom(bool  value){
    _bottomSheetHeight=100.0;
     _showPlayer=value;
     notifyListeners();
  }

  void listPlay(list){
    _videoList=list;
  }


  void play(){

    log("has "+playerController.value.position.toString());
    if(!playerController.value.hasPlayed) {
      log("reload");
     playerController.reload();
      _isPlay = true;
    }else{

      if (playerController.value.isPlaying) {
        log("play");
        playerController.pause();
        _isPlay = false;
      } else {
        log("not pause");
        playerController.play();
        _isPlay = true;
      }
    }

    notifyListeners();
  }

  void repeat(){
    _isRepeat=!_isRepeat;
    notifyListeners();
  }

  void playAllList(bool value,bool value1){
    _isPlayList=value;
    _isFavSheetOpen=value1;
    _showPlayer=value;
    _bottomSheetHeight=0.0;
    notifyListeners();
  }



  void changeFavSheetHeight(Size size){
    if (_bottomFavSheetHeight == 140.0) {
      _bottomFavSheetHeight = size.height;
    } else {
      _bottomFavSheetHeight = 140.0;
    }
    notifyListeners();

  }
  void setFavSheetHeight(value){
    _bottomFavSheetHeight=value;
  }

  openFavSheet(bool value){
    _isFavSheetOpen=value;
notifyListeners();
  }

  void playNext(list){
    _playerController.pause();
    try {
      _playerController.load(list[(list.indexOf(_playerController.metadata.videoId) +1) % list.length]);
    } on Exception catch (e) {
      // TODO
    }

  }

  void playPrev(list){

    _playerController.pause();
    _playerController.load(list[(list.indexOf(_playerController.metadata.videoId) -1) % list.length]);

  }

}