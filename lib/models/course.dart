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
      jobRolesOffered:
          json['job_roles_offered'] as String? ??
          json['jobRolesOffered'] as String? ??
          '',
      placementAssistance:
          json['placement_assistance'] as bool? ??
          json['placementAssistance'] as bool? ??
          false,
      placementType:
          json['placement_type'] as String? ??
          json['placementType'] as String? ??
          '',
      placementRate: (json['placement_rate'] ?? json['placementRate'] ?? 0.0)
          .toDouble(),
      advantagesHighlights:
          json['advantages_highlights'] as String? ??
          json['advantagesHighlights'] as String? ??
          '',
      courseFees: (json['course_fees'] ?? json['courseFees'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_roles_offered': jobRolesOffered,
      'placement_assistance': placementAssistance,
      'placement_type': placementType,
      'placement_rate': placementRate,
      'advantages_highlights': advantagesHighlights,
      'course_fees': courseFees,
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
      id: json['course_id'] as String? ?? json['id'] as String? ?? '',
      name: json['course_name'] as String? ?? json['name'] as String? ?? '',
      description:
          json['course_description'] as String? ??
          json['description'] as String? ??
          '',
      code: json['course_code'] as String? ?? json['code'] as String? ?? '',
      weightRequirements:
          json['weight_requirements'] as String? ??
          json['weightRequirements'] as String? ??
          '',
      heightRequirements:
          json['height_requirements'] as String? ??
          json['heightRequirements'] as String? ??
          '',
      visionStandards:
          json['vision_standards'] as String? ??
          json['visionStandards'] as String? ??
          '',
      medicalRequirements:
          json['medical_requirements'] as String? ??
          json['medicalRequirements'] as String? ??
          '',
      minEducationalQualification:
          json['min_educational_qualification'] as String? ??
          json['minEducationalQualification'] as String? ??
          '',
      ageCriteria:
          json['age_criteria'] as String? ??
          json['ageCriteria'] as String? ??
          '',
      internshipIncluded:
          json['internship_included'] as bool? ??
          json['internshipIncluded'] as bool? ??
          false,
      installmentAvailable:
          json['installment_available'] as bool? ??
          json['installmentAvailable'] as bool? ??
          false,
      installmentPolicy:
          json['installment_policy'] as String? ??
          json['installmentPolicy'] as String? ??
          '',
      photoUrl: json['course_photo'] as String? ?? json['photoUrl'] as String?,
      videoUrl: json['course_video'] as String? ?? json['videoUrl'] as String?,
      generalCategory: json['generalCategory'] != null
          ? CourseCategory.fromJson(
              json['generalCategory'] as Map<String, dynamic>,
            )
          : json['category_data'] != null &&
                json['course_category'] == 'general'
          ? CourseCategory.fromJson(
              json['category_data'] as Map<String, dynamic>,
            )
          : CourseCategory(
              jobRolesOffered: '',
              placementAssistance: false,
              placementType: '',
              placementRate: 0.0,
              advantagesHighlights: '',
              courseFees: 0.0,
            ),
      executiveCategory: json['executiveCategory'] != null
          ? CourseCategory.fromJson(
              json['executiveCategory'] as Map<String, dynamic>,
            )
          : json['category_data'] != null &&
                json['course_category'] == 'executive'
          ? CourseCategory.fromJson(
              json['category_data'] as Map<String, dynamic>,
            )
          : CourseCategory(
              jobRolesOffered: '',
              placementAssistance: false,
              placementType: '',
              placementRate: 0.0,
              advantagesHighlights: '',
              courseFees: 0.0,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': id,
      'course_name': name,
      'course_description': description,
      'course_code': code,
      'weight_requirements': weightRequirements,
      'height_requirements': heightRequirements,
      'vision_standards': visionStandards,
      'medical_requirements': medicalRequirements,
      'min_educational_qualification': minEducationalQualification,
      'age_criteria': ageCriteria,
      'internship_included': internshipIncluded,
      'installment_available': installmentAvailable,
      'installment_policy': installmentPolicy,
      'course_photo': photoUrl,
      'course_video': videoUrl,
      'generalCategory': generalCategory.toJson(),
      'executiveCategory': executiveCategory.toJson(),
    };
  }
}
