import 'package:flutter/material.dart';

import 'component_row.dart';

class ComponentGroup extends StatelessWidget {
  const ComponentGroup(
      {Key? key,
      required this.componentGroupName,
      required this.componentRowsList})
      : super(key: key);

  final String componentGroupName;
  final List<ComponentRow> componentRowsList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 9.0, top: 5.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(200, 235, 186, 9),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              padding: const EdgeInsets.all(10.0),
              child: Text(componentGroupName,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.only(left: 9.0, right: 9.0, bottom: 5),
          elevation: 5,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 90,
                  ),
                  Text("Version"),
                  SizedBox(
                    width: 100,
                  ),
                  Text("Installer Option"),
                ],
              ),
              ...componentRowsList
            ],
          ),
        ),
      ],
    );
  }
}
