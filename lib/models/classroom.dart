class ClassroomContent {
  String heading;
  String description;
  String youtubeLink;
  DateTime date;

  ClassroomContent({
    required this.heading,
    required this.description,
    required this.youtubeLink,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'heading': heading,
    'description': description,
    'youtubeLink': youtubeLink,
    'date': date.toIso8601String(),
  };

  factory ClassroomContent.fromJson(Map<String, dynamic> json) =>
      ClassroomContent(
        heading: json['heading'] ?? '',
        description: json['description'] ?? '',
        youtubeLink: json['youtubeLink'] ?? '',
        date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      );
}

class Classroom {
  String id;
  String name;
  String description;
  String imageUrl;
  String creator;
  List<String> admins;
  List<String> members;
  List<ClassroomContent> contents;

  Classroom({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.creator,
    List<String>? admins,
    List<String>? members,
    List<ClassroomContent>? contents,
  }) : admins = admins ?? [],
       members = members ?? [],
       contents = contents ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'creator': creator,
    'admins': admins,
    'members': members,
    'contents': contents.map((c) => c.toJson()).toList(),
  };

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    creator: json['creator'] ?? '',
    admins: List<String>.from(json['admins'] ?? []),
    members: List<String>.from(json['members'] ?? []),
    contents:
        (json['contents'] as List<dynamic>?)
            ?.map(
              (e) => ClassroomContent.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList() ??
        [],
  );
}
