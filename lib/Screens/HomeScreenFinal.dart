import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/BaseUrl.dart';
import 'package:flutter_application_1/Screens/CommunityScreen.dart';
import 'package:flutter_application_1/Screens/Data.dart';
import 'package:flutter_application_1/Screens/InputForRoadmapScreen.dart';
import 'package:flutter_application_1/Screens/RoadmapScreen.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomeScreen extends StatefulWidget {
  final String uid;

  const HomeScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeContentScreen(uid: widget.uid),
      UploadScreen(uid: widget.uid),
      ChatScreen(uid: widget.uid),
      ProfileScreen(uid: widget.uid),
    ];

    return Scaffold(
      backgroundColor: Colors.black87,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 32), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.upload_file, size: 32), label: 'Upload'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat, size: 32), label: 'Chatbot'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 32), label: 'Profile'),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black26,
        showUnselectedLabels: true,
      ),
    );
  }
}

class HomeContentScreen extends StatefulWidget {
  final String uid;
  HomeContentScreen({Key? key, required this.uid}) : super(key: key);
  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  @override
  Future<String?> getUserNameFromUID(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        return userDoc['UserName']; // or userDoc['name']
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      print("Error fetching user name: $e");
      return null;
    }
  }

  String? name;

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  void loadUserName() async {
    String? result = await getUserNameFromUID(widget.uid);
    setState(() {
      name = result;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${name}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Your Learning Roadmap:",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RoadmapScreen(roadmap: roadmap)),
                      );
                    },
                    child: RoadmapCard(
                      title: "DSA",
                      icon: Icons.book,
                      progress: .1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InputScreen(uid: widget.uid)),
                  );
                },
                child: Text("Build with AI"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CommunityPage(userId: widget.uid)),
                  );
                },
                child: Text("My Communities"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoadmapCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double progress;

  RoadmapCard(
      {required this.title, required this.icon, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurpleAccent]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: 6, offset: Offset(3, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          SizedBox(height: 10),
          Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 10,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                height: 10,
                width: 180 * progress,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: progress < 0.5
                        ? [Colors.redAccent, Colors.orangeAccent]
                        : progress < 0.8
                            ? [Colors.orangeAccent, Colors.yellowAccent]
                            : [Colors.greenAccent, Colors.blueAccent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: progress * 100),
            duration: Duration(seconds: 1),
            builder: (context, value, child) {
              return Text("${value.toInt()}% Completed",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold));
            },
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  final String uid;
  const UploadScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? fileName;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // Allows PDFs, videos, images, etc.
    );

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Upload Your File",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: pickFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: Text("Pick a File"),
                    ),
                    SizedBox(height: 20),
                    fileName != null
                        ? Text(
                            "Selected: $fileName",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            "No file selected",
                            style: TextStyle(color: Colors.white54),
                          ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Upload function will be added later
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: Text("Upload File"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String uid;
  const ChatScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final String apiUrl = "${APIConfig.getBaseUrl()}/chatbot";

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      messages.add({"sender": "user", "message": userMessage});
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": userMessage}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          messages
              .add({"sender": "bot", "message": responseData["bot_response"]});
          _isTyping = false;
        });
      } else {
        throw Exception("Failed to get response from chatbot");
      }
    } catch (e) {
      setState(() {
        messages.add({
          "sender": "bot",
          "message": "Error: Unable to connect to chatbot"
        });
        _isTyping = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("ChatBot"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == messages.length) {
                  return _buildTypingIndicator();
                }
                final msg = messages[index];
                return _buildChatBubble(
                    msg["message"]!, msg["sender"] == "user");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    if (_controller.text.trim().isNotEmpty) {
                      sendMessage(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    ),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[850],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: isUser ? Radius.circular(14) : Radius.circular(0),
            bottomRight: isUser ? Radius.circular(0) : Radius.circular(14),
          ),
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              message,
              textStyle: TextStyle(fontSize: 16, color: Colors.white),
              speed: Duration(milliseconds: 50),
            ),
          ],
          isRepeatingAnimation: false,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: 20, bottom: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Chatbot is typing", style: TextStyle(color: Colors.white70)),
            SizedBox(width: 6),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  final String userName = "Pardeep Lohia";
  final String email = "pardeeplohia7098@gmail.com";
  final int totalUploads = 24;
  final String storageUsed = "1.2 GB";
  final String lastUpload = "Feb 25, 2025";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                userName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white30),
              SizedBox(height: 20),

              // Stats Section
              buildStatTile(
                  Icons.upload_file, "Total Uploads", totalUploads.toString()),
              buildStatTile(Icons.storage, "Storage Used", storageUsed),
              buildStatTile(Icons.history, "Last Upload", lastUpload),

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Logout or settings action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatTile(IconData icon, String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 30),
          SizedBox(width: 15),
          Expanded(
            child: Text(title,
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          Text(value, style: TextStyle(color: Colors.white70, fontSize: 18)),
        ],
      ),
    );
  }
}
