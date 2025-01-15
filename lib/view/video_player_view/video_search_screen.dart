
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kio_chat/view/video_player_view/enum.dart';
import 'package:kio_chat/view/video_player_view/fav_songs.dart';
import 'package:kio_chat/view_model/favourite_provider.dart';
import 'package:kio_chat/view_model/video_player_provider.dart';
import 'package:kio_chat/view/video_player_view/video_player_screen.dart';
import 'package:provider/provider.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../model/favouriteModel.dart';
import '../../toast.dart';
import '../yt_shorts/CommonWebView.dart';
import 'menu_bar.dart';


class VideoSearchScreen extends StatefulWidget {
  const VideoSearchScreen({super.key});

  @override
  State<VideoSearchScreen> createState() => _VideoSearchScreenState();
}

class _VideoSearchScreenState extends State<VideoSearchScreen> with TickerProviderStateMixin {

  final textController=TextEditingController();
  var videoPlayerProvider;
  late AnimationController controller;
  late FavouriteProvider favouriteProvider;

  DateTime now=DateTime.now();

  void initController(){
    controller = BottomSheet.createAnimationController(this);
    controller.duration = const Duration(milliseconds: 500);
    controller.reverseDuration = const Duration(milliseconds: 500);
    context.read<FavouriteProvider>().initBox();

    Future.delayed(const Duration(seconds: 1),(){
      context.read<VideoPlayerProvider>().searchVideo("trending new hindi songs ${now.year}");
    });
  }
  @override
  void initState() {
    initController();

   // WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  disposes()async{
    await DefaultCacheManager().emptyCache();
  }
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    if(videoPlayerProvider!=null && videoPlayerProvider.showPlayer ){
      videoPlayerProvider.playerController.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    videoPlayerProvider.playerController.dispose();
    controller.dispose();
    disposes();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.sizeOf(context);
    favouriteProvider=Provider.of<FavouriteProvider>(context,listen: false);
    return Consumer<VideoPlayerProvider>(builder: (context,provider,_){
      return Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){
            if(provider.showPlayer || provider.isPlayerReady){
              provider.playerController.pause();
            }
            Navigator.push(context, MaterialPageRoute(builder: (_)=>const ShortVideos())).then((onValue){
              if(provider.showPlayer || provider.isPlayerReady){
                provider.playerController.play();
              }
            });
          },
              icon: const Icon(Icons.play_circle_outline_sharp)),
          elevation: 0,
          // title: Text(provider.isFavSheetOpen? "Favourite Songs":"KIO"),
          title: const Text("KIO"),
          backgroundColor: Colors.yellow.shade300,foregroundColor:Colors.black,centerTitle: true,
        actions: [
         Padding(
           padding: const EdgeInsets.all(8.0),
           child:IconButton(onPressed: (){
             FocusScope.of(context).requestFocus(FocusNode());
          provider.setFavSheetHeight(size.height);

          showModalBottomSheet(
            useSafeArea: true,
              isScrollControlled: true,
              isDismissible: true,
              backgroundColor: Colors.transparent,
              enableDrag: false,
              elevation: 0,
              transitionAnimationController: controller,
              context: context, builder: (context){

            return Consumer<VideoPlayerProvider>(builder: (context,v,_){
              return Container(
                  padding: EdgeInsets.only(bottom: v.showPlayer? 100.0:0.0),
                  height: v.bottomFavSheetHeight,
                  child: FavSongs(ctx: _context,provider: provider,controller: controller,),

                  // child: Column(
                  //   children: [
                  //     SizedBox(height: 40.0,
                  //       child: Row(mainAxisAlignment: MainAxisAlignment.end,
                  //         children: [
                  //           //  Container(width: 60,),
                  //           // v.isPlayerReady? IconButton(onPressed: (){
                  //           //   try {
                  //           //     if(v.isPlayerReady){
                  //           //       v.changeFavSheetHeight(size);
                  //           //     }else{
                  //           //      Navigator.pop(context);
                  //           //      provider.openFavSheet(false);
                  //           //     }
                  //           //   } on Exception catch (e) {
                  //           //     log(e.toString());
                  //           //   }
                  //           // }, icon: Icon( v.bottomFavSheetHeight==140.0? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down)):
                  //           // IconButton(onPressed: (){
                  //           //   if (Navigator.canPop(context)) {
                  //           //     Navigator.pop(context);
                  //           //   }
                  //           //   provider.playAllList(false,false);
                  //           // }, icon: const Icon(Icons.keyboard_arrow_down,color: Colors.black,)),
                  //
                  //           TextButton(onPressed: () async {
                  //
                  //             //  provider.initController(videoId, vList);
                  //             await favouriteProvider.playAll(context,size,provider,controller).then((value){
                  //
                  //               if (value.isNotEmpty) {
                  //                 provider.initController(value[0], value);
                  //                 provider.showPlayerBottom(true);
                  //                 log(value.toString());
                  //               }
                  //             });
                  //
                  //           }, child: const Text("Play All"))
                  //
                  //         ],
                  //       ),
                  //     ),
                  //     Expanded(child: FavSongs(ctx: _context,provider: provider,controller: controller,)),
                  //   ],
                  // )

              );
            });

          }).whenComplete((){
            provider.openFavSheet(false);
            log("message");
          });
             // Scaffold.of(_context!).showBottomSheet(
             //   enableDrag: false,
             //     backgroundColor: Colors.transparent,
             //     transitionAnimationController: controller,
             //     (context){
             //       return Consumer<VideoPlayerProvider>(builder: (context,v,_){
             //         return Container(
             //           margin: EdgeInsets.only(bottom: v.showPlayer? 100.0:0.0),
             //             height: v.bottomFavSheetHeight,
             //             child: Column(
             //               children: [
             //                 SizedBox(height: 40.0,
             //                   child: Row(mainAxisAlignment: MainAxisAlignment.end,
             //                     children: [
             //                     //  Container(width: 60,),
             //                       // v.isPlayerReady? IconButton(onPressed: (){
             //                       //   try {
             //                       //     if(v.isPlayerReady){
             //                       //       v.changeFavSheetHeight(size);
             //                       //     }else{
             //                       //      Navigator.pop(context);
             //                       //      provider.openFavSheet(false);
             //                       //     }
             //                       //   } on Exception catch (e) {
             //                       //     log(e.toString());
             //                       //   }
             //                       // }, icon: Icon( v.bottomFavSheetHeight==140.0? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down)):
             //                       // IconButton(onPressed: (){
             //                       //   if (Navigator.canPop(context)) {
             //                       //     Navigator.pop(context);
             //                       //   }
             //                       //   provider.playAllList(false,false);
             //                       // }, icon: const Icon(Icons.keyboard_arrow_down,color: Colors.black,)),
             //
             //                     TextButton(onPressed: () async {
             //
             //                     //  provider.initController(videoId, vList);
             //                      await favouriteProvider.playAll(context,size,provider,controller).then((value){
             //
             //                        if (value.isNotEmpty) {
             //                          provider.initController(value[0], value);
             //                          provider.showPlayerBottom(true);
             //                          log(value.toString());
             //                        }
             //                       });
             //
             //                     }, child: const Text("Play All"))
             //
             //                     ],
             //                   ),
             //                 ),
             //                 Expanded(child: FavSongs(ctx: _context,provider: provider,controller: controller,)),
             //               ],
             //             ));
             //       });
             //     }
             // );

             provider.openFavSheet(true);

         //   Navigator.push(context, MaterialPageRoute(builder: (_)=> FavSongs(ctx: _context,provider: provider,controller: controller,)));

           },
               icon: const Icon(Icons.favorite_border,color: Colors.black,size: 30,))

         )


        ],
        ),
        backgroundColor: Colors.yellow.shade300,
        body: ShowVideoPlayer(textController: textController,size: size, provider: provider, controller: controller,favProvider:favouriteProvider),


      );
    });
  }

}


showPlayerDialog(context,size,title,url, channelTitle, VideoPlayerProvider provider, AnimationController controller, {List<String>? videoList}){

  Scaffold.of(context).showBottomSheet(
    transitionAnimationController: controller,
    shape: const RoundedRectangleBorder(),
    backgroundColor: Colors.black87,
        (BuildContext context) {
      return Consumer<VideoPlayerProvider>(builder: (context,value,_){
        return  GestureDetector(
          onTapUp: (v){
            if(!provider.fullScreen){
              provider.changeBottomSheetHeight(size);
            }
          },
          child: Container(
              height: provider.bottomSheetHeight,
              width: size.width,
              color: Colors.transparent,
              // child: MyHomePage(title:url,),
              child:  Stack(
                alignment: Alignment.topRight,
                children: [

                  if (value.fullScreen) Container() else Positioned(
                    height: 100,
                    left: 200,
                    child: value.isPlayerReady? IconButton(onPressed: (){
                      value.play();
                    }, icon: Icon(value.isPlay ?Icons.pause :Icons.play_arrow,color: Colors.white,size: 60,)):
                    const Center(child: CircularProgressIndicator(color: Colors.white,)),
                  ),

                  Positioned(
                    height: 100,width: 100,
                    left: 260,
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(onPressed: (){
                          value.repeat();
                        }, icon: value.isRepeat ? const Icon(Icons.repeat,color: Colors.blue,): const Icon(Icons.repeat,color: Colors.grey,)),

                        value.isPlayerReady ? FullScreenButton(
                          controller: value.playerController,
                          color: Colors.white,
                        ):Container(),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                        width: value.fullScreen?null:180,
                        child: VideoPlayerScreen(title:title, url: url, fullScreen:provider.fullScreen, provider: provider,channel:channelTitle,videoList:videoList)
                    ),

                  ),

                  Container(
                    margin: const EdgeInsets.only(right: 40.0),
                    child: IconButton(onPressed: (){
                      provider.changeBottomSheetHeight(size);
                    }, icon: Icon(provider.fullScreen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 36,color: Colors.white70,)),
                  ),
                  IconButton(onPressed: (){
                    provider.playerController.pause();
                    if(provider.isFavSheetOpen && provider.bottomFavSheetHeight==140.0){

                      log("ddddd");
                      Navigator.pop(context);
                      provider.playAllList(false,false);
                    }else{
                      log("aaaaa");
                      Navigator.pop(_context!);
                      provider.playAllList(false,false);
                    }
                  }, icon: const Icon(Icons.close,size: 26,color: Colors.white70,)),

                ],
              )
          ),
        );
      });
    },

  );

}

int? _selectedIndex;
BuildContext? _context;


class ShowVideoPlayer extends StatelessWidget {
  final TextEditingController textController;
  final Size size;
  final VideoPlayerProvider provider;
  final AnimationController  controller;
  final FavouriteProvider favProvider;

   ShowVideoPlayer({super.key, required this.textController,required this.size, required this.provider, required this.controller, required this.favProvider,});


  var title="";
  var url="";
  var channel="";
  var list=[];

  
  @override
  Widget build(BuildContext context) {

    _context=context;
    return SizedBox(
      height: size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Trending hindi songs",
                            
                            suffix: InkWell(
                                onTap: (){
                                  textController.clear();
                                },
                                child: const Icon(Icons.close,color: Colors.blue,))
                          ),
                          controller: textController,
                        ),
                      ),
                    ),
                  ),
                  Flexible(flex: 0,
                    child: Card(elevation: 5,
                      child: IconButton(onPressed: (){
                        var input=textController.text.trim();
                        if(input.isNotEmpty){
                          FocusScope.of(context).requestFocus(FocusNode());

                          provider.searchVideo(input.toString());
                        }
                      }, icon: const Icon(Icons.search,color: Colors.blueGrey,)),
                    ),
                  ),
                ],
              ),
            ),

                    Expanded(
                    child: provider.response.isNotEmpty?  Padding(
                    padding: const EdgeInsets.all(2.0),
                       child: provider.response[0].status == Status.complete ? provider.response[0].data!.isNotEmpty ?
                       ListView.builder(
                       shrinkWrap: true,
                       itemCount: provider.response[0].data?.length,
                       itemBuilder: (context,index){
                         YouTubeVideo? video=provider.response[0].data?[index];

                         print(provider.response[0].data?.length);

                         var title=video!.title.toString();
                        var id=video.id;
                        var url=video.url.toString();
                        var thumb=video.thumbnail.small.url.toString();
                        var dur=video.duration;
                        return Padding(
                          padding: EdgeInsets.only(bottom:provider.isPlayerReady && provider.response[0].data!.length-1==index? 100.0:5.0),
                          child: Card(elevation: 4,
                               child: ListTile(titleAlignment: ListTileTitleAlignment.center,
                                   contentPadding: const EdgeInsets.only(left: 15.0,top: 10.0,bottom: 10.0),
                                   minLeadingWidth: 0,minTileHeight: 0,

                                 // selected: favProvider.selectedIndexes.contains(id),
                                 // selectedTileColor: Colors.blue.withOpacity(0.5),
                                 //
                                   onTap: (){
                                     log(url.toString());

                                     if(url.startsWith("https://www.youtube.com/playlist?")){
                                // log(video.url.toString());
                                toast(context, "This is video playlists");
                                // Navigator.push(context, MaterialPageRoute(builder: (_)=>MyHomePage(title: video.url.toString(),)));
                                    }else if(url.startsWith("https://www.youtube.com/watch?v=")){
                                // _bottomSheetHeight=size.height;
                                // fullScreen=true;
                                //  playerBottomSheet(size,video.url.toString().split("=")[1].toString(),video.title.toString());
                                // Navigator.push(context, MaterialPageRoute(builder: (_)=>MyHomePage(title: video.url.toString().split("=")[1].toString(),)));

                                if(Navigator.canPop(context)){
                                  Navigator.pop(context);
                                }   log("cccc "+video.channelTitle);
                                var videoUrl=id;
                                if(id==null){

                                  videoUrl=url.toString().split("=")[1].toString();
                                } _selectedIndex=index;



                                provider.initController(videoUrl,[]);
                                provider.showPlayerBottom(true);
                               // showPlayerDialog(_context,size,title,videoUrl,video.channelTitle,provider,controller,videoList: []);

                                }else{
                                toast(context, "Video unsupported");
                                     }
                               },
                                  leading: SizedBox(height: 80,width: 70,
                                     child: Image.network(thumb,width: 70,height: 80,fit: BoxFit.fitHeight,loadingBuilder: (context,child,loadingProgress){
                                      if (loadingProgress == null) return child;
                                       return const Center(
                                         child: CircularProgressIndicator(color: Colors.yellow,),
                                     );
                                   },),
                                        ),
                                    title: Text(title,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color:provider.isPlayerReady? provider.playerController.metadata.videoId.toString()==id? Colors.blue:Colors.black87:Colors.black87),),
                                    subtitle: Text(dur??video.channelTitle.toString(),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                   trailing: HomePlayerMenu(url: url,isFav:favProvider.selectedIndexes,id: id!,play: () {
                                      var videoUrl=id;
                                      if(id==null){
                                        videoUrl=url.toString().split("=")[1].toString();
                                      } _selectedIndex=index;
                                      provider.initController(videoUrl,[]);
                                      provider.showPlayerBottom(true);

                                    //  showPlayerDialog(_context,size,title,videoUrl,video.channelTitle,provider,controller,videoList: []);

                                    }, playAll: () {
                                      try {
                                        _selectedIndex=index;
                                        var data=provider.response[0].data;
                                        List<String> videoList=[];

                                        for(var i=index; i < data!.length; i++){

                                          if(data[i].url.startsWith("https://www.youtube.com/watch?v=")){
                                            videoList.add(data[i].id!);
                                          }
                                          // log(item.toString());
                                        }

                                        if (videoList.isNotEmpty) {
                                          provider.initController(videoList[0],videoList);
                                          provider.showPlayerBottom(true);
                                        }

                                      //  provider.playAllList(true,false);
                                      //  showPlayerDialog(_context,size,data[index].title,data[index].id,data[index].channelTitle,provider,controller,videoList:videoList);

                                      } on Exception catch (e) {
                                        toast(context, "Error while playing");
                                      }

                                    }, addFav: () async {

                                    //  log("idd "+video.thumbnail.small.url.toString());


                                     if(favProvider.selectedIndexes.contains(id)){
                                       favProvider.removeFavourite(context, id);
                                     }else{
                                       FavouriteModel addModel = FavouriteModel(
                                         title: title,
                                         url: url,
                                         channel: video.channelId,
                                         thumb: thumb,
                                         id: id,
                                         duration: dur,
                                         desc: video.description,
                                         chanelUrl: video.channelUrl,
                                       );
                                       favProvider.addFav(context, addModel,id);
                                     }
                                    },),
                                       ),
                                     ),
                                 );
                            }):const Text("No Video Found"):
                      provider.response[0].status==Status.loading? const Center(child: CircularProgressIndicator(color: Colors.blue,)) :
                       Text(provider.response[0].message.toString())
                         ) :const Text("Search video")),

                  BottomAppBar(height: provider.showPlayer ? provider.bottomSheetHeight:0.0,
                    color: Colors.transparent,
                   elevation: 0,

                   child: Consumer<VideoPlayerProvider>(builder: (context,val,_){
                     return val.showPlayer? GestureDetector(
                       onTapUp: (v){
                         if(!val.fullScreen){
                           val.changeBottomSheetHeight((MediaQuery.of(context).size.height-45) - (kToolbarHeight + kBottomNavigationBarHeight));
                         }
                       },
                       child: Container(
                         // height: provider.bottomSheetHeight,
                           width: size.width,

                           color: Colors.black87,
                           // child: MyHomePage(title:url,),
                           child:  Stack(
                             alignment: Alignment.topRight,
                             children: [

                               if (val.fullScreen) Container() else Positioned(
                                 height: 100,
                                 left: 200,
                                 child: val.isPlayerReady ? IconButton(onPressed: (){
                                   val.play();
                                 }, icon: Icon(val.playerController.value.isPlaying ? Icons.pause :Icons.play_arrow,color: Colors.white,size: 60,)):
                                 const Center(child: CircularProgressIndicator(color: Colors.white,)),
                               ),

                               Positioned(
                                 height: 100,width: 100,
                                 left: 260,
                                 child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     IconButton(onPressed: (){
                                       val.repeat();
                                     }, icon: val.isRepeat ? const Icon(Icons.repeat,color: Colors.blue,): const Icon(Icons.repeat,color: Colors.grey,)),


                                    val.isPlayerReady && val.videoList.length>1 ? IconButton(onPressed: (){
                                       if (val.videoList.length>1) {
                                         val.playNext(val.videoList);
                                       }
                                     }, icon: const Icon(Icons.skip_next,color: Colors.white,)):Container()

                                     // val.isPlayerReady ? FullScreenButton(
                                     //   controller: val.playerController,
                                     //   color: Colors.white,
                                     // ):Container(),
                                   ],
                                 ),
                               ),

                               Align(
                                 alignment: Alignment.centerLeft,
                                 child: SizedBox(
                                     width: val.fullScreen?null:180,
                                     child: VideoPlayerScreen(title:title, url: url, fullScreen:val.fullScreen, provider: val,channel:"channelTitle",videoList:[])
                                 ),
                               ),

                               Container(
                                 margin: const EdgeInsets.only(right: 40.0),
                                 child: IconButton(onPressed: (){
                                   val.changeBottomSheetHeight(MediaQuery.of(context).size.height - (kToolbarHeight + kBottomNavigationBarHeight+22));
                                 }, icon: Icon(val.fullScreen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 36,color: Colors.white70,)),
                               ),
                               IconButton(onPressed: (){
                                 val.playerController.pause();
                                 val.playAllList(false,false);
                                 // if(provider.isFavSheetOpen && provider.bottomFavSheetHeight==140.0){
                                 //
                                 //   log("ddddd");
                                 //  // Navigator.pop(context);
                                 //
                                 //   provider.playAllList(false,false);
                                 // }else{
                                 //   log("aaaaa");
                                 //  // Navigator.pop(_context!);
                                 //   provider.playAllList(false,false);
                                 // }
                               }, icon: const Icon(Icons.close,size: 26,color: Colors.white70,)),

                             ],
                           )
                       ),
                     ):Container();
                   })


                //  child:VideoPlayerScreen(title: title, url: url, fullScreen: provider.fullScreen, provider: provider, channel: channel, videoList: []):Container(child: Text("data"),)

            )
          ],
        ),
      ),
    );
  }
}

