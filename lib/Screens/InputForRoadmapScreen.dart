import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/BaseUrl.dart';
import 'package:flutter_application_1/Screens/RoadmapScreen.dart';
import 'package:flutter_application_1/Screens/RippleEffectOfRoadmapScreen.dart';
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

    // show shimmer screen immediately
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoadmapLoadingScreen()),
    );

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "topic": topic,
          "duration": duration,
          "user_id": widget.uid
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> roadmapData = jsonDecode(response.body);

        // store roadmap in Firestore
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('user_roadmaps')
            .add({
          'user_id': widget.uid,
          'topic': roadmapData['topic'] ?? '',
          'progress': roadmapData['progress'] ?? [],
          'created_at': FieldValue.serverTimestamp(),
        });

        // add doc id to roadmapData for later updates
        roadmapData['id'] = docRef.id;

        // navigate directly to RoadmapScreen replacing the shimmer
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RoadmapScreen(roadmapData: roadmapData),
            ),
          );
        }
      } else {
        // close shimmer and show error
        if (mounted) Navigator.pop(context);
        setState(() {
          _errorMessage =
              "Failed to generate roadmap. Status Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text("Create Roadmap"),
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
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _inputField(
              controller: _topicController,
              hintText: "Enter topic",
              icon: Icons.topic,
            ),
            const SizedBox(height: 15),
            _inputField(
              controller: _durationController,
              hintText: "Enter duration (days)",
              icon: Icons.calendar_today,
              isNumeric: true,
            ),
            const SizedBox(height: 20),
            _errorMessage.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(_errorMessage,
                                style: const TextStyle(color: Colors.white))),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => setState(() => _errorMessage = ''),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        color: theme.colorScheme.primary))
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => generateRoadmap(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Generate Roadmap",
                          style: TextStyle(
                              fontSize: 18, color: theme.colorScheme.onPrimary)),
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.7)),
          hintText: hintText,
          hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
