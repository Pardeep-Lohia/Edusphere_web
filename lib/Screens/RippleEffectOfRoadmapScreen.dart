import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RoadmapLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark mode background
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Simulated list of roadmap days using shimmer effect
            Expanded(
              child: ListView.builder(
                itemCount: 7, // Simulating 7 roadmap days
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[800]!, // Dark shimmer base
                      highlightColor: Colors.grey[600]!, // Lighter shimmer
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[900], // Darker block color
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
