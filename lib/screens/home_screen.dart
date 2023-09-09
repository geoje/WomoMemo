import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:home_widget/home_widget.dart';
import 'package:womomemo/models/memo.dart';
import 'package:womomemo/models/navItem.dart';
import 'package:womomemo/screens/memo_screen.dart';
import 'package:womomemo/services/auth.dart';
import 'package:womomemo/services/rtdb.dart';
import 'package:womomemo/widgets/drawer_widget.dart';
import 'package:womomemo/widgets/memo_widget.dart';
import 'package:womomemo/widgets/search_widget.dart';

const appGroupId = '<YOUR APP GROUP>';
const iOSWidgetName = 'MemoWidgets';
const androidWidgetName = 'MemoWidget';
const maxPreviewLines = 10;

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, Memo> memos = {};
  String viewMode = "Memos";

  @override
  void initState() {
    super.initState();

    HomeWidget.setAppGroupId(appGroupId);

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        Auth.user = user;

        if (user != null) {
          // Get all memos
          var memosRef = RTDB.instance.ref("memos/${user.uid}");

          // Set listener
          memosRef.onValue.listen((event) {
            // Refresh memo state
            memos.clear();
            for (final child in event.snapshot.children) {
              Memo memo = Memo.fromSnapshot(child);
              if (memo.delete != null) {
                if (DateTime.now().difference(memo.delete!).inDays > 30) {
                  RTDB.instance
                      .ref("memos/${Auth.user!.uid}/${child.key!}")
                      .remove();
                  continue;
                }
              }
              memos[child.key!] = memo;
            }

            // Update state
            setState(() {});

            // Push data to home widget
            var homeWidgetMemos = {...memos};
            homeWidgetMemos.removeWhere(
                (key, value) => value.archive || value.delete != null);
            HomeWidget.saveWidgetData<String>(
                "memosJson", jsonEncode(homeWidgetMemos));
            HomeWidget.updateWidget(
              iOSName: iOSWidgetName,
              androidName: androidWidgetName,
            );
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
        title: SearchWidget(
          openDrawer: () => widget.scaffoldKey.currentState!.openDrawer(),
        ),
      ),
      body: memos.values.where((memo) => isVisible(viewMode, memo)).isEmpty
          ? Center(
              child: Icon(
                NavItem.items
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
      floatingActionButton: viewMode == "Memos"
          ? FloatingActionButton(
              onPressed: handleNew,
              elevation: 0,
              focusElevation: 0,
              hoverElevation: 0,
              highlightElevation: 0,
              disabledElevation: 0,
              backgroundColor: Colors.black.withAlpha(30),
              child: const Icon(Icons.add),
            )
          : null,
      drawer: Drawer(
        child: DrawerWidget(
            onDrawerClosed: () =>
                widget.scaffoldKey.currentState!.closeDrawer(),
            onLogout: () => handleLogout,
            viewMode: viewMode,
            onViewModeChanged: (newViewMode) =>
                setState(() => viewMode = newViewMode)),
      ),
      bottomNavigationBar: viewMode == "Trash"
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(10),
              ),
              child: const Text(
                "All memos are entirely removed after 30 days of deletion.",
                textAlign: TextAlign.center,
              ),
            )
          : null,
    );
  }

  bool isVisible(String viewMode, Memo memo) {
    return memo.delete != null
        ? viewMode == "Trash"
        : memo.archive
            ? viewMode == "Archive"
            : viewMode == "Memos";
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
