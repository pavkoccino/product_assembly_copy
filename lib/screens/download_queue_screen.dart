import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/download_queue.dart' show DownloadQueue;
import '../widgets/download_item.dart';

class DownloadQueueScreen extends StatelessWidget {
  static const routeName = '/downloadQueue';

  @override
  Widget build(BuildContext context) {
    final downloadQueue = Provider.of<DownloadQueue>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Queue'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: downloadQueue.items.length,
                itemBuilder: (ctx, i) => DownloadItem(
                  id: downloadQueue.items.values.toList()[i].id,
                  productName:
                      downloadQueue.items.values.toList()[i].productName,
                  branch: downloadQueue.items.values.toList()[i].title,
                  inProgress: downloadQueue.items.values.toList()[i].inProgress,
                  customerCode:
                      downloadQueue.items.values.toList()[i].customerCode,
                  exitCode: downloadQueue.items.values.toList()[i].exitCode,
                  dateTimeEnded:
                      downloadQueue.items.values.toList()[i].dateTimeEnded,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
