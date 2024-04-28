import 'package:dynamic_task/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int imageCount = 3;
  Key _pageKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    final remoteConfig = FirebaseRemoteConfig.instance;
    remoteConfig.onConfigUpdated.listen((RemoteConfigUpdate event) async {
      await remoteConfig.activate();
      setState(() {
        imageCount = remoteConfig.getInt("imageCount");
        _pageKey = UniqueKey();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Dynamic UI'),
      ),
      body: Center(
        child: PageView.builder(
          key: _pageKey,
          itemCount: imageCount ?? 0,
          itemBuilder: (context, index) {
            return CardWidget(index + 1);
          },
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final int number;

  CardWidget(this.number);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
