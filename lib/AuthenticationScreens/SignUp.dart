// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/AuthenticationScreens/LoginScreen.dart';

// class MultiStepForm extends StatefulWidget {
//   @override
//   _MultiStepFormState createState() => _MultiStepFormState();
// }

// class _MultiStepFormState extends State<MultiStepForm> {
//   int _currentStep = 0;
//   final _formKey = GlobalKey<FormState>();

//   // Controllers for Form Inputs
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _genderController = TextEditingController();

//   Widget _buildStepIndicator() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(3, (index) {
//         return Container(
//           width: 10,
//           height: 10,
//           margin: EdgeInsets.symmetric(horizontal: 5),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: _currentStep == index ? Colors.blue : Colors.grey[300],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildFormSection() {
//     switch (_currentStep) {
//       case 0:
//         return Column(
//           children: [
//             TextFormField(
//               controller: _firstNameController,
//               decoration: InputDecoration(
//                 labelText: 'First Name',
//                 prefixIcon: Icon(Icons.person),
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your first name';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               controller: _lastNameController,
//               decoration: InputDecoration(
//                 labelText: 'Last Name',
//                 prefixIcon: Icon(Icons.person_outline),
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your last name';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 prefixIcon: Icon(Icons.email),
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your email';
//                 } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                     .hasMatch(value)) {
//                   return 'Enter a valid email';
//                 }
//                 return null;
//               },
//             ),
//           ],
//         );
//       case 1:
//         return Column(
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Highest Qualification',
//                 prefixIcon: Icon(Icons.school),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Institute Name',
//                 prefixIcon: Icon(Icons.account_balance),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Year of Graduation',
//                 prefixIcon: Icon(Icons.calendar_today),
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         );
//       case 2:
//         return Column(
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Enter OTP',
//                 prefixIcon: Icon(Icons.lock),
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         );
//       default:
//         return Container();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Container(
//             width: 350,
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
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
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.blue[100],
//                     child: Icon(Icons.person_add, size: 40, color: Colors.blue),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "Create Account",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     _currentStep == 0
//                         ? "Personal Information"
//                         : _currentStep == 1
//                             ? "Education Details"
//                             : "OTP Verification",
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   SizedBox(height: 20),
//                   _buildStepIndicator(),
//                   SizedBox(height: 20),
//                   _buildFormSection(),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       if (_currentStep > 0)
//                         OutlinedButton(
//                           onPressed: () {
//                             setState(() => _currentStep--);
//                           },
//                           child: Text('Back'),
//                         ),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_currentStep < 2) {
//                             setState(() => _currentStep++);
//                           } else {
//                             if (_formKey.currentState!.validate()) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text("Form Submitted")),
//                               );
//                             }
//                           }
//                         },
//                         child: Text(_currentStep == 2 ? 'Submit' : 'Next'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           minimumSize: Size(120, 50),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginScreen()),
//                       );
//                     },
//                     child: Text("Already have an account? Login"),
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
import 'package:flutter/material.dart';
import 'package:flutter_application_1/AuthenticationScreens/LoginScreen.dart';
// import 'package:myapp/AuthenticationScreens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: 350,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
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
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/100',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Create Account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Please fill in your details",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 20),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

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
                      if (value!.isEmpty) {
                        return "Enter an email";
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

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
                      if (value!.isEmpty) {
                        return "Enter a password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Sign Up Button
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );

                                Navigator.of(
                                  context,
                                ).pushReplacementNamed('/home');
                              } on FirebaseAuthException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(e.message ?? "Sign up failed"),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Something went wrong")),
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                  SizedBox(height: 10),

                  // Login Navigation
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text("Already have an account? Sign In"),
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
