import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleAuthProvider googleProvider;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user;
      });
    });

    if (kIsWeb) {
      googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
    }
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
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
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
                    icon: user?.photoURL == null
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
                              backgroundImage: NetworkImage(user!.photoURL!),
                            ),
                          ),
                  )
          ]),
        ),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Text("No memos")),
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
          SizedBox(
            height: 60,
            child: user == null
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text("Logout"),
                      ),
                    ],
                  ),
          ),
          Center(
            child: user?.photoURL == null
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
                      backgroundImage: NetworkImage(user!.photoURL!),
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          Center(
            child: user == null
                ? SignInButton(
                    Buttons.Google,
                    onPressed: handleSignIn,
                  )
                : Text(
                    "양경호",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  ),
          ),
          Center(child: Text(user?.email ?? "")),
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

  handleSignIn() async {
    var credential = await signInWithGoogle();
  }

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      // Create a new provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }
}
