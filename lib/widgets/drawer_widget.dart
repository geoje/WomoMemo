import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:womomemo/models/navItem.dart';
import 'package:womomemo/services/auth.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget(
      {super.key,
      required this.onDrawerClosed,
      required this.onLogout,
      required this.viewMode,
      required this.onViewModeChanged});

  final void Function() onDrawerClosed, onLogout;
  final String viewMode;
  final void Function(String) onViewModeChanged;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool viewWomosoft = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
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
                        onPressed: widget.onLogout,
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
        for (var navItem in NavItem.items)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextButton(
              onPressed: () {
                widget.onViewModeChanged(navItem.label);
                widget.onDrawerClosed();
              },
              style: TextButton.styleFrom(
                fixedSize: const Size.fromHeight(48),
                backgroundColor: widget.viewMode == navItem.label
                    ? Theme.of(context).primaryColor.withAlpha(40)
                    : null,
              ),
              child: Row(children: [
                Icon(widget.viewMode == navItem.label
                    ? navItem.iconDataActive
                    : navItem.iconData),
                const SizedBox(width: 8),
                Expanded(child: Text(navItem.label)),
              ]),
            ),
          )
      ],
    );
  }

  handleLogin() async {
    if (kIsWeb) {
      await Auth.signInWithGoogle();
    } else if (!Platform.isWindows && !Platform.isLinux) {
      await Auth.signInWithGoogle();
    } else {
      widget.onDrawerClosed();
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
}
