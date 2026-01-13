class Student {
  final String studentId;
  final String fullName;
  final String phoneNo;
  final String email;
  final String address;
  final String guardianName;
  final String guardianMobileNo;
  final String? guardianEmail;
  final String courseAvailing;
  final List<String>? interests;
  final List<String>? hobbies;
  final String? profilePhoto;
  final String? password;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? courseName;

  Student({
    required this.studentId,
    required this.fullName,
    required this.phoneNo,
    required this.email,
    required this.address,
    required this.guardianName,
    required this.guardianMobileNo,
    this.guardianEmail,
    required this.courseAvailing,
    this.interests,
    this.hobbies,
    this.profilePhoto,
    this.password,
    required this.createdAt,
    required this.updatedAt,
    this.courseName,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'] as String,
      fullName: json['full_name'] as String,
      phoneNo: json['phone_no'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      guardianName: json['guardian_name'] as String,
      guardianMobileNo: json['guardian_mobile_no'] as String,
      guardianEmail: json['guardian_email'] as String?,
      courseAvailing: json['course_availing'] as String,
      interests: (json['interests'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      hobbies: (json['hobbies'] as List?)?.map((e) => e.toString()).toList(),
      profilePhoto: json['profile_photo'] as String?,
      password: json['password'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      courseName: json['course_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'full_name': fullName,
      'phone_no': phoneNo,
      'email': email,
      'address': address,
      'guardian_name': guardianName,
      'guardian_mobile_no': guardianMobileNo,
      'guardian_email': guardianEmail,
      'course_availing': courseAvailing,
      'interests': interests,
      'hobbies': hobbies,
      'profile_photo': profilePhoto,
      'password': password,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'course_name': courseName,
    };
  }
}
