import 'package:flutter/material.dart';
import 'package:we_go/resources/auth_methods.dart';
import 'package:we_go/widgets/custom_button.dart';
import 'package:we_go/widgets/show_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void loginUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showSnackBar(context, "Missing Details");
      return;
    }
    final loginRes = await AuthMethods().login(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (loginRes != "Success") {
      showSnackBar(context, "Email or password is incorrect");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email ID",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 10),
                ),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 10),
                ),
              ),
            ),
            const SizedBox(height: 40),

            CustomButton(onClick: loginUser, text: "Login"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Don't have an Account", style: TextStyle(fontSize: 16)),
                GestureDetector(
                  onTap: () {
                    // TODO: Implement it
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
