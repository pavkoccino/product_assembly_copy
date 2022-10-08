import 'package:product_assembly/models/branch.dart';

class Product {
  final String name;
  List<Branch> availableBuilds;
  final String iconSrc;
  final int gitlabProductId;
  final String nameOfXmlFile;

  Product(
      {required this.name,
      required this.availableBuilds,
      required this.iconSrc,
      required this.gitlabProductId,
      required this.nameOfXmlFile});
}
