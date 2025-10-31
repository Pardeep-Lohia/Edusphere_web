import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class APIConfig {
  static String getBaseUrl() {
    const String deployedUrl = "https://edusphere-ruby-two.vercel.app";

    return deployedUrl;
  }
}

class Community {
  final String id; // ✅ Ensure this field exists
  final String name;
  final String description;

  Community({
    required this.id, // ✅ Add this field
    required this.name,
    required this.description,
  });

  // Convert JSON to Community object
  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'], // ✅ Ensure ID is parsed correctly
      name: json['name'],
      description: json['description'],
    );
  }

  // Convert Community object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // ✅ Ensure ID is included
      'name': name,
      'description': description,
    };
  }
}

class Message {
  final String senderId;
  final String text;
  final DateTime timestamp;

  Message(
      {required this.senderId, required this.text, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
