import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:product_assembly/providers/download_queue.dart';
import 'package:product_assembly/screens/download_queue_screen.dart';
import 'package:product_assembly/screens/xml_configuration_screen.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import './screens/product_selection_screen.dart';
import './screens/credentials_configuration_screen.dart';
import './screens/destination_selection_screen.dart';
import 'colors/material_color_generator.dart';

int? initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  print('initScreen ${initScreen}');
  runApp(ProductAssemblyApp());
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods like buildOverscrollIndicator and buildScrollbar
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class ProductAssemblyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => DownloadQueue())],
      child: MaterialApp(
          scrollBehavior:
              CustomScrollBehavior(), // Need to override scrollBehavior otherwise some Scrollable things don't work on Windows (because they don't react to the mouse click)
          title: 'Products',
          theme: ThemeData(
              primarySwatch:
                  generateMaterialColor(Color.fromARGB(255, 35, 40, 51)),
              accentColor: Colors.lightGreen),
          debugShowCheckedModeBanner: false,
          initialRoute: initScreen == 0 || initScreen == null
              ? CredentialsConfigurationScreen.routeName
              : ProductAssembly.routeName,
          routes: {
            ProductAssembly.routeName: (context) => ProductAssembly(),
            CredentialsConfigurationScreen.routeName: (context) =>
                CredentialsConfigurationScreen(),
            DestinationSelectionScreen.routeName: (context) =>
                DestinationSelectionScreen(),
            DownloadQueueScreen.routeName: (context) => DownloadQueueScreen(),
            XMLConfigurationScreen.routeName: (context) =>
                XMLConfigurationScreen()
          }),
    );
  }
}
