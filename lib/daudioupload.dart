import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicproject/common.dart';
import 'package:sizer/sizer.dart';

class AudioUploadPage extends StatefulWidget {
  @override
  _AudioUploadPageState createState() => _AudioUploadPageState();
}

class _AudioUploadPageState extends State<AudioUploadPage> {
  File? _audioFile;
  TextEditingController _audioNameController = TextEditingController();
  bool _uploading = false;

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _audioFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_audioFile != null) {
      setState(() {
        _uploading = true;
      });

      final uri = Uri.parse(audiouploaduri);
      final request = http.MultipartRequest('POST', uri);
      request.fields['additional_data'] = _audioNameController.text;
      request.files.add(
        await http.MultipartFile.fromPath(
          'audio',
          _audioFile!.path,
          contentType: MediaType(
              'audio', 'mp3'), // Change the content type as per your file type
        ),
      );

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        print('File uploaded successfully');
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File uploaded successfully'),
          ),
        );
        // Reset state to clear input fields and file selection
        setState(() {
          _audioFile = null;
          _audioNameController.clear();
          _uploading = false;
        });
      } else {
        print('Failed to upload file: ${response.body}');
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload file'),
          ),
        );
        setState(() {
          _uploading = false;
        });
      }
    } else {
      // Show error message that no file selected
      print('No file selected');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No file selected'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Audio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/audioupload.png',
              width: 80.w,
              height: 50.h,
            ),
            ElevatedButton(
              onPressed: _selectFile,
              child: Text('Select Audio File',
                  style: TextStyle(color: Color.fromARGB(255, 248, 128, 136))),
            ),
            SizedBox(height: 20),
            _audioFile != null
                ? Text(_audioFile!.path)
                : Text('No file selected'),
            SizedBox(height: 20),
            TextField(
              controller: _audioNameController,
              decoration: InputDecoration(
                labelText: 'Audio Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploading ? null : _uploadFile,
              child: Text(
                'Upload Audio',
                style: TextStyle(color: Color.fromARGB(255, 248, 128, 136)),
              ),
            ),
            SizedBox(height: 20),
            if (_uploading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
