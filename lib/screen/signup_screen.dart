import 'package:flutter/material.dart';
import 'package:we_go/resources/auth_methods.dart';
import 'package:we_go/widgets/custom_button.dart';
import 'package:we_go/widgets/show_snackbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void signUpAccount() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty) {
      showSnackBar(context, "Invalid Input Details");
      return;
    }
    final res = await AuthMethods().signIn(
      _emailController.text,
      _passwordController.text,
      _nameController.text,
    );
    if (res != "Success") {
      showSnackBar(context, res);
    }
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
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 10),
                ),
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(onClick: signUpAccount, text: "Sign Up"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Already have an Account", style: TextStyle(fontSize: 16)),
                GestureDetector(
                  onTap: () {
                    // TODO: Implement it
                  },
                  child: Text(
                    "Sign In",
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
