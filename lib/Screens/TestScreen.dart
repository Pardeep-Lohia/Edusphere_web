import 'package:flutter/material.dart';

class MCQTestScreen extends StatefulWidget {
  final Function onTestPassed; // Callback function
  final List<Map<String, dynamic>> topic;

  MCQTestScreen({required this.topic, required this.onTestPassed});

  @override
  _MCQTestScreenState createState() => _MCQTestScreenState();
}

class _MCQTestScreenState extends State<MCQTestScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _showResults = false;
  Map<int, String?> _selectedAnswers = {}; // Store selected answers
  bool passed = false;

  void _submitTest() {
    _score = 0;
    int totalQuestions = widget.topic.length;

    widget.topic.asMap().forEach((index, question) {
      if (_selectedAnswers[index] == question['answer']) {
        _score++;
      }
    });

    if (_score > (totalQuestions * 0.7)) {
      setState(() {
        passed = true;
      });
    }

    setState(() {
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MCQ Test"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black87,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _showResults ? _buildResults() : _buildQuestion(),
      ),
    );
  }

  Widget _buildQuestion() {
    final question = widget.topic[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Q${_currentQuestionIndex + 1}: ${question['question']}",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ...question['options'].map<Widget>((option) {
          return RadioListTile<String>(
            title: Text(option, style: TextStyle(color: Colors.white)),
            value: option,
            groupValue: _selectedAnswers[_currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                _selectedAnswers[_currentQuestionIndex] = value;
              });
            },
            activeColor: Colors.blue,
          );
        }).toList(),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentQuestionIndex > 0)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex--;
                  });
                },
                child: Text("Previous"),
              ),
            if (_currentQuestionIndex < widget.topic.length - 1)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex++;
                  });
                },
                child: Text("Next"),
              ),
            if (_currentQuestionIndex == widget.topic.length - 1)
              ElevatedButton(
                onPressed: _submitTest,
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildResults() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Test Completed!",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text("Your Score: $_score / ${widget.topic.length}",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        SizedBox(height: 10),
        Text("Correct Answers: $_score",
            style: TextStyle(color: Colors.green, fontSize: 16)),
        Text("Incorrect Answers: ${widget.topic.length - _score}",
            style: TextStyle(color: Colors.red, fontSize: 16)),
        Text(
          passed ? "🎉 You Passed!" : "❌ You Failed!",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: passed ? Colors.green : Colors.red,
            shadows: [
              Shadow(
                blurRadius: 2,
                color: Colors.black45,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            if (passed) {
              widget
                  .onTestPassed(); // Notify RoadmapScreen that the test was passed
              Navigator.pop(context);
            } else {
              setState(() {
                _showResults = false;
                _currentQuestionIndex = 0;
                _selectedAnswers.clear();
                _score = 0;
              });
            }
          },
          child: Text(passed ? "We did it!" : "Retake Test"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
      ],
    );
  }
}
