import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:womomemo/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user;
      });
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
            user == null
                ? TextButton.icon(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen())),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black.withAlpha(20),
                    ),
                    icon: const Icon(Icons.login_rounded),
                    label: const Text("Login"),
                  )
                : IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
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
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withAlpha(40),
                        backgroundImage: const NetworkImage(
                            "https://lh3.googleusercontent.com/a/AAcHTtclbC8tqgAwbxh9LTCRTjVOFr0rw7xDjEisPO0Z-33uLdY=s288-c-no"),
                      ),
                    ),
                  )
          ]),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Text(user?.uid ?? "uid")),
          Center(
              child: Text(
            user?.emailVerified.toString() ?? "emailVerified",
          )),
          Center(child: Text(user?.isAnonymous.toString() ?? "isAnonymous")),
          Center(child: Text(user?.displayName ?? "displayName")),
          Center(child: Text(user?.email ?? "email")),
          Center(child: Text(user?.phoneNumber ?? "phoneNumber")),
          Center(child: Text(user?.photoURL ?? "photoURL")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.add_rounded),
      ),
      drawer: Drawer(
        child: ListView(children: [
          const SizedBox(height: 80),
          Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.asset("assets/Icon-512.png"),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              "WomoMemo",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800),
            ),
          ),
          const SizedBox(height: 80),
          ListTile(
            leading: const Icon(Icons.sticky_note_2_rounded),
            title: const Text("Memos"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.archive_rounded),
            title: const Text("Archive"),
            onTap: () {},
          ),
        ]),
      ),
    );
  }
}
