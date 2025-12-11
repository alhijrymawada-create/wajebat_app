import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'sqldb.dart';

class Textfiles {
  SqlDb sqlDb = SqlDb();

  Future<String> readTextFile() async {
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/file_picker/hihihi.text');

    if (!await file.exists()) return "File not found";

    return await file.readAsString();
  }

  Future<String> readTextFile2(File? filepath) async {
    if (filepath == null) return "No file";

    List<String> lines = await filepath.readAsLines();
    int count = 0;

    for (var line in lines) {
      List<String> s = line.split(",");

      if (count > 6 && s[0] != "") {
        String sqlQ =
            "INSERT INTO std_info2 (StdID, DeptID, StdName, level) VALUES ('${s[2]}','1','${s[1]}','4')";
        await sqlDb.insertData(sqlQ);
      }

      count++;
    }

    return lines.length > 2 ? lines[2] : "";
  }

  Future saveTextFile(String filename, String content) async {
    var status = await Permission.storage.request();

    if (!status.isGranted) {
      print("No permission");
      return;
    }

    final file = File('/storage/emulated/0/Documents/$filename.txt');

    await file.writeAsString(content);
  }

  Future creatDir(String dirname) async {
    var status = await Permission.storage.request();

    if (!status.isGranted) return;

    final Directory dir = Directory('/storage/emulated/0/$dirname');

    if (!await dir.exists()) {
      await dir.create();
    }

    final File file = File('${dir.path}/sample.txt');
    await file.writeAsString("Directory created successfully");
  }

  Future getthepath() async {
    final temp = await getTemporaryDirectory();
    final appSupport = await getApplicationSupportDirectory();
    final docs = await getApplicationDocumentsDirectory();

    print("Temp: $temp");
    print("Support: $appSupport");
    print("Docs: $docs");
  }
}
