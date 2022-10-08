import 'dart:io';

import 'package:product_assembly/services/temp_file_writing_service.dart';
import 'package:xml/xml.dart';

class XMLParser {
  Future<List<String>> getAvailableCustomerCodes(
      String selectedProduct, String selectedBranch) async {
    // final tempDirectory = await getTemporaryDirectory();
    String tempDirectoryPath = TempFileWriter.pathToLocalTempDirectory;

    final pathToTheXML =
        "$tempDirectoryPath\\$selectedProduct\\$selectedBranch.xml";

    Future<String> xmlString = _read(pathToTheXML);
    var xmlRoot = XmlDocument.parse(await xmlString);
    var installers = xmlRoot.findAllElements('Installers');

    final customerCodes = installers.map((node) =>
        (node.findElements('add').map((e) => e.getAttribute('name'))));

    var balbalba = customerCodes.toList();

    List<String> availableCustomers = [];
    for (var element in balbalba[0]) {
      // Not returning 'Shared' because that is the core and we want to definitely sync that everytime
      if (element != 'Shared') {
        availableCustomers.add(element!);
      }
    }

    return availableCustomers;
  }

  Future<String> _read(String pathToTheFile) async {
    String text;
    final File file = File(pathToTheFile);
    text = await file.readAsString();
    return text;
  }
}
