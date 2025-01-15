import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kio_chat/view_model/video_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



/// Homepage
class VideoPlayerScreen extends StatefulWidget {
  final String title;
  final String url;
  final bool fullScreen;
  final VideoPlayerProvider provider;
  final String channel;
  final List<String>? videoList;

  const VideoPlayerScreen({super.key, required this.title, required this.url,required this.fullScreen, required this.provider,required this.channel,required this.videoList});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> with WidgetsBindingObserver {
 // late YoutubePlayerController _controller;
 //  late TextEditingController _idController;
 //  late TextEditingController _seekToController;
 //
 //  late PlayerState _playerState;
 //  late YoutubeMetaData _videoMetaData;
 //  double _volume = 50;
 //  bool _muted = false;
 //  bool _isPlayerReady = false;
 //
 //  final List<String> _ids = [
 //    'nPt8bK2gbaU',
 //    'gQDByCdjUXw',
 //    'iLnmTe5Q2Qw',
 //    '_WoCV4c6XOE',
 //    'KmzdUe0RSJo',
 //    '6jZDSSZZxjQ',
 //    'p2lYr3vM_1w',
 //    '7QUtEmBT_-w',
 //    '34_PXCzGw1M',
 //  ];

   late VideoPlayerProvider _controller;


   //
   // @override
   // void didChangeAppLifecycleState(AppLifecycleState state) async {
   //   switch (state) {
   //     case AppLifecycleState.resumed:
   //       log('App minimised Back to app');
   //       break;
   //     case AppLifecycleState.paused:
   //       log('App minimised or Screen pause');
   //       break;
   //     case AppLifecycleState.detached:
   //       log('App minimised or Screen det');
   //     case AppLifecycleState.inactive:
   //       log('App minimised or Screen ina');
   //     case AppLifecycleState.hidden:
   //       log('App minimised or Screen hide');
   //   }
   // }

  @override
  void initState() {
    _controller=widget.provider;
    //log("kk "+_controller.isPlayerReady.toString());
    try {
      if(_controller.isPlayerReady){
        _controller.playerController.pause();
      }
    } on Exception catch (e) {
      // TODO
    }
   // _controller.initController(widget.url);
  //  WidgetsBinding.instance.addObserver(this);
    super.initState();
  }


  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.playerController.pause();
    super.deactivate();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       print('Back to app');
  //       break;
  //     case AppLifecycleState.paused:
  //       print('App minimised or Screen locked');
  //       break;
  //     case AppLifecycleState.detached:
  //     // TODO: Handle this case.
  //     case AppLifecycleState.inactive:
  //     // TODO: Handle this case.
  //     case AppLifecycleState.hidden:
  //     // TODO: Handle this case.
  //   }
  // }

  @override
  void dispose() {
    _controller.disposeData();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height,
      child: IgnorePointer(
        ignoring:widget.fullScreen?false:true ,
        child: YoutubePlayerBuilder(
          onExitFullScreen: () {
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          }, player: YoutubePlayer(
            controller: _controller.playerController,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            // topActions: <Widget>[
            //   const SizedBox(width: 8.0),
            //   Expanded(
            //     child: Text(
            //       _controller.playerController.metadata.title,
            //       style: const TextStyle(
            //         color: Colors.white,
            //         fontSize: 18.0,
            //       ),
            //       overflow: TextOverflow.ellipsis,
            //       maxLines: 1,
            //     ),
            //   ),
            //   IconButton(
            //     icon: const Icon(
            //       Icons.settings,
            //       color: Colors.white,
            //       size: 25.0,
            //     ),
            //     onPressed: () {
            //
            //
            //       log('Settings Tapped!');
            //     },
            //   ),
            // ],
            onReady: () {
              _controller.playerReady(true);
              _controller.play();

              _controller.timerNotifier(true);
            //  log("endddz");
          //    log("enddds ${_controller.playerController.value.hasPlayed}");

            },
            onEnded: (data) {
              if(_controller.isRepeat){
                _controller.playerController.reload();
              }else{
                if(_controller.videoList.isNotEmpty){
                   _controller.playerController.load(_controller.videoList[(_controller.videoList.indexOf(data.videoId) + 1) % _controller.videoList.length]);
                   _showSnackBar('Next Video Started!');
                } else{
                  _controller.playerController.pause();
                  _controller.playerReady(true);
                  _controller.timerNotifier(false);
                }

              }


             // _controller.play();


             // _controller.play();
            //  _controller.playerController.value.webViewController;

           //   log("enddd ${_controller.playerController.value.hasPlayed}");
             // _controller.load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);_showSnackBar('Next Video Started!');
            },
          ),
          builder: (context, player) => Scaffold(
            // appBar: AppBar(
            //   leading: Padding(
            //     padding: const EdgeInsets.only(left: 12.0),
            //     child:Icon(Icons.video_camera_back,color: Colors.red.shade600,)
            //   ),
            //   title: Text(widget.title??"Video",
            //     style: const TextStyle(color: Colors.white),
            //   ),
            // ),
            body: SingleChildScrollView(
              child: SizedBox(
                height: size.height,
                child: ListView(
                  children: [
                    player,
                    _controller.fullScreen ?  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _space,
                          _text('Title', _controller.playerController.metadata.title==""?"Unknown":_controller.playerController.metadata.title),
                          _space,
                          _text('Channel', _controller.playerController.metadata.author==""?"Unknown":_controller.playerController.metadata.author),
                          // _space,
                          // _text('Video Id', _videoMetaData.videoId),
                          // _space,
                          // Row(
                          //   children: [
                          //     _text(
                          //       'Playback Quality',
                          //       _controller.value.playbackQuality ?? '',
                          //     ),
                          //     const Spacer(),
                          //     _text(
                          //       'Playback Rate',
                          //       '${_controller.value.playbackRate}x  ',
                          //     ),
                          //   ],
                          // ),
                          _space,
                          // TextField(
                          //   enabled: true,
                          //   controller: _idController,
                          //   decoration: InputDecoration(
                          //     border: InputBorder.none,
                          //     hintText: 'Enter youtube <video id> or <link>',
                          //     fillColor: Colors.blueAccent.withAlpha(20),
                          //     filled: true,
                          //     hintStyle: const TextStyle(
                          //       fontWeight: FontWeight.w300,
                          //       color: Colors.blueAccent,
                          //     ),
                          //     suffixIcon: IconButton(
                          //       icon: const Icon(Icons.clear),
                          //       onPressed: () => _idController.clear(),
                          //     ),
                          //   ),
                          // ),
                          // _space,
                          // Expanded(flex: 0,
                          //     child: _loadCueButton('LOAD')),
                          // // Row(
                          // //   children: [
                          // //     _loadCueButton('LOAD'),
                          // //     const SizedBox(width: 10.0),
                          // //     _loadCueButton('CUE'),
                          // //   ],
                          // // ),
                          // // _space,
                          // // Row(
                          // //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // //   children: [
                          // //     IconButton(
                          // //       icon: const Icon(Icons.skip_previous),
                          // //       onPressed: _isPlayerReady
                          // //           ? () => _controller.load(_ids[
                          // //       (_ids.indexOf(_controller.metadata.videoId) -
                          // //           1) %
                          // //           _ids.length])
                          // //           : null,
                          // //     ),
                          // //     IconButton(
                          // //       icon: Icon(
                          // //         _controller.value.isPlaying
                          // //             ? Icons.pause
                          // //             : Icons.play_arrow,
                          // //       ),
                          // //       onPressed: _isPlayerReady
                          // //           ? () {
                          // //         _controller.value.isPlaying
                          // //             ? _controller.pause()
                          // //             : _controller.play();
                          // //         setState(() {});
                          // //       }
                          // //           : null,
                          // //     ),
                          // //     IconButton(
                          // //       icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                          // //       onPressed: _isPlayerReady
                          // //           ? () {
                          // //         _muted
                          // //             ? _controller.unMute()
                          // //             : _controller.mute();
                          // //         setState(() {
                          // //           _muted = !_muted;
                          // //         });
                          // //       }
                          // //           : null,
                          // //     ),
                          //     FullScreenButton(
                          //       controller: _controller.playerController,
                          //       color: Colors.blueAccent,
                          //     ),
                          // //     IconButton(
                          // //       icon: const Icon(Icons.skip_next),
                          // //       onPressed: _isPlayerReady
                          // //           ? () => _controller.load(_ids[
                          // //       (_ids.indexOf(_controller.metadata.videoId) +
                          // //           1) %
                          // //           _ids.length])
                          // //           : null,
                          // //     ),
                          // //
                          // //     IconButton(
                          // //       icon: const Icon(Icons.skip_next),
                          // //       onPressed: (){
                          // //
                          // //         _controller.reset();
                          // //
                          // //           }
                          // //
                          // //     ),
                          // //
                          // //
                          // //   ],
                          // // ),
                          // _space,

                          // _text('Repeat', "ON"),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(onPressed: (){
                                _controller.repeat();
                              }, icon: _controller.isRepeat ? const Icon(Icons.repeat_on,color: Colors.blue,): const Icon(Icons.repeat)),

                              if (_controller.videoList.isNotEmpty && _controller.isPlayerReady) IconButton(
                                icon: Icon(Icons.skip_previous,color:_controller.playerController.metadata.videoId.toString()==_controller.getVideoId.toString()? Colors.black54 :  Colors.black,),
                                onPressed: _controller.isPlayerReady
                                    ? () {
                                  if(_controller.videoList.isNotEmpty){

                                    try {
                                      var vId=_controller.videoList[(_controller.videoList.indexOf(_controller.playerController.metadata.videoId))].toString();

                                      // log("rrr "+widget.url.toString());
                                      // log("rrr "+widget.videoList![(widget.videoList!.indexOf(_controller.playerController.metadata.videoId))].toString());

                                      if(vId!=_controller.getVideoId.toString()){

                                        _controller.playPrev(_controller.videoList);

                                        // _controller.playerController.reset();
                                        // _controller.playerController.load(_controller.videoList[(_controller.videoList.indexOf(_controller.playerController.metadata.videoId) -1) % _controller.videoList.length]);
                                        //
                                      }else{
                                        _showSnackBar("No previous video");
                                      }
                                    } on Exception catch (e) {
                                      // TODO
                                    }
                                  }
                                }
                                    : null,
                              ) else Container(),


                              IconButton(
                                icon: Icon(
                                  _controller.playerController.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                                onPressed: _controller.isPlayerReady
                                    ? () {

                                  _controller.play();

                                  // _controller.playerController.value.isPlaying
                                  //     ? _controller.playerController.pause()
                                  //     : _controller.playerController.play();

                                }
                                    : null,
                              ),



                              if (_controller.videoList.isNotEmpty && _controller.isPlayerReady) IconButton(
                                icon: Icon(Icons.skip_next,color: _controller.playerController.metadata.videoId.toString()==_controller.videoList.last.toString()?Colors.grey :Colors.black,),
                                onPressed: _controller.isPlayerReady
                                    ? () {
                                  if(_controller.videoList.isNotEmpty){
                                 try{
                                   var vId=_controller.videoList[(_controller.videoList.indexOf(_controller.playerController.metadata.videoId))].toString();

                                   // log("rrr "+widget.videoList![widget.videoList!.length-1].toString());
                                   // log("rrr "+widget.videoList![(widget.videoList!.indexOf(_controller.playerController.metadata.videoId))].toString());

                                   if(vId!=_controller.videoList.last.toString()){

                                     _controller.playNext(_controller.videoList);
                                     // _controller.playerController.pause();
                                     // _controller.playerController.load(_controller.videoList[(_controller.videoList.indexOf(_controller.playerController.metadata.videoId) +1) % _controller.videoList.length]);
                                     //
                                   }else{
                                     _showSnackBar("No next video");

                                   }
                                 }catch(e){}

                                  }
                                }
                                    : null,
                              ) else Container(),

                              IconButton(onPressed: (){
                                _controller.playerController.toggleFullScreenMode();
                                _showSnackBar("Not available");
                              }, icon: const Icon(Icons.fullscreen))

                              // FullScreenButton(
                              //   controller: _controller.playerController,
                              //   color: Colors.black,
                              // ),


                            ],
                          ),

                          //  _space,

                          Consumer<VideoPlayerProvider>(builder: (context,provider,_){
                            return Row(
                              children: <Widget>[
                                const SizedBox(width: 10.0,),
                                const Text(
                                  "V",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Slider(
                                    inactiveColor: Colors.transparent,
                                    value: provider.volume,
                                    min: 0.0,
                                    max: 100.0,
                                    divisions: 10,
                                    label: '${(provider.volume).round()}',
                                    onChanged: (value) {
                                      provider.playerController.setVolume(provider.volume.round());
                                      provider.setVolumes(value);
                                    },
                                  ),
                                ),

                                IconButton(
                                  icon: Icon(provider.muted ? Icons.volume_off : Icons.volume_up),
                                  onPressed:  () {
                                    provider.muted
                                        ? provider.playerController.unMute()
                                        : provider.playerController.mute();
                                    provider.setMuted();

                                  },
                                ),

                              ],
                            );
                          }),

                          _space,
                          // AnimatedContainer(
                          //   duration: const Duration(milliseconds: 800),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(20.0),
                          //     color: _getStateColor(_playerState),
                          //   ),
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text(
                          //     _playerState.toString(),
                          //     style: const TextStyle(
                          //       fontWeight: FontWeight.w300,
                          //       color: Colors.white,
                          //     ),
                          //     textAlign: TextAlign.center,
                          //   ),
                          // ),
                        ],
                      ),
                    ):Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black,
            //  fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  // Widget _loadCueButton(String action) {
  //   return Expanded(flex: 0,
  //     child: MaterialButton(
  //       color: Colors.green.shade500,
  //       onPressed: () {
  //         if (_controller.idController.text.isNotEmpty) {
  //           _controller.playerController.pause();
  //           var id = YoutubePlayer.convertUrlToId(
  //             _controller.idController.text,
  //           ) ??
  //               '';
  //           if (action == 'LOAD') _controller.load(id);
  //           if (action == 'CUE') _controller.cue(id);
  //           FocusScope.of(context).requestFocus(FocusNode());
  //         } else {
  //           _showSnackBar('Source can\'t be empty!');
  //         }
  //       },
  //       disabledColor: Colors.grey,
  //       disabledTextColor: Colors.black,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 14.0),
  //         child: Text(
  //           action,
  //           style: const TextStyle(
  //             fontSize: 18.0,
  //             color: Colors.white,
  //             fontWeight: FontWeight.w300,
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}