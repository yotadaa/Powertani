import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:powertani/Auth/authentication.dart';
import 'package:powertani/Initial/main.dart';
import 'package:powertani/Notification/NotificationService.dart';
import 'package:powertani/Profile/ProfileDetail.dart';
import 'package:powertani/Seeder/Firestore_seeder.dart';
import 'package:powertani/Seeder/HiveBox_seeder.dart';
import 'package:powertani/Tanaman/jenisTanaman.dart';
import 'package:powertani/Tanaman/tanaman.dart';
import 'package:powertani/components/CustomContainer.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:powertani/home_screen.dart';
// import 'package:powertani/pageview/homepage.dart';
// import 'package:powertani/screens/home_screen.dart';
// import 'Auth/login_screen_x.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(TanamanAdapter());
  Hive.registerAdapter(JenisTanamanAdapter());
  await Hive.openBox<Tanaman>('tanamanBox');
  await Hive.openBox<JenisTanaman>('jenisTanamanBox');

  await dotenv.load(fileName: ".env");
  await NotificationService().initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    print("start uploading data");
    FirestoreSeeder().download();
    FirestoreSeeder().downloadJenisTanaman();
    print("success uploading data");
  } catch (e) {
    print(e);
  } finally {
    print("success uploading data");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  Future<void> hasError(BuildContext) async {
    signOut;
  }

  @override
  Widget build(BuildContext context) {
    hasError(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Powertani',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: LoginScreen(),
      // home: HomePage(),
      // home: StartingPage(),
      home: AuthWrapper(),
      // home: ProfileDetail(user: user)
      // home: CustomContainer(user: user)
    );
  }
}
