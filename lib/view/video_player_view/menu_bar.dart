import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../toast.dart';
import '../home_page.dart';

enum _PlayerMenuOptions {
  open,
  copy,
  play,
  playAll,
  fav
}
Future<void> _launchInBrowser(context, url) async {
  Uri uri=Uri.parse(url);
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    toast(context, "Could not open");
    throw Exception('Could not launch $url');
  }
}
class HomePlayerMenu extends StatelessWidget {
  final String url;
  final String id;
  final Set<String> isFav;
  final Function() play;
  final Function() playAll;
  final Function() addFav;
  const HomePlayerMenu({super.key, required this.url,required this.isFav ,required this.id,required this.play, required this.playAll, required this.addFav});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_PlayerMenuOptions>(
      position: PopupMenuPosition.under,
      onSelected: (value) async {
        switch (value) {
          case _PlayerMenuOptions.open:
            _launchInBrowser(context,url);
            break;
          case _PlayerMenuOptions.copy:
            await Clipboard.setData(ClipboardData(text: url));
            break;
          case _PlayerMenuOptions.play:
           play();
            break;
          case _PlayerMenuOptions.playAll:
            playAll();
            break;
          case _PlayerMenuOptions.fav:
            addFav();
            break;
        }
      },
      itemBuilder: (context) => [
      const PopupMenuItem<_PlayerMenuOptions>(
          value: _PlayerMenuOptions.play,
          child: Text('Play'),
        ),  const PopupMenuItem<_PlayerMenuOptions>(
          value: _PlayerMenuOptions.playAll,
          child: Text('Play All'),
        ),   PopupMenuItem<_PlayerMenuOptions>(
          value: _PlayerMenuOptions.fav,
          child: Text( isFav.contains(id)? "Remove Favourite":"Add Favourite",style: TextStyle( color: isFav.contains(id)? Colors.red.withOpacity(0.8) :Colors.black,),),
        ),
        const PopupMenuItem<_PlayerMenuOptions>(
          value: _PlayerMenuOptions.open,
          child: Text('Open in browser'),
        ),
        const PopupMenuItem<_PlayerMenuOptions>(
          value: _PlayerMenuOptions.copy,
          child: Text('Copy link'),
        ),


      ],
    );
  }
}
