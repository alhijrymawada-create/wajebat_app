import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'textfiles.dart';
import 'sqldb.dart';

String x = "";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'File Manager'),
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
  SqlDb sqlDb = SqlDb();
  Textfiles fileobj = Textfiles();

  File? selectedFile;
  String fileContent = "";

  TextEditingController newnote = TextEditingController();
  TextEditingController filename = TextEditingController();
  TextEditingController dirName = TextEditingController();

  // ------------ التعديل هنا --------------------
  Future pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        withData: true, // مهم للويب
      );

      if (result == null) {
        print("User cancelled");
        return;
      }

      final picked = result.files.single;

      if (kIsWeb) {
        /// الويب: لا يوجد path → نستخدم bytes
        final bytes = picked.bytes;
        if (bytes != null) {
          fileContent = String.fromCharCodes(bytes);
        } else {
          fileContent = "No data available";
        }
      } else {
        /// Android / iOS
        final path = picked.path;
        if (path != null) {
          selectedFile = File(path);
          fileContent = await fileobj.readTextFile2(selectedFile);
        }
      }

      setState(() {});
    } catch (e) {
      print("Pick error: $e");
    }
  }
  // ------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Text(
              fileContent,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: pickFile,
              child: const Text('Pick a Text File'),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: filename,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'File Name',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: newnote,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter a Note',
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                await fileobj.saveTextFile(filename.text, newnote.text);
                setState(() {
                  x = newnote.text;
                  filename.clear();
                  newnote.clear();
                });
              },
              child: const Text('Save Text'),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: dirName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Directory Name',
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                await fileobj.creatDir(dirName.text);
              },
              child: const Text('Create Directory'),
            ),

            ElevatedButton(
              onPressed: () async {
                await fileobj.getthepath();
              },
              child: const Text('Get Path'),
            ),

            ElevatedButton(
              onPressed: () async {
                List<Map> response =
                await sqlDb.readData("SELECT * FROM department");
                print(response);
              },
              child: const Text('Select All From DB'),
            ),

            ElevatedButton(
              onPressed: () async {
                int response = await sqlDb.deleteData("DELETE FROM std_info2");
                print(response);
              },
              child: const Text('Delete DB Data'),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String temp = await fileobj.readTextFile();
          setState(() {
            fileContent = temp;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
