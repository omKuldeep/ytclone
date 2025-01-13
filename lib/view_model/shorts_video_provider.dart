import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ShortVideoProvider extends ChangeNotifier{

  late InAppWebViewController _webViewController;
   InAppWebViewController get webViewController=>_webViewController;

  String url = "https://www.youtube.com/shorts/";
  double progress = 0;
  bool _isLoading=true;
  bool get isLoading=>_isLoading;

  void setLoading(bool value){
    log("message");
    _isLoading=value;
    notifyListeners();
  }

  void initWebView(controller){
     _webViewController = controller;
     _webViewController.addJavaScriptHandler(handlerName:'handlerFoo', callback: (args) {
       // return data to JavaScript side!
       return {
         'bar': 'bar_value', 'baz': 'baz_value'
       };
     });
     _webViewController.addJavaScriptHandler(handlerName: 'handlerFooWithArgs', callback: (args) {
       //  print(args);
       // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
     });
  }

  void disposeData(){
    _isLoading=true;
    _webViewController.pause();
    _webViewController.pauseAllMediaPlayback();
    _webViewController.clearHistory();
    _webViewController.closeAllMediaPresentations();
    InAppWebViewController.clearAllCache();
    _webViewController.stopLoading();
    _webViewController.dispose();
  }

}