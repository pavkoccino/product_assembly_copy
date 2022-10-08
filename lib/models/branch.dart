// To parse this JSON data, do
//
//     final branches = branchesFromJson(jsonString);

import 'dart:convert';

List<Branch> branchesFromJson(String str) =>
    List<Branch>.from(json.decode(str).map((x) => Branch.fromJson(x)));

String branchesToJson(List<Branch> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Branch {
  Branch({
    required this.name,
    this.commit,
    this.merged,
    this.protected,
    this.developersCanPush,
    this.developersCanMerge,
    this.canPush,
    this.branchDefault,
    this.webUrl,
    this.capitalAssemblyDirectory = false,
  });

  String name;
  Commit? commit;
  bool? merged;
  bool? protected;
  bool? developersCanPush;
  bool? developersCanMerge;
  bool? canPush;
  bool? branchDefault;
  String? webUrl;
  bool capitalAssemblyDirectory;

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        name: json["name"],
        commit: Commit.fromJson(json["commit"]),
        merged: json["merged"],
        protected: json["protected"],
        developersCanPush: json["developers_can_push"],
        developersCanMerge: json["developers_can_merge"],
        canPush: json["can_push"],
        branchDefault: json["default"],
        webUrl: json["web_url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "commit": commit?.toJson(),
        "merged": merged,
        "protected": protected,
        "developers_can_push": developersCanPush,
        "developers_can_merge": developersCanMerge,
        "can_push": canPush,
        "default": branchDefault,
        "web_url": webUrl,
      };
}

class Commit {
  Commit({
    required this.id,
    this.shortId,
    this.createdAt,
    this.parentIds,
    this.title,
    this.message,
    this.authorName,
    this.authorEmail,
    this.authoredDate,
    this.committerName,
    this.committerEmail,
    this.committedDate,
    this.trailers,
    this.webUrl,
  });

  String id;
  String? shortId;
  DateTime? createdAt;
  dynamic? parentIds;
  String? title;
  String? message;
  String? authorName;
  String? authorEmail;
  DateTime? authoredDate;
  String? committerName;
  String? committerEmail;
  DateTime? committedDate;
  dynamic? trailers;
  String? webUrl;

  factory Commit.fromJson(Map<String, dynamic> json) => Commit(
        id: json["id"],
        shortId: json["short_id"],
        createdAt: DateTime.parse(json["created_at"]),
        parentIds: json["parent_ids"],
        title: json["title"],
        message: json["message"],
        authorName: json["author_name"],
        authorEmail: json["author_email"],
        authoredDate: DateTime.parse(json["authored_date"]),
        committerName: json["committer_name"],
        committerEmail: json["committer_email"],
        committedDate: DateTime.parse(json["committed_date"]),
        trailers: json["trailers"],
        webUrl: json["web_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "short_id": shortId,
        "created_at": createdAt?.toIso8601String(),
        "parent_ids": parentIds,
        "title": title,
        "message": message,
        "author_name": authorName,
        "author_email": authorEmail,
        "authored_date": authoredDate?.toIso8601String(),
        "committer_name": committerName,
        "committer_email": committerEmail,
        "committed_date": committedDate?.toIso8601String(),
        "trailers": trailers,
        "web_url": webUrl,
      };
}
