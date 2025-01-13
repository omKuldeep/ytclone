import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeShorts extends StatefulWidget {
  const YoutubeShorts({super.key});

  @override
  State<YoutubeShorts> createState() => _YoutubeShortsState();
}

class _YoutubeShortsState extends State<YoutubeShorts> {

  late WebViewController _controller;


  @override
  void initState() {

    InAppWebViewSettings  settings = InAppWebViewSettings(

      javaScriptEnabled: true,
      mediaPlaybackRequiresUserGesture: false,
      preferredContentMode: UserPreferredContentMode.MOBILE,
      useHybridComposition: true,
      allowsInlineMediaPlayback: true,

    );


    _controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://www.youtube.com/shorts/6rRXkmlbbjU'),
      ) ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor( Colors.yellow.shade300)
      ..setNavigationDelegate( // Set navigation event handlers
        NavigationDelegate(
          // Called when a new page starts loading
          onPageStarted: (url) {
            setState(() {
             // isLoading = true; // Show loading indicator when page starts loading
            });
          },
          // Called when the page finishes loading
          onPageFinished: (url) {
            setState(() {
            //  isLoading = false; // Hide loading indicator when page finishes loading
            });
          },
        ),
      )
    ;


    // _controller..setSettings(settings: settings );
    // _controller.webViewController?.evaluateJavascript(
    //     source: 'document.getElementById("elementId").innerText');

    super.initState();

  }
  @override
  void dispose() {
   _controller.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shorts"),
      backgroundColor: Colors.yellow.shade300,
        elevation: 0,centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body:  Stack( // Stack allows overlaying widgets
        children: [
          // The WebView widget that shows the webpage
          WebViewWidget(controller: _controller),
          // Show CircularProgressIndicator if the page is loading
          // if (isLoading)
          //   const Center(
          //     child: CircularProgressIndicator(), // Loading spinner in the center of the screen
          //   ),
        ],
      ),
    );
  }
}
