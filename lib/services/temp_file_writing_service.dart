import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TempFileWriter {
  static String pathToLocalTempDirectory = "";

  static Future<String> get _localPath async {
    final tempDirectory = await getTemporaryDirectory();
    final productDirectory =
        await Directory('${tempDirectory.path}\\BISim_Product_Assembly')
            .create();
    print(productDirectory.path);
    pathToLocalTempDirectory = productDirectory.path;
    return productDirectory.path;
  }

  static Future<File> saveScriptToTemp(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final buffer = byteData.buffer;
    final tempDirectory = await getTemporaryDirectory();
    final productDirectory = await Directory(
            '${tempDirectory.path}\\BISim_Product_Assembly') //Underscores because SPACES WOULD BE A PROBLEM
        .create();

    //TODO THIS HAPPENS FIRST SO IT CAN BE REMOVED FROM _LOCALPATH
    print(productDirectory.path);
    pathToLocalTempDirectory = productDirectory.path;

    var filePath = '${productDirectory.path}\\runAssemblySyncHidden.vbs';
    return File(filePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  // static Future<File> _localFile(String fileName) async {
  //   final localTempPath = await _localPath;
  //   return File('$localTempPath\\$fileName');
  // }

  static Future<File> writeContent(
      String content, String fileName, String fileExtension,
      {String directoryInput = ""}) async {
    var directory = await _localPath;

    if (directory.isNotEmpty) {
      var directoryInside =
          await Directory('$directory\\$directoryInput').create();
      directory = "${directoryInside.path}\\";
    }

    final file = File("$directory$fileName$fileExtension");
    // Write the file
    return file.writeAsString(content);
  }
}
