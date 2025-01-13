import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kio_chat/toast.dart';
import 'package:kio_chat/view/video_player_view/video_search_screen.dart';
import 'package:kio_chat/view_model/favourite_provider.dart';
import 'package:kio_chat/view_model/video_player_provider.dart';
import 'package:provider/provider.dart';

class FavSongs extends StatefulWidget {
  final BuildContext? ctx;
  final provider;
  final controller;
  const FavSongs({super.key, required this.ctx, this.provider, this.controller});

  @override
  State<FavSongs> createState() => _FavSongsState();
}

class _FavSongsState extends State<FavSongs> {

  late FavouriteProvider provider;
  late VideoPlayerProvider videoPlayerProvider;

  @override
  void initState() {
    //context.read<FavouriteProvider>().getVideos();
    super.initState();
  }

  var crossAxisCount=1;
  var boxWidth=100.0;


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.sizeOf(context);
    log(size.width.toString());
    if(size.width<=320){
      crossAxisCount=1;
      boxWidth=size.width*0.6;
    }else if(size.width<=720){
      crossAxisCount=2;
      boxWidth=size.width*0.4;
    }else if(size.width<=1080){
      crossAxisCount=3;
      boxWidth=size.width*0.35;
    }else if(size.width>1080){
      crossAxisCount=4;
      boxWidth=size.width*0.3;
    }

    videoPlayerProvider=Provider.of<VideoPlayerProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Favourite Songs",),centerTitle: true,
      backgroundColor: Colors.yellow.shade300,elevation: 0,
      foregroundColor: Colors.black,
      leadingWidth: 80,
      leading:TextButton(onPressed: (){
        try {
          var data=videoPlayerProvider.response[0].data;
          List<String> videoList=[];

          for(var i=0; i < data!.length; i++){

            if(data[i].url.startsWith("https://www.youtube.com/watch?v=")){
              videoList.add(data[i].id!);
            }
            // log(item.toString());
          }

          if (videoList.isNotEmpty) {
            videoPlayerProvider.initController(videoList[0],videoList);
            videoPlayerProvider.showPlayerBottom(true);
          }

          //  provider.playAllList(true,false);
          //  showPlayerDialog(_context,size,data[index].title,data[index].id,data[index].channelTitle,provider,controller,videoList:videoList);

        } on Exception catch (e) {
          toast(context, "Error while playing");
        }
      }, child: const Text("Play All",style: TextStyle(color: Colors.black),)),
      actions: [
          IconButton(onPressed: (){
        Navigator.pop(context);
        }, icon: const Icon(Icons.close,color: Colors.black,)),

      ],),
      body: Consumer<FavouriteProvider>(builder: (context,provider,_){



        return ValueListenableBuilder(valueListenable: provider.box.listenable(),
            builder: (context,Box box,_){
              final Map<String, dynamic> profileMap = {};
              for (var item in box.values.toList()) {
                profileMap[item.id!] = item;
              }
            //  videoList = profileMap.values.toList();

              return Padding(
                padding: const EdgeInsets.all(10),
                child: profileMap.values.toList().isNotEmpty ? GridView.builder(
                    itemCount: profileMap.values.toList().length,
                    shrinkWrap: true,
                    cacheExtent: 50,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      // mainAxisExtent: size.width*0.4+50
                    ),
                    itemBuilder: (context,index){


                      //
                      // log(videoList.length.toString());

                      var videos = profileMap.values.toList()[index];
                      log(videos.id.toString());

                      return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  if(videos.id!=null){
                                    videoPlayerProvider.initController(videos.id.toString(), []);
                                    videoPlayerProvider.showPlayerBottom(true);
                                    //  showPlayerDialog(context,size,videos.title,videos.id,videos.channel,widget.provider,widget.controller,videoList:[]);
                                  }else{
                                    toast(context, "error");
                                  }
                                }, child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    decoration: const BoxDecoration(
                                      // image: DecorationImage(image: NetworkImage(videos.thumb.toString()))
                                    ),

                                    child: CachedNetworkImage(
                                      width: boxWidth,height: boxWidth*0.6,
                                      imageUrl: videos.thumb,
                                      fit: BoxFit.fitWidth,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                      errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                                    ),

                                    // child: Image.network(videos.thumb??"https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg",width: boxWidth,height: boxWidth*0.6,fit: BoxFit.fitWidth,loadingBuilder: (context,child,loadingProgress){
                                    //   if (loadingProgress == null) return child;
                                    //   return const Center(
                                    //     child: CircularProgressIndicator(color: Colors.yellow,),
                                    //   );
                                    // },),


                                  ),

                                  ListTile(minTileHeight: 0,minLeadingWidth: 0,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    title: Text(videos.title ??"Unknown",maxLines: 2,overflow: TextOverflow.ellipsis,),
                                    subtitle: Text(videos.duration??"",maxLines: 1,),

                                  )

                                ],
                              ),
                              ),
                              IconButton(onPressed: (){
                                provider.removeFavourite(context,videos.id!);
                              }, icon: const Icon(Icons.favorite,color: Colors.red,)),
                            ],
                          ));
                    }):
                const Center(
                  child: Text("No Favourite Videos"),
                ),
              );
            });
      }),
    );
  }
}
