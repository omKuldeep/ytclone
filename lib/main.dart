import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kio_chat/view/splash_screen.dart';
import 'package:kio_chat/view_model/favourite_provider.dart';
import 'package:kio_chat/view_model/shorts_video_provider.dart';
import 'package:kio_chat/view_model/video_player_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'model/favouriteModel.dart';


@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {

    if(task=="play-background"){

    }
    print("Native called background task: $task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       apiKey: 'AIzaSyChsycGsKwyifmSS4jmB_KIn2v-MBoLsRE',
  //       appId: '1:363790768154:android:1481d27de936238e6e59a3',
  //       messagingSenderId: 'messagingSenderId',
  //       projectId: 'kio-chat',
  //       storageBucket: 'kio-chat.firebasestorage.app',
  //     )
  // );

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
 // await Hive.initFlutter();
  Hive.registerAdapter<FavouriteModel>(FavouriteModelAdapter());
  await Hive.openBox<FavouriteModel>('favourite_songs');

  runApp(const MyApp());


// Ideal time to initialize
 // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

}


Future<void> configure() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // More code...
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<VideoPlayerProvider>(create: (_)=>VideoPlayerProvider()),
      ChangeNotifierProvider<FavouriteProvider>(create: (_)=>FavouriteProvider()),
      ChangeNotifierProvider<ShortVideoProvider>(create: (_)=>ShortVideoProvider()),
    ], child:  MaterialApp(debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
          scaffoldBackgroundColor: Colors.yellow.shade300
      ),
      // onGenerateRoute: generateRoute,
      // initialRoute: '/',
      home: const SplashScreen(),
    ),
    );
  }
}