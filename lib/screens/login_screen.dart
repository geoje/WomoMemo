import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var pwVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          const SizedBox(height: 100),
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset("assets/Icon-512.png"),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              "Login",
              style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800),
            ),
          ),
          const SizedBox(height: 100),
          const Center(
            child: SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.person_outline_rounded),
                    hintText: "Email"),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: TextField(
                obscureText: !pwVisible,
                decoration: InputDecoration(
                  icon: const Icon(Icons.key_rounded),
                  hintText: "Password",
                  suffixIcon: IconButton(
                    iconSize: 20,
                    onPressed: () => setState(() {
                      pwVisible = !pwVisible;
                    }),
                    icon: Icon(
                      pwVisible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add_alt_rounded),
                label: const Text("Join"),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 200,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.login_rounded),
                  label: const Text("Login"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
