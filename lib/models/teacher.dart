class Teacher {
  final String id;
  final String teacherName;
  final String phoneNumber;
  final String email;
  final String alternativePhoneNumber;
  final String address;
  final String specialization;
  final List<String> classroomsInCharge;
  final int experienceYears;
  final String? profilePhotoUrl;
  final String password;
  final String bio;

  Teacher({
    required this.id,
    required this.teacherName,
    required this.phoneNumber,
    required this.email,
    required this.alternativePhoneNumber,
    required this.address,
    required this.specialization,
    required this.classroomsInCharge,
    required this.experienceYears,
    this.profilePhotoUrl,
    required this.password,
    required this.bio,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as String,
      teacherName: json['teacherName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      alternativePhoneNumber: json['alternativePhoneNumber'] as String,
      address: json['address'] as String,
      specialization: json['specialization'] as String,
      classroomsInCharge: List<String>.from(json['classroomsInCharge'] as List),
      experienceYears: json['experienceYears'] as int,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      password: json['password'] as String,
      bio: json['bio'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacherName': teacherName,
      'phoneNumber': phoneNumber,
      'email': email,
      'alternativePhoneNumber': alternativePhoneNumber,
      'address': address,
      'specialization': specialization,
      'classroomsInCharge': classroomsInCharge,
      'experienceYears': experienceYears,
      'profilePhotoUrl': profilePhotoUrl,
      'password': password,
      'bio': bio,
    };
  }
}
