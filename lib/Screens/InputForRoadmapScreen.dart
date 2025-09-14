import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/BaseUrl.dart';
import 'package:flutter_application_1/Screens/RippleEffectOfRoadmapScreen.dart';
import 'package:flutter_application_1/Screens/RoadmapScreen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roadmap Demo',
      // home: RoadmapScreen(roadmap: dummyRoadmap),
      home: InputScreen(uid: 'test'),
    );
  }
}

class InputScreen extends StatefulWidget {
  final String uid;
  const InputScreen({Key? key, required this.uid}) : super(key: key);
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

//   Future<void> _generateRoadmap(BuildContext context) async {
//     String topic = _topicController.text.trim();
//     String duration = _durationController.text.trim();

//     if (topic.isEmpty || duration.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please enter both topic and duration")),
//       );
//       return;
//     }

//     int durationDays = int.tryParse(duration) ?? 30;

//     // Navigate to loading screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => RoadmapLoadingScreen()),
//     );

//     try {
//       var response = await http.post(
//         Uri.parse('http://your-backend-url/generate_roadmap'), // Replace with actual backend URL
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"topic": topic, "duration": durationDays}),
//       );

//       if (response.statusCode == 200) {
//         var roadmapData = jsonDecode(response.body);

//         // Navigate to RoadmapScreen after receiving response
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => RoadmapScreen(roadmapData: roadmapData),
//           ),
//         );
//       } else {
//         Navigator.pop(context); // Close loading screen on failure
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to generate roadmap. Try again!")),
//         );
//       }
//     } catch (e) {
//       Navigator.pop(context); // Close loading screen on error
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${e.toString()}")),
//       );
//     }
//   }

  Future<void> generateRoadmap(BuildContext context) async {
    final String apiUrl = "${APIConfig.getBaseUrl()}/generate_roadmap";

    String topic = _topicController.text.trim();
    int? duration = int.tryParse(_durationController.text.trim());

    if (topic.isEmpty || duration == null || duration <= 0) {
      setState(() {
        _errorMessage = "Please enter a valid topic and duration.";
      });
      return;
    }

//     int durationDays = int.tryParse(duration) ?? 30;

    // Navigate to loading screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoadmapLoadingScreen()),
    );

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"topic": topic, "duration": duration, "user_id": widget.uid}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> roadmapData = jsonDecode(response.body);
        List<Map<String, dynamic>> roadmap =
            List<Map<String, dynamic>>.from(roadmapData["progress"]);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => RoadmapScreen(roadmap: roadmap)),
        );
      } else {
        Navigator.pop(context); // Close loading screen on failure
        setState(() {
          _errorMessage =
              "Failed to generate roadmap. Status Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Create Roadmap"),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Details",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _inputField(
              controller: _topicController,
              hintText: "Enter topic",
              icon: Icons.topic,
            ),
            SizedBox(height: 15),
            _inputField(
              controller: _durationController,
              hintText: "Enter duration (days)",
              icon: Icons.calendar_today,
              isNumeric: true,
            ),
            SizedBox(height: 20),
            _errorMessage.isNotEmpty
                ? Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(_errorMessage,
                                style: TextStyle(color: Colors.white))),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => setState(() => _errorMessage = ''),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 10),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => generateRoadmap(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Generate Roadmap",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isNumeric = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.white70),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white60),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'roadmap_screen.dart';
// import 'roadmap_loading_screen.dart';

// class InputScreen extends StatefulWidget {
//   @override
//   _InputScreenState createState() => _InputScreenState();
// }

// class _InputScreenState extends State<InputScreen> {
//   final TextEditingController _topicController = TextEditingController();
//   final TextEditingController _durationController = TextEditingController();

//   Future<void> _generateRoadmap(BuildContext context) async {
//     String topic = _topicController.text.trim();
//     String duration = _durationController.text.trim();

//     if (topic.isEmpty || duration.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please enter both topic and duration")),
//       );
//       return;
//     }

//     int durationDays = int.tryParse(duration) ?? 30;

//     // Navigate to loading screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => RoadmapLoadingScreen()),
//     );

//     try {
//       var response = await http.post(
//         Uri.parse('http://your-backend-url/generate_roadmap'), // Replace with actual backend URL
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"topic": topic, "duration": durationDays}),
//       );

//       if (response.statusCode == 200) {
//         var roadmapData = jsonDecode(response.body);

//         // Navigate to RoadmapScreen after receiving response
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => RoadmapScreen(roadmapData: roadmapData),
//           ),
//         );
//       } else {
//         Navigator.pop(context); // Close loading screen on failure
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to generate roadmap. Try again!")),
//         );
//       }
//     } catch (e) {
//       Navigator.pop(context); // Close loading screen on error
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${e.toString()}")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black, // Dark mode background
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _topicController,
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 labelText: "Enter Topic",
//                 labelStyle: TextStyle(color: Colors.white),
//                 filled: true,
//                 fillColor: Colors.grey[900],
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _durationController,
//               style: TextStyle(color: Colors.white),
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "Enter Duration (days)",
//                 labelStyle: TextStyle(color: Colors.white),
//                 filled: true,
//                 fillColor: Colors.grey[900],
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => _generateRoadmap(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueAccent,
//                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//               ),
//               child: Text("Generate Roadmap", style: TextStyle(fontSize: 16)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
