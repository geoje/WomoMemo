import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:womomemo/models/memo.dart';
import 'package:womomemo/screens/memo_screen.dart';
import 'package:womomemo/services/auth.dart';
import 'package:womomemo/services/rtdb.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, Memo> memos = {};

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        Auth.user = user;

        if (user != null) {
          // Get all memos
          var memosRef = RTDB.instance.ref("memos/${user.uid}");

          // Set listener
          memosRef.onValue.listen((event) {
            for (final child in event.snapshot.children) {
              final String title = child.child("title").value.toString();
              final String content = child.child("content").value.toString();
              memos[child.key!] = Memo(title: title, content: content);
            }
            setState(() {});
          });

          // Delete listener
          memosRef.onChildRemoved.listen((event) {
            memos.remove(event.snapshot.key);
            setState(() {});
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          decoration: BoxDecoration(
              color: Colors.black.withAlpha(20),
              borderRadius: BorderRadius.circular(64)),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(children: [
            IconButton(
              onPressed: () {
                widget.scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu_rounded),
            ),
            const Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Search your memos", border: InputBorder.none),
                )),
            Auth.user == null
                ? TextButton.icon(
                    onPressed: () {
                      widget.scaffoldKey.currentState!.openDrawer();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black.withAlpha(20),
                    ),
                    icon: const Icon(Icons.login_rounded),
                    label: const Text("Login"),
                  )
                : IconButton(
                    onPressed: () {
                      widget.scaffoldKey.currentState!.openDrawer();
                    },
                    padding: const EdgeInsets.all(4),
                    icon: Auth.user?.photoURL == null
                        ? const Icon(
                            Icons.account_circle_rounded,
                            color: Colors.grey,
                            size: 32,
                          )
                        : Container(
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
                              backgroundImage:
                                  NetworkImage(Auth.user!.photoURL!),
                            ),
                          ),
                  )
          ]),
        ),
      ),
      body: ListView(
        children: [
          for (var memo in memos.entries)
            ListTile(
              onTap: () => handleEdit(memo.key),
              title: Text(memo.value.title),
              subtitle: Text(memo.value.content),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleNew,
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
          SizedBox(
            height: 60,
            child: Auth.user == null
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: handleLogout,
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text("Logout"),
                      ),
                    ],
                  ),
          ),
          Center(
            child: Auth.user?.photoURL == null
                ? const Icon(
                    Icons.account_circle_rounded,
                    color: Colors.grey,
                    size: 120,
                  )
                : Container(
                    width: 120,
                    height: 120,
                    padding: const EdgeInsets.all(2),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(20),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(Auth.user!.photoURL!),
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Auth.user == null
                ? SignInButton(
                    Buttons.Google,
                    onPressed: handleLogin,
                  )
                : Text(
                    "양경호",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  ),
          ),
          Center(child: Text(Auth.user?.email ?? "")),
          const SizedBox(height: 60),
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

  handleLogin() async {
    if (kIsWeb) {
      await Auth.signInWithGoogle();
    } else if (!Platform.isWindows && !Platform.isLinux) {
      await Auth.signInWithGoogle();
    } else {
      widget.scaffoldKey.currentState!.closeDrawer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 8,
              ),
              Text('Firebase does not support on Windows yet...'),
            ],
          ),
        ),
      );
    }
  }

  void handleLogout() {
    memos = {};
    FirebaseAuth.instance.signOut();
  }

  handleNew() async {
    if (Auth.user == null) return;

    var key = RTDB.instance.ref("memos/${Auth.user!.uid}").push().key;
    if (key == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoScreen(memoKey: key),
      ),
    );
  }

  void handleEdit(String key) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoScreen(
          memoKey: key,
          memo: memos[key],
        ),
      ),
    );
  }
}
