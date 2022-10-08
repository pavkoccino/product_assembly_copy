import 'package:product_assembly/models/product.dart';

final products = [
  Product(
      name: "VBS4",
      availableBuilds: [],
      iconSrc: 'assets/icons/VBS4_32x32.png',
      gitlabProductId: 3582,
      nameOfXmlFile: "vbs4%2Exml"),
  Product(
      name: "VWS",
      availableBuilds: [],
      iconSrc: 'assets/icons/VWS_32x32.png',
      gitlabProductId: 4204,
      nameOfXmlFile: "vws%2Exml")
  // Add products here in case you'd like to extend this app
  // the "." inside the nameOfXmlFile needs to be written like this > %2E
];
