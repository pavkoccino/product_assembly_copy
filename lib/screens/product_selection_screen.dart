import 'package:flutter/material.dart';
import 'package:product_assembly/arguments/destination_selection_screen_args.dart';

import 'package:product_assembly/models/branch.dart';
import 'package:product_assembly/models/product.dart';
import 'package:product_assembly/screens/credentials_configuration_screen.dart';
import 'package:product_assembly/screens/download_queue_screen.dart';
import 'package:product_assembly/services/remote_service.dart';
import 'package:provider/provider.dart';

import '../providers/download_queue.dart';
import '../widgets/badge.dart';
import 'destination_selection_screen.dart';
import '../products_data.dart';

class ProductAssembly extends StatefulWidget {
  static const routeName = '/productSelection';

  @override
  State<ProductAssembly> createState() => _ProductAssemblyState();
}

class _ProductAssemblyState extends State<ProductAssembly> {
  List<Branch>? branches;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    //Load gitlab branches
    loadAvailableBranches(
        products[0]); //On init call it for the first product in the list
  }

  loadAvailableBranches(Product product) async {
    if (product.availableBuilds.isNotEmpty) {
      setState(() {
        isLoaded = true;
      });
      return;
    }

    setState(() {
      isLoaded = false;
    });

    branches = await RemoteService().getBranches(product.gitlabProductId);

    if (branches != null) {
      product.availableBuilds = branches!
          .where((branch) =>
              branch.name.startsWith('release') ||
              branch.name == 'master' ||
              branch.name == 'pre-release')
          .toList();

      //TODO this is hacky as F come up with different solution
      for (var branch in product.availableBuilds) {
        if (branch.name.startsWith('release') &&
            (branch.name.contains('19') ||
                branch.name.contains('20') ||
                branch.name.contains('21'))) {
          if (product.gitlabProductId == 3582) // In case of VBS4
          {
            branch.capitalAssemblyDirectory = true;
          }
        }
      }

      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: products.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: products
                .map((product) => Tab(
                      icon: Image.asset(product.iconSrc),
                      text: product.name,
                    ))
                .toList(),
            onTap: (index) => loadAvailableBranches(products[index]),
          ),
          title: const Text('Products'),
          actions: <Widget>[
            Container(
                padding: const EdgeInsets.all(10),
                child: Consumer<DownloadQueue>(
                    builder: (_, queueData, ch) => Badge(
                        value: queueData.itemCount.toString(),
                        color: Theme.of(context).accentColor,
                        child: ch as Widget),
                    child: IconButton(
                      splashRadius: 1,
                      iconSize: 26,
                      icon: const Icon(
                        Icons.download,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(DownloadQueueScreen.routeName);
                      },
                    ))),
            Container(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                splashRadius: 1,
                iconSize: 26,
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(CredentialsConfigurationScreen.routeName);
                },
              ),
            )
          ],
        ),
        body: Visibility(
            visible: isLoaded,
            replacement: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text('Loading branches...')
                ],
              ),
            ),
            child: TabBarView(
                children: products
                    .map((product) => ListView.builder(
                          itemBuilder: ((context, index) => Column(
                                children: [
                                  ListTile(
                                    leading: Image.asset(
                                        'assets/icons/git_branch_icon.png'),
                                    title: Text(
                                        product.availableBuilds[index].name),
                                    onTap: () async {
                                      showDialog(
                                        barrierDismissible: false,
                                        builder: (ctx) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                              Text(
                                                  'Loading customer codes for the branch...')
                                            ],
                                          );
                                        },
                                        context: context,
                                      );
                                      await RemoteService()
                                          .downloadXMLConfigFile(
                                              product.gitlabProductId,
                                              product.name,
                                              product
                                                  .availableBuilds[index].name,
                                              product.availableBuilds[index]
                                                  .capitalAssemblyDirectory,
                                              product.nameOfXmlFile)
                                          .then((contentOfTheXMLFile) {
                                        Navigator.of(context)
                                            .pop(); // Popping the showDialog
                                        Navigator.of(context).pushNamed(
                                          DestinationSelectionScreen.routeName,
                                          arguments:
                                              DestinationSelectionScreenArguments(
                                                  product.name,
                                                  product.availableBuilds[index]
                                                      .name,
                                                  contentOfTheXMLFile),
                                        );
                                      });
                                    },
                                  )
                                ],
                              )),
                          itemCount: product.availableBuilds.length,
                        ))
                    .toList())),
      ),
    );
  }
}
