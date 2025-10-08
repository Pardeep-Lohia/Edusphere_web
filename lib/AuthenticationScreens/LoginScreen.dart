import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Screens/HomeScreenFinal.dart';
import 'package:flutter_application_1/user_provider.dart';
import 'package:provider/provider.dart';
import 'SignUp.dart';
import 'ForgotPassword.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        _showError("Please verify your email before logging in.");
        return;
      }

      if (user != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        _showError("User is null");
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Login failed");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 32.0,
                vertical: 24.0,
              ),
              child: Container(
                width: isMobile ? double.infinity : 400,
                padding: EdgeInsets.all(isMobile ? 16 : 24),
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
                      CircleAvatar(
                        radius: isMobile ? 35 : 45,
                        backgroundImage: NetworkImage('https://picsum.photos/100'),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: isMobile ? 22 : 26,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Please enter your details to sign in",
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 15,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "E-mail Address",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return "Enter an email";
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "Enter a password";
                          if (value.length < 6) return "Password must be at least 6 characters";
                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) => setState(() => _rememberMe = value!),
                              ),
                              Text("Remember me"),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                            ),
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(color: theme.colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Social Login Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.facebook, color: Color(0xFF1877F2)),
                            onPressed: () => _showError("Facebook login not yet implemented"),
                          ),
                          IconButton(
                            icon: Icon(Icons.g_mobiledata, color: Color(0xFFDB4437)),
                            onPressed: () => _showError("Google login not yet implemented"),
                          ),
                          IconButton(
                            icon: Icon(Icons.apple, color: theme.colorScheme.onSurface),
                            onPressed: () => _showError("Apple login not yet implemented"),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Sign In Button
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: loginUser,
                              child: Text(
                                "Sign In",
                                style: TextStyle(color: theme.colorScheme.onPrimary),
                              ),
                            ),

                      SizedBox(height: 12),
                      Divider(),
                      SizedBox(height: 8),

                      // Sign Up
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        ),
                        child: Text("Don't have an account? Sign Up"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_application_1/Screens/HomeScreenFinal.dart';
// import 'package:flutter_application_1/user_provider.dart';
// import 'package:provider/provider.dart';
// import 'SignUp.dart';
// import 'ForgotPassword.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _rememberMe = false;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> loginUser() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Firebase Authentication
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       User? user = userCredential.user;
//       print("Login Successful: UID = ${user?.uid}");

//       // Check email verification
//       if (user != null && !user.emailVerified) {
//         await _auth.signOut();
//         _showError("Please verify your email before logging in. Check your email for verification link.");
//         return;
//       }

//       // Set user in provider
//       if (user != null) {
//         Provider.of<UserProvider>(context, listen: false).setUser(user);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomeScreen(),
//           ),
//         );
//       } else {
//         _showError("User is null");
//       }
//     } on FirebaseAuthException catch (e) {
//       _showError(e.message ?? "Login failed");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Container(
//             width: 350,
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: theme.cardColor,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: theme.colorScheme.onSurface.withOpacity(0.1),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(height: 20),
//                   Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: theme.colorScheme.primary.withOpacity(0.5),
//                           blurRadius: 20,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: CircleAvatar(
//                       radius: 40,
//                       backgroundImage:
//                           NetworkImage('https://picsum.photos/100'),
//                       // Replace with your logo
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "Welcome",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     "Please enter your details to sign in",
//                     style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color),
//                   ),
//                   SizedBox(height: 20),

//                   // Email Field
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: "E-mail Address",
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.email),
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Enter an email";
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return "Enter a valid email";
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 10),

//                   // Password Field
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: "Password",
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.lock),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Enter a password";
//                       }
//                       if (value.length < 6) {
//                         return "Password must be at least 6 characters";
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 10),

//                   // Remember Me & Forgot Password
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: _rememberMe,
//                             onChanged: (value) {
//                               setState(() {
//                                 _rememberMe = value!;
//                               });
//                             },
//                           ),
//                           Text("Remember me"),
//                         ],
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
//                           );
//                         },
//                         child: Text(
//                           "Forgot password?",
//                           style: TextStyle(color: theme.colorScheme.primary),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),

//                   Divider(),
//                   SizedBox(height: 10),

//                   // Social Media Login
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.facebook, color: Color(0xFF1877F2)),
//                         onPressed: () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Facebook login")),
//                           );
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.g_mobiledata, color: Color(0xFFDB4437)),
//                         onPressed: () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Google login")),
//                           );
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.apple, color: theme.colorScheme.onSurface),
//                         onPressed: () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Apple login")),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),

//                   // Sign In Button
//                   // ElevatedButton(
//                   //   style: ElevatedButton.styleFrom(
//                   //     backgroundColor: Colors.black,
//                   //     minimumSize: Size(double.infinity, 50),
//                   //   ),
//                   //   onPressed: () {
//                   //     if (_formKey.currentState!.validate()) {
//                   //       // Implement Authentication Logic
//                   //       Navigator.of(context).pushReplacementNamed('/home');
//                   //     }
//                   //     // Navigator.of(context).pushReplacementNamed('/home');
//                   //   },
//                   //   child:
//                   //       Text("Sign In", style: TextStyle(color: Colors.white)),
//                   // ),

//                   _isLoading
//                       ? CircularProgressIndicator()
//                       : ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: theme.colorScheme.primary,
//                             minimumSize: Size(double.infinity, 50),
//                           ),
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               loginUser();
//                             }
//                           },
//                           child: Text("Sign In",
//                               style: TextStyle(color: theme.colorScheme.onPrimary)),
//                         ),
//                   SizedBox(height: 10),

//                   // Sign Up Navigation
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => SignUpScreen()),
//                       );
//                     },
//                     child: Text("Don't have an account yet? Sign Up"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Home Screen (Dummy Page for Navigation)
// // class HomeScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Home Page")),
// //       body: Center(
// //         child: Text(
// //           "Welcome to the Home Page!",
// //           style: TextStyle(fontSize: 20),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // Registration Screen
// class RegistrationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Registration")),
//       body: Center(
//         child: Text("Registration Page"),
//       ),
//     );
//   }
// }
