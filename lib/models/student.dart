class Student {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String address;
  final String course;
  final String guardianName;
  final String guardianPhoneNumber;
  final String guardianEmail;
  final List<String> interests;
  final String? profilePhotoUrl;
  final DateTime enrollmentDate;
  final String password;

  Student({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.course,
    required this.guardianName,
    required this.guardianPhoneNumber,
    required this.guardianEmail,
    required this.interests,
    this.profilePhotoUrl,
    required this.enrollmentDate,
    required this.password,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      course: json['course'] as String,
      guardianName: json['guardianName'] as String,
      guardianPhoneNumber: json['guardianPhoneNumber'] as String,
      guardianEmail: json['guardianEmail'] as String,
      interests: List<String>.from(json['interests'] as List),
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      enrollmentDate: DateTime.parse(json['enrollmentDate'] as String),
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'course': course,
      'guardianName': guardianName,
      'guardianPhoneNumber': guardianPhoneNumber,
      'guardianEmail': guardianEmail,
      'interests': interests,
      'profilePhotoUrl': profilePhotoUrl,
      'enrollmentDate': enrollmentDate.toIso8601String(),
      'password': password,
    };
  }
}
