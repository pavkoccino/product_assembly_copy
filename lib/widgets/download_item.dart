import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/download_queue.dart';

class DownloadItem extends StatelessWidget {
  final String id;
  final String branch;
  final String productName;
  late String? customerCode;
  final bool inProgress;
  final int? exitCode;
  final String? dateTimeEnded;

  DownloadItem(
      {Key? key,
      required this.id, //ID is a DateTimeStarted!
      required this.branch,
      required this.productName,
      this.customerCode,
      required this.inProgress,
      this.exitCode,
      this.dateTimeEnded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String trailingText = 'Sync ${exitCode == 0 ? "successful" : "failed"}';
    String titleText =
        'Branch: $branch${(customerCode != null) ? ", Customer Code: $customerCode" : ", Flat build structure"}';

    String subtitleText =
        'Started: $id${(inProgress == false) ? "\nEnded: $dateTimeEnded\nTook: ${DateFormat("dd.MM.yyyy HH:mm:ss").parse(dateTimeEnded!).difference(DateFormat("dd.MM.yyyy HH:mm:ss").parse(id)).inMinutes} mins" : ""}';

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text('$productName'),
              ),
            ),
          ),
          title: Text(titleText),
          subtitle: Text(subtitleText),
          trailing: inProgress
              ? const CircularProgressIndicator()
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trailingText,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: exitCode == 0
                              ? Color.fromARGB(255, 34, 128, 37)
                              : Colors.red),
                    ),
                    Visibility(
                      visible: !inProgress,
                      child: IconButton(
                          splashRadius: 1,
                          onPressed: () {
                            Provider.of<DownloadQueue>(context, listen: false)
                                .removeItem(id);
                          },
                          icon: const Icon(
                            Icons.delete,
                          )),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
