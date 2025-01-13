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
import 'model/favouriteModel.dart';


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