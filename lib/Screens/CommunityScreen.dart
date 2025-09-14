// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Screens/BaseUrl.dart' as base;
// import 'package:flutter_application_1/Services/Community.dart' as service;
// import 'package:flutter_application_1/Screens/ChatScreen.dart';
// import 'package:share_plus/share_plus.dart';

// class CommunityPage extends StatefulWidget {
//   final String userId;

//   const CommunityPage({Key? key, required this.userId}) : super(key: key);

//   @override
//   _CommunityPageState createState() => _CommunityPageState();
// }

// class _CommunityPageState extends State<CommunityPage> {
//   List<service.Community> communities = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadCommunities();
//   }

//   Future<void> _loadCommunities() async {
//     setState(() => isLoading = true);
//     final result =
//         await service.CommunityService.getUserCommunities(widget.userId);
//     setState(() {
//       communities = result;
//       isLoading = false;
//     });
//   }

//   void _showCreateCommunityDialog() {
//     final TextEditingController nameController = TextEditingController();
//     final TextEditingController descController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//           title: Text("Create Community",
//               style: TextStyle(fontWeight: FontWeight.bold)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   labelText: "Community Name",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: descController,
//                 decoration: InputDecoration(
//                   labelText: "Description",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("Cancel", style: TextStyle(color: Colors.grey)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueAccent,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8)),
//               ),
//               onPressed: () async {
//                 if (nameController.text.isNotEmpty &&
//                     descController.text.isNotEmpty) {
//                   String? communityId = await _createCommunity(
//                       nameController.text, descController.text);
//                   Navigator.pop(context);
//                   if (communityId != null) {
//                     _shareCommunityLink(communityId);
//                   }
//                 } else {
//                   _showSnackBar("Please enter all fields!");
//                 }
//               },
//               child: Text("Create", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<String?> _createCommunity(String name, String description) async {
//     String? communityId = await service.CommunityService.createCommunity(
//         name, description, widget.userId);

//     if (communityId != null) {
//       await Future.delayed(Duration(milliseconds: 500));
//       await _loadCommunities();
//       _showSnackBar("Community Created!");
//     }

//     return communityId;
//   }

//   void _shareCommunityLink(String communityId) {
//     String inviteLink = "${base.APIConfig.getBaseUrl()}/join/$communityId";
//     Share.share("Join my community: $inviteLink");
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Communities",
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: isLoading
//             ? Center(child: CircularProgressIndicator())
//             : communities.isEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.group, size: 60, color: Colors.grey),
//                         SizedBox(height: 10),
//                         Text("No communities found.",
//                             style: TextStyle(fontSize: 18)),
//                         SizedBox(height: 5),
//                         Text("Create one to get started!",
//                             style: TextStyle(color: Colors.grey)),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: communities.length,
//                     itemBuilder: (context, index) {
//                       final community = communities[index];
//                       return Card(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         elevation: 3,
//                         child: ListTile(
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 15),
//                           leading: CircleAvatar(
//                             backgroundColor: Colors.blueAccent,
//                             child: Icon(Icons.group, color: Colors.white),
//                           ),
//                           title: Text(
//                             community.name,
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Text(community.description,
//                               maxLines: 2, overflow: TextOverflow.ellipsis),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ChatPage(
//                                     communityId: community.id,
//                                     userId: widget.userId),
//                               ),
//                             );
//                           },
//                           trailing: IconButton(
//                             icon: Icon(Icons.share, color: Colors.blueAccent),
//                             onPressed: () => _shareCommunityLink(community.id),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.blueAccent,
//         child: Icon(Icons.add, color: Colors.white),
//         onPressed: _showCreateCommunityDialog,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/BaseUrl.dart' as base;
import 'package:flutter_application_1/Services/Community.dart' as service;
import 'package:flutter_application_1/Screens/ChatScreen.dart';
import 'package:share_plus/share_plus.dart';

class CommunityPage extends StatefulWidget {
  final String userId;

  const CommunityPage({Key? key, required this.userId}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<service.Community> communities = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    setState(() => isLoading = true);
    final result =
        await service.CommunityService.getUserCommunities(widget.userId);
    setState(() {
      communities = result;
      isLoading = false;
    });
  }

  void _showCreateCommunityDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Create Community",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Community Name",
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.redAccent)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    descController.text.isNotEmpty) {
                  String? communityId = await _createCommunity(
                      nameController.text, descController.text);
                  Navigator.pop(context);
                  if (communityId != null) {
                    _shareCommunityLink(communityId);
                  }
                } else {
                  _showSnackBar("Please enter all fields!");
                }
              },
              child: Text("Create", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _createCommunity(String name, String description) async {
    String? communityId = await service.CommunityService.createCommunity(
        name, description, widget.userId);
    if (communityId != null) {
      await Future.delayed(Duration(milliseconds: 500));
      await _loadCommunities();
      _showSnackBar("Community Created!");
    }
    return communityId;
  }

  void _shareCommunityLink(String communityId) {
    String inviteLink = "${base.APIConfig.getBaseUrl()}/join/$communityId";
    Share.share("Join my community: $inviteLink");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.grey[800]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("My Communities",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
            : communities.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group, size: 60, color: Colors.white70),
                        SizedBox(height: 10),
                        Text("No communities found.",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        SizedBox(height: 5),
                        Text("Create one to get started!",
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: communities.length,
                    itemBuilder: (context, index) {
                      final community = communities[index];
                      return Card(
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.group, color: Colors.white),
                          ),
                          title: Text(community.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          subtitle: Text(community.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white70)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    communityId: community.id,
                                    userId: widget.userId),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.share, color: Colors.blueAccent),
                            onPressed: () => _shareCommunityLink(community.id),
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: _showCreateCommunityDialog,
      ),
    );
  }
}
