import 'package:flutter/material.dart';
import 'package:womomemo/services/auth.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget(
      {super.key, required this.openDrawer, required this.onTextFieldChanged});

  final void Function() openDrawer;
  final void Function(String) onTextFieldChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withAlpha(20),
          borderRadius: BorderRadius.circular(64)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(children: [
        IconButton(
          onPressed: openDrawer,
          icon: const Icon(Icons.menu),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Search your memos",
              border: InputBorder.none,
            ),
            onChanged: onTextFieldChanged,
          ),
        ),
        Auth.user == null
            ? TextButton.icon(
                onPressed: openDrawer,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black.withAlpha(20),
                ),
                icon: const Icon(Icons.login),
                label: const Text("Login"),
              )
            : IconButton(
                onPressed: openDrawer,
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
                          color: Colors.black.withAlpha(20),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(Auth.user!.photoURL!),
                        ),
                      ),
              )
      ]),
    );
  }
}
