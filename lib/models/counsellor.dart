class Counsellor {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String address;
  final int experienceYears;
  final String qualification;
  final double commissionPercentage;
  final String alternatePhoneNumber;
  final String password;
  final String? profilePhotoUrl;
  final String bio;

  Counsellor({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.experienceYears,
    required this.qualification,
    required this.commissionPercentage,
    required this.alternatePhoneNumber,
    required this.password,
    this.profilePhotoUrl,
    required this.bio,
  });

  // Factory constructor to create a Counsellor from JSON
  factory Counsellor.fromJson(Map<String, dynamic> json) {
    return Counsellor(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      experienceYears: json['experienceYears'] as int,
      qualification: json['qualification'] as String,
      commissionPercentage: json['commissionPercentage'] as double,
      alternatePhoneNumber: json['alternatePhoneNumber'] as String,
      password: json['password'] as String,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      bio: json['bio'] as String,
    );
  }

  // Method to convert a Counsellor to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'experienceYears': experienceYears,
      'qualification': qualification,
      'commissionPercentage': commissionPercentage,
      'alternatePhoneNumber': alternatePhoneNumber,
      'password': password,
      'profilePhotoUrl': profilePhotoUrl,
      'bio': bio,
    };
  }
}
