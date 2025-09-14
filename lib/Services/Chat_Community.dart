import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Screens/BaseUrl.dart';
// import '../models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send Message
  Future<void> sendMessage(
      String communityId, String userId, String text) async {
    try {
      await _firestore
          .collection("communities")
          .doc(communityId)
          .collection("messages")
          .add({
        'senderId': userId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  // Get Messages
  Stream<List<Message>> getMessages(String communityId) {
    return _firestore
        .collection("communities")
        .doc(communityId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }
}
