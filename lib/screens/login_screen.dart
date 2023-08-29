import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:womomemo/screens/signup_screen.dart';
import 'package:womomemo/widgets/auth_header_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var pwVisible = false, authenticating = false;
  String errorMessage = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          const AuthHeaderWidget(
            title: "Login",
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person_outline_rounded),
                  hintText: "Email",
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: TextField(
                controller: passwordController,
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
          Center(
            child: SizedBox(
              width: 316,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: handleForgot,
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.all(8),
                    ),
                    child: const Text("Forgot password"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: Center(
              child: authenticating
                  ? const CircularProgressIndicator()
                  : Text(
                      errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: FilledButton.icon(
                onPressed: authenticating ? null : handleLogin,
                icon: const Icon(Icons.login_rounded),
                label: const Text("Login"),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Center(
            child: SizedBox(
              width: 300,
              child: OutlinedButton(
                onPressed: handleSignUp,
                child: const Text("Create new account"),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void handleForgot() {}
  void handleLogin() async {
    try {
      setState(() => authenticating = true);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      errorMessage = e.code == "invalid-email"
          ? "The email address is not valid"
          : e.code == "user-disabled"
              ? "The user corresponding to the given email has been disabled"
              : e.code == "user-not-found"
                  ? "There is no user corresponding to the given email"
                  : e.code == "wrong-password"
                      ? "The password is invalid for the given email, or the account corresponding to the email does not have a password set"
                      : "Unexpected auth exception!";
    } catch (e) {
      errorMessage = "Unexpected exception!";
    }
    setState(() => authenticating = false);
  }

  void handleSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }
}
