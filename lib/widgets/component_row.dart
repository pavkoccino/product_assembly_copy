import 'package:flutter/material.dart';

class ComponentRow extends StatelessWidget {
  const ComponentRow({Key? key, required this.artifactoryPath})
      : super(key: key);

  final String artifactoryPath; //Name of the row

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(width: 50, child: Text(artifactoryPath)),
        ),
        //Version
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: DropdownButton<String>(
            items: <String>['999.999', '888.888', '777.777', '666.666']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ),
        //InstallerOption
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: DropdownButton<String>(
            items: <String>[
              'driver',
              'driver\\firewallexceptions',
              'driver\\vcRedist\\2005 x64'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        )
        //Restricted TODO
        //Restricted_except TODO
      ],
    );
  }
}
