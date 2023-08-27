import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WomoMemo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'WomoMemo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(64)),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(children: [
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu_rounded),
            ),
            const Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Search your memos", border: InputBorder.none),
                )),
            IconButton(
              onPressed: () {},
              padding: const EdgeInsets.all(4),
              icon: Container(
                width: 32,
                height: 32,
                padding: const EdgeInsets.all(1),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(40),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://lh3.googleusercontent.com/a/AAcHTtclbC8tqgAwbxh9LTCRTjVOFr0rw7xDjEisPO0Z-33uLdY=s288-c-no"),
                ),
              ),
            )
          ]),
        ),
      ),
      body: const Center(child: Text("No memos")),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        child: const Icon(Icons.add_rounded),
      ),
      drawer: Drawer(
        width: 200,
        child: ListView(children: const [
          ListTile(
            leading: Icon(Icons.sticky_note_2_rounded),
            title: Text("Notes"),
          ),
          ListTile(
            leading: Icon(Icons.archive_rounded),
            title: Text("Archive"),
          ),
        ]),
      ),
    );
  }
}
