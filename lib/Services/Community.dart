import 'dart:convert';
import 'package:flutter_application_1/Screens/BaseUrl.dart';
import 'package:http/http.dart' as http;

class Community {
  final String id;
  final String name;
  final String description;

  Community({required this.id, required this.name, required this.description});

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['community_id'], // Fixed key name
      name: json['name'] ?? "No Name", // Prevents null issues
      description: json['description'] ?? "No Description",
    );
  }
}

class CommunityService {
  // Create a new community
  static Future<String?> createCommunity(
      String name, String description, String creator) async {
    try {
      final response = await http.post(
        Uri.parse('${APIConfig.getBaseUrl()}/create_community'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"name": name, "description": description, "creator": creator}),
      );

      print("Create Community Response: ${response.body}"); // Debugging log

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['community_id'];
      } else {
        print("Error creating community: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception in createCommunity: $e");
      return null;
    }
  }

  // Join a community
  static Future<bool> joinCommunity(String communityId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('${APIConfig.getBaseUrl()}/join_community'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"community_id": communityId, "user_id": userId}),
      );

      print("Join Community Response: ${response.body}"); // Debugging log

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error joining community: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception in joinCommunity: $e");
      return false;
    }
  }

  // Fetch user communities
  static Future<List<Community>> getUserCommunities(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('${APIConfig.getBaseUrl()}/user_communities/$userId'));

      print("Get Communities Response: ${response.body}"); // Debugging log

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((data) => Community.fromJson(data)).toList();
      } else {
        print("Error fetching communities: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception in getUserCommunities: $e");
      return [];
    }
  }
}
