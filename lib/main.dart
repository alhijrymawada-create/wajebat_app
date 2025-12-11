import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;


  void _readTextFile() async{
    final Directory tempDir = await getTemporaryDirectory();
    print(tempDir);

    final File file = File('${tempDir.path}/file_picker/a text file 005.txt');

    final String fileContent = await file.readAsString();

    print(fileContent);

    setState(() {

      filecontaint=fileContent.toString();

    });
  }
  void _readTextFile2(File? path) async{
    final Directory tempDir = await getTemporaryDirectory();
    print(tempDir);

    //final File file = File(path);

    final String fileContent = await path!.readAsString();

    print(fileContent);

    setState(() {

      filecontaint=fileContent.toString();

    });
  }
  void _saveTextFile() async{
    // this next 4 line to write a file in temp Directory
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('/storage/emulated/0/Download/'+filename.text+".text");
    print(""+tempDir.toString());
    await file.writeAsString(newnote.text);
    setState(() {
      newnote.text="";
      filename.text="";


    });
  }

  void _incrementCounter() async{



    /*////////////here we creat a file in side our own Dir in temp folder
    final Directory tempDir = await getTemporaryDirectory();
    final Directory newDirectory =
    Directory('${tempDir.path}/sample_directoryNo'+_counter.toString());

// Always check that the directory exists
    if (await newDirectory.exists() == false) {
      await newDirectory.create();
    }

    final File file = File('${newDirectory.path}/sample_file'+_counter.toString()+'.txt');
    print(""+tempDir.toString());
    await file.writeAsString('this file writen as the try No.'+_counter.toString());*/

    //////////////// reading a file from temp

    // final appDocuments = await getApplicationDocumentsDirectory();
    //print(appDocuments);
    //print("mazin");
    setState(() {

      _counter++;
    });
  }
  late String filecontaint="";
  TextEditingController newnote=TextEditingController();
  TextEditingController filename=TextEditingController();


  @override
  Widget build(BuildContext context) {
    File? file;
    FilePickerResult? result;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(filecontaint),
          ElevatedButton(
            onPressed: () async {
              try {
                result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  if (!kIsWeb) {
                    file = File(result!.files.single.path!);
                    _readTextFile2(file);
                  }
                  setState(() {});
                } else {
                  print("user cancled the picker");
                  // User canceled the picker
                }
              } catch (_) {}
            },
            child: const Text('Pick a Text file File'),
          ),

          TextField(
            controller: filename,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'file Name',
              hintText: 'Enter the a file to name to save the note to ',
            ),
          ),TextField(
            controller: newnote,
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter a note',
              hintText: 'Enter your Note overe here',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              _saveTextFile();
            },
            child: const Text('save a text'),
          ),


        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _readTextFile,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}