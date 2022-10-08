import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import 'package:product_assembly/arguments/destination_selection_screen_args.dart';
import 'package:product_assembly/providers/download_queue.dart';
import 'package:product_assembly/screens/xml_configuration_screen.dart';
import 'package:product_assembly/services/temp_file_writing_service.dart';
import 'package:product_assembly/services/xml_parsing_service.dart';
import 'package:provider/provider.dart';

import 'download_queue_screen.dart';

class DestinationSelectionScreen extends StatefulWidget {
  const DestinationSelectionScreen({Key? key}) : super(key: key);

  static const routeName = '/destinationSelection';

  @override
  State<DestinationSelectionScreen> createState() =>
      _DestinationSelectionScreenState();
}

class _DestinationSelectionScreenState
    extends State<DestinationSelectionScreen> {
  String? destinationPath = '';
  bool flatBuildStructure = true;
  String dropDownCustomerCode = 'WOCRM';
  late Future<List<String>> customerCodes;
  late DestinationSelectionScreenArguments receivedArgs;
  bool _isValidated = false;

  final destinationPathTextFieldFormController = TextEditingController();

  void _openFilePicker() async {
    String? selection = await FilePicker.platform.getDirectoryPath();
    if (selection != null) {
      destinationPath = selection;
      destinationPathTextFieldFormController.text = destinationPath!;
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    receivedArgs = ModalRoute.of(context)?.settings.arguments
        as DestinationSelectionScreenArguments;
    customerCodes = XMLParser().getAvailableCustomerCodes(
        receivedArgs.selectedProduct, receivedArgs.selectedBranch);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    destinationPathTextFieldFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double maxCalculatedHeight = (size.height -
        kToolbarHeight -
        186); // The fixed 186 pixels are for the Widgets that are above
    // final double itemWidth = size.width;
    final downloadQueue = Provider.of<DownloadQueue>(context, listen: false);
    destinationPathTextFieldFormController.addListener(() {
      setState(() {
        //you can check here if your text is valid or no
        //_isValidText() is just an invented function that returns
        //a boolean representing if the text is valid or not
        if (destinationPathTextFieldFormController.text.isNotEmpty &&
            Directory(destinationPathTextFieldFormController.text)
                .existsSync()) {
          _isValidated = true;
        } else {
          _isValidated = false;
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Destination selection for product: ${receivedArgs.selectedProduct}, branch: ${receivedArgs.selectedBranch}')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Flat build structure:'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Switch(
                  value: flatBuildStructure,
                  onChanged: (value) {
                    setState(() {
                      flatBuildStructure = value;
                    });
                  }),
            ),
            const Spacer(),
            Visibility(
              visible: flatBuildStructure,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  children: [
                    Text('Select the customer code: '),
                    FutureBuilder<List<String>>(
                        future: customerCodes,
                        builder: (context, snapshot) {
                          return DropdownButton<String>(
                              hint: Text("Select"),
                              value: dropDownCustomerCode,
                              onChanged: (newValue) {
                                setState(() {
                                  dropDownCustomerCode = newValue!;
                                });
                              },
                              items: snapshot.data?.map((fc) {
                                return DropdownMenuItem<String>(
                                  child: Text(fc),
                                  value: fc,
                                );
                              }).toList());
                        }),
                  ],
                ),
              ),
            )
          ]),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 30,
                    child: TextFormField(
                      controller: destinationPathTextFieldFormController,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(bottom: 10, left: 10),
                        labelText:
                            'Destination, where the product will be assembled',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                    onPressed: _openFilePicker,
                    child: const Text('Select destination folder')),
              )
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: maxCalculatedHeight,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Center(
                      child: Text(
                        receivedArgs.contentOfTheXMLfile.replaceAll('\t',
                            '    '), // \t is displaying squares on Windows for some reason, issue is here https://github.com/flutter/flutter/issues/79153
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, XMLConfigurationScreen.routeName);
                  },
                  child: const Text("Edit XML configuration")),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: _isValidated
                        ? () {
                            // String fullPathToAssemblySyncScript = path.absolute(
                            //     'lib\\scripts\\runAssemblySyncHidden.vbs');
                            // print(fullPathToAssemblySyncScript);
                            String pathToAssemblySyncScript =
                                "${TempFileWriter.pathToLocalTempDirectory}\\runAssemblySyncHidden.vbs";

                            print(pathToAssemblySyncScript);
                            downloadQueue.addItem(
                                receivedArgs.selectedProduct,
                                receivedArgs.selectedBranch,
                                flatBuildStructure
                                    ? dropDownCustomerCode
                                    : null,
                                Process.start(
                                    pathToAssemblySyncScript,
                                    [
                                      "${TempFileWriter.pathToLocalTempDirectory}\\${receivedArgs.selectedProduct}\\${receivedArgs.selectedBranch}.xml",
                                      destinationPath!,
                                      "${TempFileWriter.pathToLocalTempDirectory}\\credentials.json",
                                      dropDownCustomerCode,
                                      toBeginningOfSentenceCase(
                                          flatBuildStructure.toString())!
                                    ],
                                    runInShell:
                                        true)); // TODO move the process to the download_queue, here just pass the data

                            Navigator.of(context).pushReplacementNamed(
                                DownloadQueueScreen.routeName);
                          }
                        : null,
                    child: const Text('Start the assembly')),
              )
            ],
          ),
        ],
      ),
    );
  }
}
