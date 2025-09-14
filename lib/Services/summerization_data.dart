import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
// import 'package:testflask/home/home.dart';
// import 'package:testflask/login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eduhaven',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'lfkasn',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? filePath =
      "C:/Users/parde/Desktop/test flutter/Proposal for Sponsorship-1-5.pdf";
  String data = "Select a PDF to start processing.";
  bool isLoading = false;

  /// Picks a PDF file from the device storage.
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });
    }
  }

  /// Sends the selected file path and task to the Flask API for processing.
  Future<void> processFile(String task) async {
    if (filePath == null) {
      setState(() {
        data = "Please select a file first.";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse("http://127.0.0.1:5000/process");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"file_path": filePath, "task": task}),
      );

      setState(() {
        isLoading = false;
        if (response.statusCode == 200) {
          data = jsonDecode(response.body)['output'];
        } else {
          data = "Error: ${response.statusCode} - ${response.body}";
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        data = "Request failed: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: filePath == null
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PDFViewerScreen(filePath: filePath!),
                      ),
                    );
                  },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.upload_file),
              label: Text("Select PDF"),
              onPressed: pickFile,
            ),
            if (filePath != null) ...[
              SizedBox(height: 10),
              Text(
                "Selected File: ${filePath!.split('/').last}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildButton("Summary", "summary"),
                _buildButton("MCQ", "mcq"),
                _buildButton("Short Answer", "short_answer"),
                _buildButton("Fill in Blanks", "fill_in_blanks"),
                _buildButton("Summary + QA", "summary+qa"),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Text(data, style: TextStyle(fontSize: 16)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a processing button for different tasks.
  Widget _buildButton(String label, String task) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: isLoading ? null : () => processFile(task),
      child: Text(label, style: TextStyle(fontSize: 16)),
    );
  }
}

/// **PDF Viewer Screen**
/// Displays the selected PDF file.
class PDFViewerScreen extends StatelessWidget {
  final String filePath;

  const PDFViewerScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}
