
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kio_chat/view/video_player_view/video_search_screen.dart';
import 'package:kio_chat/view_model/shorts_video_provider.dart';
import 'package:kio_chat/view_model/video_player_provider.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver{

  //final  FirebaseAuth _auth=FirebaseAuth.instance;

  void getCurrentUser() async {
    //final user = await _auth.currentUser;
    Future.delayed(const Duration(seconds: 2),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const VideoSearchScreen()));

    //   log(user.toString());
    //   try {
    //     if (user != null) {
    //
    //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const VideoSearchScreen()));
    //
    //       print(user.email);
    //     }else{
    //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
    //     }
    //   } catch (e) {
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
    //   }
     });
  }


  VideoPlayerProvider videoPlayerProvider=VideoPlayerProvider();
  ShortVideoProvider shortVideoProvider=ShortVideoProvider();


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if(videoPlayerProvider.showPlayer || videoPlayerProvider.isPlayerReady ){
          videoPlayerProvider.playerController.play();
        }
        if(!shortVideoProvider.isLoading){
          shortVideoProvider.webViewController.resume();
        }

        log('Back to app');
        break;
      case AppLifecycleState.paused:
        log('App minimised or Screen pause');
        if(videoPlayerProvider.showPlayer || videoPlayerProvider.isPlayerReady){
         // videoPlayerProvider.playerController.pause();
        }
        if(!shortVideoProvider.isLoading){
          shortVideoProvider.webViewController.pause();
        }

        break;
      case AppLifecycleState.detached:
        log('App minimised or Screen det');
        if(videoPlayerProvider.showPlayer || videoPlayerProvider.isPlayerReady){
          videoPlayerProvider.playerController.pause();
          videoPlayerProvider.playerController.dispose();
        }

        if(!shortVideoProvider.isLoading){
          shortVideoProvider.webViewController.dispose();
        }
        WidgetsBinding.instance.removeObserver(this);
        break;
      case AppLifecycleState.inactive:
        log('App minimised or Screen ina');
        if(videoPlayerProvider.showPlayer || videoPlayerProvider.isPlayerReady){
         // videoPlayerProvider.playerController.pause();

        }
        break;
      case AppLifecycleState.hidden:
        if(videoPlayerProvider.showPlayer || videoPlayerProvider.isPlayerReady){
        //  videoPlayerProvider.playerController.pause();
        }

        if(!shortVideoProvider.isLoading){
          shortVideoProvider.webViewController.pause();
        }

        log('App minimised or Screen hide');
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getCurrentUser();
    super.initState();
  }
  @override
  void dispose() {
   // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    videoPlayerProvider=Provider.of<VideoPlayerProvider>(context,listen: false);
    shortVideoProvider=Provider.of<ShortVideoProvider>(context,listen: false);
    return const Scaffold(
      body:Center(
        child: Text("Welcome Back!"),
      ),
    );
  }
}
