import 'package:flutter/material.dart';
import 'package:product_assembly/widgets/component_group.dart';
import 'package:product_assembly/widgets/component_row.dart';

class XMLConfigurationScreen extends StatelessWidget {
  XMLConfigurationScreen({Key? key}) : super(key: key);

  static const routeName = "/xmlConfiguration";

  final List<ComponentGroup> componentsGroupList = [
    const ComponentGroup(componentGroupName: "Engine", componentRowsList: [
      ComponentRow(artifactoryPath: "Drivers"),
      ComponentRow(artifactoryPath: "Engine")
    ]),
    const ComponentGroup(componentGroupName: "Test", componentRowsList: [
      ComponentRow(artifactoryPath: "xxx"),
      ComponentRow(artifactoryPath: "sss")
    ]),
    const ComponentGroup(componentGroupName: "Test", componentRowsList: [
      ComponentRow(artifactoryPath: "xxx"),
      ComponentRow(artifactoryPath: "sss")
    ]),
    const ComponentGroup(componentGroupName: "Test", componentRowsList: [
      ComponentRow(artifactoryPath: "xxx"),
      ComponentRow(artifactoryPath: "sss")
    ])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("XML configuration"),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 120,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: componentsGroupList.length,
              itemBuilder: (context, index) {
                return (componentsGroupList[index]);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      // TODO save the edited xml
                      Navigator.of(context).pop();
                    },
                    child: const Text("Save & Close")),
              ),
            ],
          )
        ],
      ),
    );
  }
}
