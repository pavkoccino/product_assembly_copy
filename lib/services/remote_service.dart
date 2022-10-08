import 'package:http/http.dart' as http;

import 'package:product_assembly/models/branch.dart';
import 'temp_file_writing_service.dart';

class RemoteService {
  Future<List<Branch>?> getBranches(int gitlabProductId) async {
    var client = http.Client();
    var uri = Uri.parse(
        "https://random.gitlab.url.com/api/v4/projects/99999/repository/branches?private_token=xxxxxxxxx&per_page=100");
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      return branchesFromJson(json);
    } else {
      return [];
    }
  }

  Future<String> downloadXMLConfigFile(
      int gitlabProductId,
      String productName,
      String branch,
      bool capitalAssemblyDirectory,
      String nameOfXmlfile) async {
    var headers = {
      'PRIVATE-TOKEN':
          'xxxxxxxxxxxxxxx', //TODO place the token on single place and maybe create different one (read only one)
    };

    var params = {
      'ref': branch,
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    //TODO here is a problem that different branches can have the xml placed in a different path or even in folder with capital (A)ssembly causes an issue

    String urlAddress =
        "https://random.gitlab.url.com/api/v4/projects/99999/repository/files/assembly%2F$nameOfXmlfile/raw?$query";
    if (capitalAssemblyDirectory) {
      urlAddress = urlAddress.replaceAll("assembly", "Assembly");
    }

    var url = Uri.parse(urlAddress);
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      // TODO COME UP WITH DIFFERENT SOLUTION THAN THIS HACK!!!!
      urlAddress = urlAddress.replaceAll("assembly", "Assembly");
      url = Uri.parse(urlAddress);
      res = await http.get(url, headers: headers);
      if (res.statusCode != 200) {
        throw Exception('http.get error: statusCode= ${res.statusCode}');
      }
    }

    TempFileWriter.writeContent(res.body, branch, ".xml",
        directoryInput: productName);

    await Future.delayed(const Duration(
        seconds:
            1)); // Delay needed, because sometimes this would finish too fast and XML Parsing service wouldn't be able to pull CustomerCodes

    return res.body; // This returns the XML content basically
  }
}
