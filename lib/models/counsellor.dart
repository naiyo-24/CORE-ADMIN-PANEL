class Counsellor {
  final String id; // local app id mapping (counsellor_id from API)
  final String name;
  final String phoneNumber;
  final String email;
  final String? address;
  final int experienceYears;
  final String? qualification;
  final double commissionPercentage; // fallback single value
  final Map<String, double>? perCoursesCommission; // detailed mapping from API
  final String? alternatePhoneNumber;
  final String password;
  final String? profilePhotoUrl;
  // removed `bio` field as not required by API anymore
  final String? bankAccountNo;
  final String? bankAccountName;
  final String? branchName;
  final String? ifscCode;
  final String? upiId;

  Counsellor({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.address,
    required this.experienceYears,
    this.qualification,
    required this.commissionPercentage,
    this.perCoursesCommission,
    this.alternatePhoneNumber,
    required this.password,
    this.profilePhotoUrl,
    this.bankAccountNo,
    this.bankAccountName,
    this.branchName,
    this.ifscCode,
    this.upiId,
  });

  factory Counsellor.fromJson(Map<String, dynamic> json) {
    // Support different key naming conventions between API and local model
    final id = (json['counsellor_id'] ?? json['id'] ?? '') as String;
    final name = (json['full_name'] ?? json['name'] ?? '') as String;
    final phone = (json['phone_no'] ?? json['phoneNumber'] ?? '') as String;
    final email = (json['email'] ?? '') as String;
    final address =
        (json['address'] as String?) ?? (json['address'] as String?);

    int experience = 0;
    try {
      final expVal = json['experience'] ?? json['experienceYears'];
      if (expVal is int) {
        experience = expVal;
      } else if (expVal is String) {
        experience = int.tryParse(expVal) ?? 0;
      }
    } catch (_) {}

    String? qualification = json['qualification'] as String?;

    double commission = 0.0;
    Map<String, double>? perCourses;
    try {
      final pc =
          json['per_courses_commission'] ??
          json['perCoursesCommission'] ??
          json['per_courses_commission'];
      if (pc is Map) {
        perCourses = {};
        pc.forEach((k, v) {
          final val = v is String
              ? double.tryParse(v) ?? 0.0
              : (v is num ? v.toDouble() : 0.0);
          perCourses![k.toString()] = val;
        });
        if (perCourses.isNotEmpty) commission = perCourses.values.first;
      }
    } catch (_) {}

    final alternate =
        (json['alternative_phone_no'] ??
                json['alternatePhoneNumber'] ??
                json['alternatePhoneNumber'])
            as String?;
    final password = (json['password'] ?? '') as String;
    final profile =
        (json['profile_photo'] ??
                json['profilePhotoUrl'] ??
                json['profile_photo'])
            as String?;
    // `bio` removed
    final bankAccountNo =
        (json['bank_account_no'] ?? json['bankAccountNo']) as String?;
    final bankAccountName =
        (json['bank_account_name'] ?? json['bankAccountName']) as String?;
    final branchName = (json['branch_name'] ?? json['branchName']) as String?;
    final ifscCode = (json['ifsc_code'] ?? json['ifscCode']) as String?;
    final upiId = (json['upi_id'] ?? json['upiId']) as String?;

    return Counsellor(
      id: id,
      name: name,
      phoneNumber: phone,
      email: email,
      address: address,
      experienceYears: experience,
      qualification: qualification,
      commissionPercentage: commission,
      perCoursesCommission: perCourses,
      alternatePhoneNumber: alternate,
      password: password,
      profilePhotoUrl: profile,
      // bio removed
      bankAccountNo: bankAccountNo,
      bankAccountName: bankAccountName,
      branchName: branchName,
      ifscCode: ifscCode,
      upiId: upiId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'counsellor_id': id,
      'full_name': name,
      'phone_no': phoneNumber,
      'email': email,
      'address': address,
      'experience': experienceYears,
      'qualification': qualification,
      'per_courses_commission': perCoursesCommission,
      'alternative_phone_no': alternatePhoneNumber,
      'password': password,
      'profile_photo': profilePhotoUrl,
      'bank_account_no': bankAccountNo,
      'bank_account_name': bankAccountName,
      'branch_name': branchName,
      'ifsc_code': ifscCode,
      'upi_id': upiId,
    };
  }
}
