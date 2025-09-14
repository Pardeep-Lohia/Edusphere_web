// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Screens/BaseUrl.dart';
// import 'package:flutter_application_1/Services/Chat_Community.dart';
// // import '../services/chat_service.dart';
// // import '../models/message.dart';

// class ChatPage extends StatefulWidget {
//   final String communityId;
//   final String userId;

//   const ChatPage({Key? key, required this.communityId, required this.userId})
//       : super(key: key);

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final ChatService _chatService = ChatService();
//   final TextEditingController _messageController = TextEditingController();

//   void _sendMessage() {
//     if (_messageController.text.trim().isNotEmpty) {
//       _chatService.sendMessage(
//           widget.communityId, widget.userId, _messageController.text);
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Community Chat")),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<List<Message>>(
//               stream: _chatService.getMessages(widget.communityId),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData)
//                   return Center(child: CircularProgressIndicator());

//                 final messages = snapshot.data!;
//                 return ListView.builder(
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     final isMe = message.senderId == widget.userId;

//                     return Align(
//                       alignment:
//                           isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         margin:
//                             EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.blueAccent : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child:
//                             Text(message.text, style: TextStyle(fontSize: 16)),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(hintText: "Type a message..."),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.blue),
//                   onPressed: _sendMessage,
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/BaseUrl.dart';
import 'package:flutter_application_1/Services/Chat_Community.dart';

class ChatPage extends StatefulWidget {
  final String communityId;
  final String userId;

  const ChatPage({Key? key, required this.communityId, required this.userId})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      _chatService.sendMessage(
          widget.communityId, widget.userId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark mode background
      appBar: AppBar(
        title: Text("Community Chat"),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getMessages(widget.communityId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No messages yet. Start a conversation!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true, // Newest messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == widget.userId;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blueAccent : Colors.grey[800],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft:
                                isMe ? Radius.circular(10) : Radius.zero,
                            bottomRight:
                                isMe ? Radius.zero : Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  backgroundColor: Colors.blueAccent,
                  onPressed: _sendMessage,
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
