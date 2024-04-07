import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:medicproject/common.dart';
import 'package:sizer/sizer.dart';

class MedUploadPage extends StatefulWidget {
  @override
  _MedUploadPageState createState() => _MedUploadPageState();
}

class _MedUploadPageState extends State<MedUploadPage> {
  late String videoTitle;
  final TextEditingController _titleController = TextEditingController();
  File? _videoFile;
  String _fileName = '';
  bool _uploading = false; // Track upload progress

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      videoTitle = _titleController.text;
    });
  }

  Future<void> selectVideoFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      setState(() {
        _videoFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> uploadVideoFile() async {
    if (_videoFile == null || _fileName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a video file first')));
      return;
    }

    setState(() {
      _uploading = true; // Start uploading
    });

    try {
      final serverURL = meduploaduri;
      final request = http.MultipartRequest('POST', Uri.parse(serverURL));
      request.fields['video_title'] = videoTitle;

      final fileStream = http.ByteStream(_videoFile!.openRead());
      final fileLength = await _videoFile!.length();
      final fileName = _fileName;

      final multipartFile = http.MultipartFile(
        'uploaded_file',
        fileStream,
        fileLength,
        filename: fileName,
      );

      request.files.add(multipartFile);

      final response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Video uploaded successfully')));
        // Reset state to clear input fields and file selection
        setState(() {
          _videoFile = null;
          _fileName = '';
          _titleController.clear();
          _uploading = false; // Stop uploading
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to upload video')));
        setState(() {
          _uploading = false; // Stop uploading
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      setState(() {
        _uploading = false; // Stop uploading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Video'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/medupload.png',
                height: 40.h,
              ),
              ElevatedButton(
                onPressed: _uploading ? null : selectVideoFile,
                child: Text('Select Video File',
                    style:
                        TextStyle(color: Color.fromARGB(255, 248, 128, 136))),
              ),
              SizedBox(height: 20),
              _uploading
                  ? LinearProgressIndicator() // Show progress indicator while uploading
                  : SizedBox(),
              SizedBox(height: 20),
              _videoFile != null
                  ? Text('Selected video: $_fileName')
                  : Text('No video selected'),
              SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Video Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploading
                    ? null
                    : (_videoFile != null ? uploadVideoFile : null),
                child: Text('Upload Video',
                    style:
                        TextStyle(color: Color.fromARGB(255, 248, 128, 136))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
