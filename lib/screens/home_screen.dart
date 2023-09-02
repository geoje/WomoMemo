import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:womomemo/models/memo.dart';
import 'package:womomemo/models/navItem.dart';
import 'package:womomemo/screens/memo_screen.dart';
import 'package:womomemo/services/auth.dart';
import 'package:womomemo/services/rtdb.dart';
import 'package:womomemo/widgets/memo_widget.dart';

const maxPreviewLines = 10;

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<NavItem> navItems = [
    NavItem(
      label: "Memos",
      iconData: Icons.sticky_note_2_outlined,
      iconDataActive: Icons.sticky_note_2,
    ),
    NavItem(
      label: "Archive",
      iconData: Icons.archive_outlined,
      iconDataActive: Icons.archive,
    ),
    NavItem(
      label: "Trash",
      iconData: Icons.delete_outline,
      iconDataActive: Icons.delete,
    )
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, Memo> memos = {};
  String viewMode = "Memos";
  bool viewWomosoft = false;

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
              memos[child.key!] = Memo.fromSnapshot(child);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
              icon: const Icon(Icons.menu),
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
                    icon: const Icon(Icons.login),
                    label: const Text("Login"),
                  )
                : IconButton(
                    onPressed: () {
                      widget.scaffoldKey.currentState!.openDrawer();
                    },
                    padding: const EdgeInsets.all(4),
                    icon: Auth.user?.photoURL == null
                        ? const Icon(
                            Icons.account_circle,
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
      body: memos.values.where((memo) => isVisible(viewMode, memo)).isEmpty
          ? Center(
              child: Icon(
                widget.navItems
                    .firstWhere((item) => item.label == viewMode)
                    .iconData,
                color: Colors.grey.shade200,
                size: 192,
              ),
            )
          : MasonryGridView.count(
              itemCount: memos.values
                  .where((memo) => isVisible(viewMode, memo))
                  .length,
              crossAxisCount: (MediaQuery.of(context).size.width / 200).floor(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                var entry = memos.entries
                    .where((entry) => isVisible(viewMode, entry.value))
                    .toList()[index];
                return MemoWidget(memoKey: entry.key, memo: entry.value);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleNew,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        backgroundColor: Colors.black.withAlpha(30),
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(children: [
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      viewWomosoft = !viewWomosoft;
                    }),
                    icon: SvgPicture.asset(
                      "assets/womosoft.svg",
                      width: 24,
                      height: 24,
                      colorFilter: viewWomosoft
                          ? null
                          : ColorFilter.mode(
                              Theme.of(context).primaryColor,
                              BlendMode.srcIn,
                            ),
                    ),
                  ),
                  Auth.user == null
                      ? const SizedBox()
                      : TextButton.icon(
                          onPressed: handleLogout,
                          icon: const Icon(Icons.logout),
                          label: const Text("Logout"),
                        ),
                ],
              ),
            ),
          ),
          Center(
            child: Auth.user?.photoURL == null
                ? const Icon(
                    Icons.account_circle,
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
                    Auth.user!.displayName ?? "",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
          ),
          Center(child: Text(Auth.user?.email ?? "")),
          const SizedBox(height: 60),
          for (var navItem in widget.navItems)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton(
                onPressed: () {
                  setState(() => viewMode = navItem.label);
                  widget.scaffoldKey.currentState!.closeDrawer();
                },
                style: viewMode == navItem.label
                    ? TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).primaryColor.withAlpha(40))
                    : null,
                child: Row(children: [
                  Icon(viewMode == navItem.label
                      ? navItem.iconDataActive
                      : navItem.iconData),
                  const SizedBox(width: 8),
                  Expanded(child: Text(navItem.label)),
                ]),
              ),
            )
        ]),
      ),
    );
  }

  bool isVisible(String viewMode, Memo memo) {
    return memo.delete != null
        ? viewMode == "Trash"
        : memo.archive
            ? viewMode == "Archive"
            : viewMode == "Memos";
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
                Icons.warning,
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

  handleLogout() {
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

  handleEdit(String key) {
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
