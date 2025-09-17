import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent! Check your email.")),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String errorMessage = "Failed to send reset email";
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: 350,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Enter your email to receive reset link",
                    style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color),
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your email";
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: _resetPassword,
                          child: Text(
                            "Send Reset Email",
                            style: TextStyle(color: theme.colorScheme.onPrimary),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
