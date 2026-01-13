class CourseCategory {
  final String jobRolesOffered;
  final bool placementAssistance;
  final String placementType; // Assisted, Guaranteed
  final double placementRate; // percentage
  final String advantagesHighlights;
  final double courseFees;

  CourseCategory({
    required this.jobRolesOffered,
    required this.placementAssistance,
    required this.placementType,
    required this.placementRate,
    required this.advantagesHighlights,
    required this.courseFees,
  });

  factory CourseCategory.fromJson(Map<String, dynamic> json) {
    return CourseCategory(
      jobRolesOffered: json['jobRolesOffered'] as String,
      placementAssistance: json['placementAssistance'] as bool,
      placementType: json['placementType'] as String,
      placementRate: json['placementRate'] as double,
      advantagesHighlights: json['advantagesHighlights'] as String,
      courseFees: json['courseFees'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobRolesOffered': jobRolesOffered,
      'placementAssistance': placementAssistance,
      'placementType': placementType,
      'placementRate': placementRate,
      'advantagesHighlights': advantagesHighlights,
      'courseFees': courseFees,
    };
  }
}

class Course {
  final String id;
  final String name;
  final String description;
  final String code;
  final String weightRequirements;
  final String heightRequirements;
  final String visionStandards;
  final String medicalRequirements;
  final String minEducationalQualification;
  final String ageCriteria;
  final bool internshipIncluded;
  final bool installmentAvailable;
  final String installmentPolicy;
  final String? photoUrl;
  final String? videoUrl;
  final CourseCategory generalCategory;
  final CourseCategory executiveCategory;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.weightRequirements,
    required this.heightRequirements,
    required this.visionStandards,
    required this.medicalRequirements,
    required this.minEducationalQualification,
    required this.ageCriteria,
    required this.internshipIncluded,
    required this.installmentAvailable,
    required this.installmentPolicy,
    this.photoUrl,
    this.videoUrl,
    required this.generalCategory,
    required this.executiveCategory,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      code: json['code'] as String,
      weightRequirements: json['weightRequirements'] as String,
      heightRequirements: json['heightRequirements'] as String,
      visionStandards: json['visionStandards'] as String,
      medicalRequirements: json['medicalRequirements'] as String,
      minEducationalQualification:
          json['minEducationalQualification'] as String,
      ageCriteria: json['ageCriteria'] as String,
      internshipIncluded: json['internshipIncluded'] as bool,
      installmentAvailable: json['installmentAvailable'] as bool,
      installmentPolicy: json['installmentPolicy'] as String,
      photoUrl: json['photoUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      generalCategory: CourseCategory.fromJson(
        json['generalCategory'] as Map<String, dynamic>,
      ),
      executiveCategory: CourseCategory.fromJson(
        json['executiveCategory'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'code': code,
      'weightRequirements': weightRequirements,
      'heightRequirements': heightRequirements,
      'visionStandards': visionStandards,
      'medicalRequirements': medicalRequirements,
      'minEducationalQualification': minEducationalQualification,
      'ageCriteria': ageCriteria,
      'internshipIncluded': internshipIncluded,
      'installmentAvailable': installmentAvailable,
      'installmentPolicy': installmentPolicy,
      'photoUrl': photoUrl,
      'videoUrl': videoUrl,
      'generalCategory': generalCategory.toJson(),
      'executiveCategory': executiveCategory.toJson(),
    };
  }
}
