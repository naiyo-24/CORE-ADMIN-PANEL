import 'dart:convert';
import '../services/api_url.dart';

class Teacher {
  final String id;
  final String? fullName;
  final String? phoneNo;
  final String? email;
  final String? alternativePhoneNo;
  final String? address;
  final String? qualification;
  final String? experience;
  final List<String> coursesAssigned; // course ids
  final List<String> coursesAssignedNames; // course display names
  final String? bankAccountNo;
  final String? bankAccountName;
  final String? bankBranchName;
  final String? ifscCode;
  final String? upiid;
  final double? monthlySalary;
  final String? password;
  final String? profilePhoto;

  Teacher({
    required this.id,
    this.fullName,
    this.phoneNo,
    this.email,
    this.alternativePhoneNo,
    this.address,
    this.qualification,
    this.experience,
    required this.coursesAssigned,
    this.coursesAssignedNames = const [],
    this.bankAccountNo,
    this.bankAccountName,
    this.bankBranchName,
    this.ifscCode,
    this.upiid,
    this.monthlySalary,
    this.password,
    this.profilePhoto,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    List<String> courses = [];
    List<String> courseNames = [];
    if (json['courses_assigned'] is String) {
      try {
        final decoded = jsonDecode(json['courses_assigned']);
        if (decoded is List) {
          courses = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    } else if (json['courses_assigned'] is List) {
      final list = json['courses_assigned'] as List;
      // items may be simple ids (String) or maps with course_id/course_name
      for (final item in list) {
        if (item is String) {
          courses.add(item);
        } else if (item is Map) {
          final id = (item['course_id'] ?? item['id'])?.toString();
          final name = (item['course_name'] ?? item['name'])?.toString();
          if (id != null) courses.add(id);
          if (name != null) courseNames.add(name);
        } else {
          courses.add(item.toString());
        }
      }
    }
    return Teacher(
      id: (json['teacher_id'] as String?) ?? (json['id'] as String?) ?? '',
      fullName: json['full_name'] as String?,
      phoneNo: json['phone_no'] as String?,
      email: json['email'] as String?,
      alternativePhoneNo: json['alternative_phone_no'] as String?,
      address: json['address'] as String?,
      qualification: json['qualification'] as String?,
      experience: json['experience']?.toString(),
      coursesAssigned: courses,
      coursesAssignedNames: courseNames,
      bankAccountNo: json['bank_account_no'] as String?,
      bankAccountName: json['bank_account_name'] as String?,
      bankBranchName: json['bank_branch_name'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      upiid: json['upiid'] as String?,
      monthlySalary: (json['monthly_salary'] is num)
          ? (json['monthly_salary'] as num).toDouble()
          : (json['monthly_salary'] is String &&
                json['monthly_salary'] != null &&
                json['monthly_salary'].toString().isNotEmpty)
          ? double.tryParse(json['monthly_salary'])
          : null,
      password: json['password'] as String?,
      profilePhoto: (() {
        final p = json['profile_photo'] as String?;
        if (p == null) return null;
        if (p.startsWith('http://') || p.startsWith('https://')) return p;
        // Build absolute URL using ApiUrl.baseUrl
        final base = ApiUrl.baseUrl.replaceAll(RegExp(r"/+"), '');
        final cleaned = p.startsWith('/') ? p.substring(1) : p;
        return '$base/$cleaned';
      })(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher_id': id,
      'full_name': fullName,
      'phone_no': phoneNo,
      'email': email,
      'alternative_phone_no': alternativePhoneNo,
      'address': address,
      'qualification': qualification,
      'experience': experience,
      'courses_assigned': coursesAssigned,
      'bank_account_no': bankAccountNo,
      'bank_account_name': bankAccountName,
      'bank_branch_name': bankBranchName,
      'ifsc_code': ifscCode,
      'upiid': upiid,
      'monthly_salary': monthlySalary,
      'password': password,
      'profile_photo': profilePhoto,
    };
  }
}
