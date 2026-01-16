import 'package:application_admin_panel/widgets/snackber_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/teacher_controller.dart';
import '../../../models/teacher.dart';

class OnboardEditTeacherCard extends StatefulWidget {
  final Teacher? teacher;

  const OnboardEditTeacherCard({super.key, this.teacher});

  @override
  State<OnboardEditTeacherCard> createState() => _OnboardEditTeacherCardState();
}

class _OnboardEditTeacherCardState extends State<OnboardEditTeacherCard> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch courses if not already loaded
    if (teacherController.courses.isEmpty) {
      teacherController.fetchCourses();
    }
    // If editing, pre-select courses
    if (widget.teacher != null && teacherController.selectedCourseIds.isEmpty) {
      teacherController.selectedCourseIds.assignAll(
        widget.teacher!.coursesAssigned.map((e) => e.toString()).toList(),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  final teacherController = Get.find<TeacherController>();

  late final TextEditingController _teacherNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _altPhoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _qualificationController;
  late final TextEditingController _experienceController;
  // courses selection handled via teacherController.selectedCourseIds
  late final TextEditingController _bankAccountNoController;
  late final TextEditingController _bankAccountNameController;
  late final TextEditingController _bankBranchNameController;
  late final TextEditingController _ifscCodeController;
  late final TextEditingController _upiidController;
  late final TextEditingController _monthlySalaryController;
  late final TextEditingController _passwordController;

  String? _selectedProfilePhoto;
  String? _profilePhotoDisplayName;
  Uint8List? _selectedProfilePhotoBytes;
  bool _pickedNewPhoto = false;

  @override
  void initState() {
    super.initState();
    _teacherNameController = TextEditingController(
      text: widget.teacher?.fullName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.teacher?.phoneNo ?? '',
    );
    _emailController = TextEditingController(text: widget.teacher?.email ?? '');
    _altPhoneController = TextEditingController(
      text: widget.teacher?.alternativePhoneNo ?? '',
    );
    _addressController = TextEditingController(
      text: widget.teacher?.address ?? '',
    );
    _qualificationController = TextEditingController(
      text: widget.teacher?.qualification ?? '',
    );
    _experienceController = TextEditingController(
      text: widget.teacher?.experience ?? '',
    );
    // _coursesAssignedController is no longer needed
    _bankAccountNoController = TextEditingController(
      text: widget.teacher?.bankAccountNo ?? '',
    );
    _bankAccountNameController = TextEditingController(
      text: widget.teacher?.bankAccountName ?? '',
    );
    _bankBranchNameController = TextEditingController(
      text: widget.teacher?.bankBranchName ?? '',
    );
    _ifscCodeController = TextEditingController(
      text: widget.teacher?.ifscCode ?? '',
    );
    _upiidController = TextEditingController(text: widget.teacher?.upiid ?? '');
    _monthlySalaryController = TextEditingController(
      text: widget.teacher?.monthlySalary?.toString() ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.teacher?.password ?? '',
    );

    if (widget.teacher == null) {
      teacherController.selectedCourseIds.clear();
    }

    if (widget.teacher?.profilePhoto != null) {
      _selectedProfilePhoto = widget.teacher!.profilePhoto;
      _profilePhotoDisplayName = 'Current Photo';
    }
  }

  @override
  void dispose() {
    _teacherNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _altPhoneController.dispose();
    _addressController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    // selectedCourseIds handled by controller; no local controller to dispose
    _bankAccountNoController.dispose();
    _bankAccountNameController.dispose();
    _bankBranchNameController.dispose();
    _ifscCodeController.dispose();
    _upiidController.dispose();
    _monthlySalaryController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePhoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null) {
        setState(() {
          if (kIsWeb) {
            _selectedProfilePhoto = null;
            _selectedProfilePhotoBytes = result.files.single.bytes;
            _profilePhotoDisplayName = result.files.single.name;
            _pickedNewPhoto = true;
          } else {
            _selectedProfilePhoto = result.files.single.path;
            _profilePhotoDisplayName = result.files.single.name;
            _pickedNewPhoto = true;
          }
        });
      }
    } catch (e) {
      safeSnackbar(
        'Error',
        'Failed to pick profile photo: $e',
        backgroundColor: AppColors.errorRed,
        colorText: AppColors.white,
      );
    }
  }

  void _saveTeacher() {
    if (_formKey.currentState!.validate()) {
      final teacher = Teacher(
        id: widget.teacher?.id ?? '',
        fullName: _teacherNameController.text.trim(),
        phoneNo: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        alternativePhoneNo: _altPhoneController.text.trim(),
        address: _addressController.text.trim(),
        qualification: _qualificationController.text.trim(),
        experience: _experienceController.text.trim(),
        coursesAssigned: List<String>.from(teacherController.selectedCourseIds),
        bankAccountNo: _bankAccountNoController.text.trim(),
        bankAccountName: _bankAccountNameController.text.trim(),
        bankBranchName: _bankBranchNameController.text.trim(),
        ifscCode: _ifscCodeController.text.trim(),
        upiid: _upiidController.text.trim(),
        monthlySalary: _monthlySalaryController.text.isNotEmpty
            ? double.tryParse(_monthlySalaryController.text.trim())
            : null,
        password: _passwordController.text.trim(),
        profilePhoto: _selectedProfilePhoto,
      );

      if (widget.teacher == null) {
        teacherController.addTeacher(
          teacher,
          profilePhotoPath: _pickedNewPhoto ? _selectedProfilePhoto : null,
          profilePhotoBytes: _pickedNewPhoto
              ? _selectedProfilePhotoBytes
              : null,
          profilePhotoFilename: _pickedNewPhoto
              ? _profilePhotoDisplayName
              : null,
        );
      } else {
        teacherController.editTeacher(
          widget.teacher!.id,
          teacher,
          profilePhotoPath: _pickedNewPhoto ? _selectedProfilePhoto : null,
          profilePhotoBytes: _pickedNewPhoto
              ? _selectedProfilePhotoBytes
              : null,
          profilePhotoFilename: _pickedNewPhoto
              ? _profilePhotoDisplayName
              : null,
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.textThemeFromContext(context);
    final isDesktop = AppTheme.isDesktop(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.darkRed,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.teacher == null
                        ? 'Onboard New Teacher'
                        : 'Edit Teacher',
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Teacher Details', textTheme),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          controller: _teacherNameController,
                          label: 'Full Name',
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          keyboardType: TextInputType.phone,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildTextField(
                          controller: _altPhoneController,
                          label: 'Alternative Phone',
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          controller: _addressController,
                          label: 'Address',
                        ),
                        _buildTextField(
                          controller: _qualificationController,
                          label: 'Qualification',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          controller: _experienceController,
                          label: 'Experience',
                        ),
                        Obx(() {
                          final courses = teacherController.courses;
                          return InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Assign Courses',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: courses.isEmpty
                                ? const Text('No courses available')
                                : Wrap(
                                    spacing: 8,
                                    children: courses.map((course) {
                                      final courseId = course.id;
                                      final courseName = course.name;
                                      final isSelected = teacherController
                                          .selectedCourseIds
                                          .contains(courseId);
                                      return FilterChip(
                                        label: Text(courseName),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              teacherController
                                                  .selectedCourseIds
                                                  .add(courseId);
                                            } else {
                                              teacherController
                                                  .selectedCourseIds
                                                  .remove(courseId);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          controller: _bankAccountNoController,
                          label: 'Bank Account No',
                        ),
                        _buildTextField(
                          controller: _bankAccountNameController,
                          label: 'Bank Account Name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          controller: _bankBranchNameController,
                          label: 'Bank Branch Name',
                        ),
                        _buildTextField(
                          controller: _ifscCodeController,
                          label: 'IFSC Code',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          controller: _upiidController,
                          label: 'UPI ID',
                        ),
                        _buildTextField(
                          controller: _monthlySalaryController,
                          label: 'Monthly Salary',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          obscureText: true,
                        ),
                        _buildFilePicker(),
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _saveTeacher,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkRed,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            widget.teacher == null
                                ? 'Onboard Teacher'
                                : 'Update Teacher',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.darkRed, width: 2)),
      ),
      child: Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkRed,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTwoColumnLayout(bool isDesktop, Widget left, Widget right) {
    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: left),
          const SizedBox(width: 16),
          Expanded(child: right),
        ],
      );
    } else {
      return Column(children: [left, const SizedBox(height: 16), right]);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkRed, width: 2),
        ),
      ),
      maxLines: maxLines,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Photo',
          style: TextStyle(
            color: AppColors.darkGray,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickProfilePhoto,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderGray),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.lightGray,
            ),
            child: Row(
              children: [
                Icon(Icons.cloud_upload, color: AppColors.darkRed),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _profilePhotoDisplayName ?? 'Choose Profile Photo',
                    style: TextStyle(
                      color: _selectedProfilePhoto != null
                          ? AppColors.darkGray
                          : AppColors.darkGrayLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
