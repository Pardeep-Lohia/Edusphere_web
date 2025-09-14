import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/BaseUrl.dart';
import 'package:flutter_application_1/Screens/RippleEffectOfRoadmapScreen.dart';
import 'package:flutter_application_1/Screens/TestScreen.dart';
import 'package:graphview/GraphView.dart';
import 'package:http/http.dart' as http;

class RoadmapScreen extends StatefulWidget {
  final List<Map<String, dynamic>> roadmap;

  const RoadmapScreen({Key? key, required this.roadmap}) : super(key: key);

  @override
  _RoadmapScreenState createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  final Graph graph = Graph();
  final SugiyamaConfiguration builder = SugiyamaConfiguration();
  final TransformationController _transformationController =
      TransformationController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? selectedStep;

  @override
  void initState() {
    super.initState();
    _buildGraph();
  }

  void _buildGraph() {
    graph.nodes.clear();
    graph.edges.clear();

    widget.roadmap.sort((a, b) => a['day'].compareTo(b['day']));

    Map<int, Node> nodeMap = {};

    for (var step in widget.roadmap) {
      Node node = Node.Id(step);
      graph.addNode(node);
      nodeMap[step['day']] = node;

      if (nodeMap.containsKey(step['day'] - 1)) {
        graph.addEdge(nodeMap[step['day'] - 1]!, node,
            paint: Paint()..color = Colors.tealAccent);
      }
    }

    builder
      ..nodeSeparation = 80
      ..levelSeparation = 120
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  void showStepDetails(Map<String, dynamic> step) {
    print(step);
    int prevDayIndex = step["day"] - 1;

    if (prevDayIndex >= 0 && prevDayIndex < widget.roadmap.length) {
      if (step["day"] == 1 ||
          (widget.roadmap[prevDayIndex - 1]["completed"] == true ||
              step["completed"] == true)) {
        print("Accessing details for Day ${step['day']}"); // Debug statement

        setState(() {
          selectedStep = step;
        });
        _scaffoldKey.currentState?.openEndDrawer();
      }
    }
  }

  void updateStepStatus(String newStatus) {
    if (selectedStep == null) return;

    setState(() {
      selectedStep!['completed'] = newStatus == 'Done';
    });
  }

  Color getStatusColor(bool completed) {
    return completed
        ? const Color(0xFF009688)
        : const Color(
            0xFFB71C1C); // Teal for completed, Dark Red for not completed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text("Roadmap Overview"),
        backgroundColor: Colors.black,
      ),
      endDrawer: selectedStep != null
          ? _buildRightDrawer(context, selectedStep)
          : null,
      body: Center(
        child: InteractiveViewer(
          transformationController: _transformationController,
          constrained: false,
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 0.2,
          maxScale: 5.0,
          child: GraphView(
            graph: graph,
            algorithm: SugiyamaAlgorithm(builder),
            paint: Paint()..color = Colors.tealAccent,
            builder: (Node node) {
              Map<String, dynamic> step =
                  node.key!.value as Map<String, dynamic>;
              return _buildNodeWidget(step);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNodeWidget(Map<String, dynamic> step) {
    Color statusColor = getStatusColor(step['completed']);

    return GestureDetector(
      onTap: () => showStepDetails(step),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 6)],
        ),
        child: Column(
          children: [
            Text(
              "Day ${step['day']}",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              step['task'],
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightDrawer(
      BuildContext context, Map<String, dynamic>? selectedStep) {
    return Drawer(
      backgroundColor: Colors.black87,
      width:
          selectedStep == null ? null : MediaQuery.of(context).size.width / 2,
      child: selectedStep == null
          ? _buildNoStepSelectedView()
          : _buildStepDetailsView(context, selectedStep),
    );
  }

  Widget _buildNoStepSelectedView() {
    return Center(
      child: Text(
        "Tap a step to see details.",
        style: TextStyle(color: Colors.white70, fontSize: 18),
      ),
    );
  }

  Widget _buildStepDetailsView(
      BuildContext context, Map<String, dynamic> selectedStep) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAppBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoCard(
                  icon: Icons.calendar_today,
                  title: "Day ${selectedStep['day']}",
                  content: selectedStep['task'],
                ),
                SizedBox(height: 10),
                _infoCard(
                  icon: Icons.description,
                  title: "Description",
                  content:
                      selectedStep['description'] ?? "No description available",
                ),
                SizedBox(height: 10),
                _infoCard(
                  icon: Icons.check_circle_outline,
                  title: "Status",
                  content: selectedStep['completed'] ? "Done" : "Pending",
                  color: getStatusColor(selectedStep['completed']),
                ),
                SizedBox(height: 20),
                _buildStatusSection(),
                _buildRecommendedMaterialSection(),
                _buildTakeTestButton(context, selectedStep['task']),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text("Step Details", style: TextStyle(color: Colors.white)),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Change Status:",
            style: TextStyle(color: Colors.white70, fontSize: 16)),
        SizedBox(height: 5),
        _statusDropdown(),
      ],
    );
  }

  Widget _buildRecommendedMaterialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Divider(color: Colors.white54),
        Text(
          "Recommended Material",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        // _recommendedMaterialList(),
      ],
    );
  }

  Widget _buildTakeTestButton(BuildContext context, String task) {
    return Column(
      children: [
        SizedBox(height: 20),
        Divider(color: Colors.white54),
        Center(
          child: ElevatedButton.icon(
            icon: Icon(Icons.quiz, color: Colors.black),
            label: Text("Take a Test", style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () => _takeTest(context, task),
          ),
        ),
      ],
    );
  }

  Future<void> _takeTest(BuildContext context, String task) async {
    final String apiUrl = "${APIConfig.getBaseUrl()}/generate_mcq";
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RoadmapLoadingScreen()));

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"topic": task, "num_questions": 20}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> questionsData = jsonDecode(response.body);
        List<Map<String, dynamic>> questions =
            List<Map<String, dynamic>>.from(questionsData["questions"]);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MCQTestScreen(
              topic: questions,
              onTestPassed: () {
                // Update the status of the selected step to completed
                setState(() {
                  selectedStep!['completed'] = true;
                  print(widget.roadmap);
                });
              },
            ),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Widget _infoCard(
      {required IconData icon,
      required String title,
      required String content,
      Color? color}) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color ?? Colors.white70, size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 5),
                Text(
                  content,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: DropdownButton<String>(
        dropdownColor: Colors.black87,
        value: selectedStep!['completed'] ? 'Done' : 'Pending',
        items: ["Pending", "In Progress", "Done"]
            .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status, style: TextStyle(color: Colors.white)),
                ))
            .toList(),
        onChanged: (newStatus) {
          if (newStatus != null) {
            updateStepStatus(newStatus);
            setState(() {
              selectedStep!['completed'] = newStatus == 'Done';
            });
          }
        },
        isExpanded: true,
        underline: SizedBox(),
      ),
    );
  }
}
