
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kio_chat/view_model/shorts_video_provider.dart';
import 'package:provider/provider.dart';

class ShortVideos extends StatefulWidget {
  const ShortVideos({super.key});

  @override
  State<ShortVideos> createState() => _ShortVideosState();
}

class _ShortVideosState extends State<ShortVideos> {

  ShortVideoProvider shortVideoProvider=ShortVideoProvider();

  // late InAppWebViewController _webViewController;
  // String url = "https://www.youtube.com/shorts/6rRXkmlbbjU";
  // double progress = 0;
  // bool isLoading=false;

  @override
  void dispose() {
  shortVideoProvider.webViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    shortVideoProvider=Provider.of<ShortVideoProvider>(context,listen: false);
    return Scaffold(backgroundColor: Colors.yellow.shade300,
      // appBar: AppBar(title: const Text("Shorts"),
      //   backgroundColor: Colors.yellow.shade300,
      //   elevation: 0,centerTitle: true,
      //   foregroundColor: Colors.black,
      // ),
      body:Consumer<ShortVideoProvider>(builder: (context,provider,_){
      return  Stack(
        alignment: Alignment.centerLeft,
        children: [

            InAppWebView(
              //                   initialData: InAppWebViewInitialData(data:
              //                   """
              // <!DOCTYPE html>
              // <html lang="en">
              //     <head>
              //         <meta charset="UTF-8">
              //         <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
              //     </head>
              //     <body>
              //         <h1>JavaScript Handlers (Channels) TEST</h1>
              //         <script>
              //             window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
              //                 window.flutter_inappwebview.callHandler('handlerFoo')
              //                   .then(function(result) {
              //                     // print to the console the data coming
              //                     // from the Flutter side.
              //                     console.log(JSON.stringify(result));
              //
              //                     window.flutter_inappwebview
              //                       .callHandler('handlerFooWithArgs', 1, true, ['bar', 5], {foo: 'baz'}, result);
              //                 });
              //             });
              //         </script>
              //     </body>
              // </html>
              //                       """,
              //                   ),

              initialUrlRequest: URLRequest(
                  url: WebUri.uri(Uri.parse(provider.url))),

              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useWideViewPort: true,
                mediaPlaybackRequiresUserGesture: false,
                supportMultipleWindows: true,
                disableContextMenu: true,
              ),

              onWebViewCreated: (InAppWebViewController controller) {
                controller.startSafeBrowsing();
                provider.initWebView(controller);
              },

              onConsoleMessage: (controller, consoleMessage) {
                //  print(consoleMessage);
                // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
              },

              //
              onLoadStart: (InAppWebViewController controller,  url) {
                InAppWebViewSettings  settings = InAppWebViewSettings(
                  javaScriptEnabled: true,
                  mediaPlaybackRequiresUserGesture: false,
                  preferredContentMode: UserPreferredContentMode.MOBILE,
                  useHybridComposition: true,
                  allowsInlineMediaPlayback: true,
                );

                controller.setSettings(settings: settings);
                // controller.isInFullscreen();
                controller.evaluateJavascript(source: 'document.getElementById("elementId").innerText');

              },
              //
              onLoadStop: (InAppWebViewController controller,  url) async {
               provider.setLoading(false);
              },

              // onProgressChanged: (InAppWebViewController controller, int progress) {
              //   setState(() {
              //     this.progress = progress / 100;
              //
              //     log("message");
              //   });
              // },
            ),
          provider.isLoading ? const Center(
            child: CircularProgressIndicator(color: Colors.lightBlue,),
          ) : Positioned(height: 40,width: 40,
            top: 20.0,
            child: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back,color: Colors.black54,size: 40,)),
          ),
        ],
      );
      })

      // Container(
      //
      //   padding: const EdgeInsets.all(20.0),
      //
      //   child: Text(
      //
      //       "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"
      //
      //   ),
      //
      // ),

      // Container(
      //     padding: const EdgeInsets.all(10.0),
      //     child: progress < 1.0
      //         ? LinearProgressIndicator(value: progress)
      //         : Container()),


      // OverflowBar(
      //
      //   alignment: MainAxisAlignment.center,
      //
      //   children: <Widget>[
      //
      //     IconButton(
      //
      //       icon: const Icon(Icons.arrow_back),
      //
      //       onPressed: () {
      //
      //         if (_webViewController != null) {
      //
      //           _webViewController.goBack();
      //
      //         }
      //
      //       },
      //
      //     ),
      //
      //     IconButton(
      //
      //       icon: const Icon(Icons.arrow_forward),
      //
      //       onPressed: () {
      //
      //         if (_webViewController != null) {
      //
      //           _webViewController.goForward();
      //
      //         }
      //
      //       },
      //
      //     ),
      //
      //     IconButton(
      //
      //       icon: const Icon(Icons.refresh),
      //
      //       onPressed: () {
      //
      //         if (_webViewController != null) {
      //
      //           _webViewController.reload();
      //
      //         }
      //
      //       },
      //
      //     ),
      //
      //   ],
      //
      // ),

    );
  }


}
