import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

DateFormat dateFormat = DateFormat("dd.MM.yyyy HH:mm:ss");

class DownloadItem {
  final String id;
  final String title;
  final String productName;
  String? customerCode;
  bool inProgress;
  final Future<Process> triggeredProcess;
  final DownloadQueue queueParent;

  int? exitCode;
  String? dateTimeEnded;

  DownloadItem(
      {required this.id,
      required this.title,
      required this.productName,
      this.customerCode,
      required this.triggeredProcess,
      this.inProgress = true,
      required this.queueParent}) {
    checkProcessStatus();
  }

  checkProcessStatus() async {
    final process = await triggeredProcess;
    final processExitCode = await process.exitCode;
    inProgress = false;
    exitCode = processExitCode;

    dateTimeEnded = dateFormat.format(DateTime.now());
    queueParent.notifyListenersWrap();

    print('AssemblySync exit code: $processExitCode');
  }
}

class DownloadQueue with ChangeNotifier {
  Map<String, DownloadItem> _items = {};

  Map<String, DownloadItem> get items {
    return {..._items};
  }

  int get itemCount {
    int countOfCurrentlyDownloading = 0;
    for (var item in _items.values) {
      if (item.inProgress) {
        countOfCurrentlyDownloading += 1;
      }
    }
    return countOfCurrentlyDownloading;
  }

  void removeItem(String id) {
    _items.removeWhere(
      (key, value) => value.id == id,
    );
    notifyListeners();
  }

  void notifyListenersWrap() {
    // In reality we don't want to delete it, we just want to notify about the change, because the count method should recalculate
    notifyListeners();
  }

  //TODO GIVE USERS OPTION TO CANCEL THE SYNC AT ANY TIME

  void addItem(String productName, String branch, String? customerCode,
      Future<Process> triggeredProcess) {
    // Logic to handle what you are already syncing
    _items.putIfAbsent(
        "Product $productName at: ${dateFormat.format(DateTime.now())} branch: $branch",
        () => DownloadItem(
            id: dateFormat.format(DateTime.now()),
            productName: productName,
            title: branch,
            customerCode: customerCode,
            triggeredProcess: triggeredProcess,
            queueParent: this));
    notifyListeners();
  }
}
