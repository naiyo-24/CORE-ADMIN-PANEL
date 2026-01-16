import 'package:application_admin_panel/services/course_services.dart';
import 'package:application_admin_panel/widgets/snackber_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../models/student.dart';
import '../../controllers/student_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart';

class StudentOnboardEditCard extends StatefulWidget {
  final Student? student; // null for new student, Student object for editing

  const StudentOnboardEditCard({super.key, this.student});

  @override
  State<StudentOnboardEditCard> createState() => _StudentOnboardEditCardState();
}

class _StudentOnboardEditCardState extends State<StudentOnboardEditCard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  String? _selectedCourseId;
  List<Map<String, String>> _courseOptions = [];
  bool _isLoadingCourses = false;
  late TextEditingController _guardianNameController;
  late TextEditingController _guardianPhoneController;
  late TextEditingController _guardianEmailController;
  late TextEditingController _interestsController;
  late TextEditingController _passwordController;
  DateTime? _enrollmentDate;
  String? _selectedFileName;
  String? _selectedFilePath;
  List<int>? _selectedFileBytes;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data if editing
    _fullNameController = TextEditingController(
      text: widget.student?.fullName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.student?.phoneNo ?? '',
    );
    _emailController = TextEditingController(text: widget.student?.email ?? '');
    _addressController = TextEditingController(
      text: widget.student?.address ?? '',
    );
    _selectedCourseId = widget.student?.courseAvailing;
    _fetchCourses();

    _guardianNameController = TextEditingController(
      text: widget.student?.guardianName ?? '',
    );
    _guardianPhoneController = TextEditingController(
      text: widget.student?.guardianMobileNo ?? '',
    );
    _guardianEmailController = TextEditingController(
      text: widget.student?.guardianEmail ?? '',
    );
    _interestsController = TextEditingController(
      text: widget.student?.interests?.join(', ') ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.student?.password ?? '',
    );
    _enrollmentDate = widget.student?.createdAt ?? DateTime.now();
    _selectedFileName = widget.student?.profilePhoto;
    _selectedFilePath = widget.student?.profilePhoto;
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoadingCourses = true;
    });
    try {
      final courses = await CourseServices.getAllCourses();
      setState(() {
        _courseOptions = courses
            .map((c) => {'id': c.id, 'name': c.name})
            .toList();
        if (_selectedCourseId == null && _courseOptions.isNotEmpty) {
          _selectedCourseId = _courseOptions.first['id'];
        }
      });
    } catch (e) {
      // Optionally show error
    } finally {
      setState(() {
        _isLoadingCourses = false;
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    // No controller to dispose for dropdown
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    _guardianEmailController.dispose();
    _interestsController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.textThemeFromContext(context);
    final isDesktop = AppTheme.isDesktop(context);
    final controller = Get.find<StudentController>();
    final isEditing = widget.student != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.lightGray,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowBlack,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.darkGray),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      isEditing
                          ? 'Edit Student Details'
                          : 'Onboard New Student',
                      style: textTheme.headlineLarge?.copyWith(
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Obx(() {
                    return ElevatedButton(
                      onPressed: controller.isCreating.value
                          ? null
                          : () => _saveStudent(controller, isEditing),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkRed,
                        foregroundColor: AppColors.white,
                        elevation: 4,
                        shadowColor: AppColors.shadowBlack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: controller.isCreating.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isEditing
                                      ? FontAwesomeIcons.floppyDisk
                                      : FontAwesomeIcons.userPlus,
                                  size: 14,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isEditing
                                      ? 'Save Changes'
                                      : 'Onboard Student',
                                ),
                              ],
                            ),
                    );
                  }),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 80 : 24,
                  vertical: 32,
                ),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderGray,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowBlack,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Personal Information Section
                          _buildSectionHeader(
                            'Personal Information',
                            textTheme,
                          ),
                          const SizedBox(height: 24),
                          _buildTwoColumnLayout(isDesktop, [
                            _buildTextField(
                              'Full Name',
                              _fullNameController,
                              'Enter full name',
                              FontAwesomeIcons.user,
                              textTheme,
                              isRequired: true,
                            ),
                            _buildTextField(
                              'Phone Number',
                              _phoneController,
                              'Enter phone number',
                              FontAwesomeIcons.phone,
                              textTheme,
                              isRequired: true,
                            ),
                          ]),
                          const SizedBox(height: 16),
                          _buildTwoColumnLayout(isDesktop, [
                            _buildTextField(
                              'Email Address',
                              _emailController,
                              'Enter email address',
                              FontAwesomeIcons.envelope,
                              textTheme,
                              isRequired: true,
                            ),
                            _buildCourseDropdown(textTheme),
                          ]),

                          const SizedBox(height: 16),
                          _buildTextField(
                            'Address',
                            _addressController,
                            'Enter full address',
                            FontAwesomeIcons.locationDot,
                            textTheme,
                            isRequired: true,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          _buildDatePicker(context, textTheme),

                          const SizedBox(height: 40),

                          // Guardian Information Section
                          _buildSectionHeader(
                            'Guardian Information',
                            textTheme,
                          ),
                          const SizedBox(height: 24),
                          _buildTwoColumnLayout(isDesktop, [
                            _buildTextField(
                              'Guardian Name',
                              _guardianNameController,
                              'Enter guardian name',
                              FontAwesomeIcons.userShield,
                              textTheme,
                              isRequired: true,
                            ),
                            _buildTextField(
                              'Guardian Phone',
                              _guardianPhoneController,
                              'Enter guardian phone',
                              FontAwesomeIcons.phone,
                              textTheme,
                              isRequired: true,
                            ),
                          ]),
                          const SizedBox(height: 16),
                          _buildTextField(
                            'Guardian Email',
                            _guardianEmailController,
                            'Enter guardian email',
                            FontAwesomeIcons.envelope,
                            textTheme,
                            isRequired: true,
                          ),

                          const SizedBox(height: 40),

                          // Additional Information Section
                          _buildSectionHeader(
                            'Additional Information',
                            textTheme,
                          ),
                          const SizedBox(height: 24),
                          _buildTextField(
                            'Interests (comma-separated)',
                            _interestsController,
                            'e.g., Aviation, Technology, Sports',
                            FontAwesomeIcons.star,
                            textTheme,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          _buildFilePicker(context, textTheme),
                          const SizedBox(height: 16),
                          _buildTextField(
                            'Password',
                            _passwordController,
                            'Enter password',
                            FontAwesomeIcons.lock,
                            textTheme,
                            isRequired: true,
                            isPassword: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseDropdown(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Course',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.darkGray,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(' *', style: TextStyle(color: AppColors.errorRed)),
          ],
        ),
        const SizedBox(height: 8),
        _isLoadingCourses
            ? const CircularProgressIndicator()
            : DropdownButtonFormField<String>(
                value: _selectedCourseId,
                isExpanded: true,
                items: _courseOptions.map<DropdownMenuItem<String>>((course) {
                  final id = course['id'] ?? '';
                  final name = course['name'] ?? '';
                  return DropdownMenuItem<String>(value: id, child: Text(name));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCourseId = val;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.borderGray,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.borderGray,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.darkRed,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.errorRed,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.lightGray,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a course';
                  }
                  return null;
                },
              ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.darkRed, width: 2)),
      ),
      child: Text(
        title,
        style: textTheme.headlineMedium?.copyWith(
          color: AppColors.darkRed,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTwoColumnLayout(bool isDesktop, List<Widget> children) {
    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: children[0]),
          const SizedBox(width: 16),
          Expanded(child: children[1]),
        ],
      );
    }
    return Column(
      children: [children[0], const SizedBox(height: 16), children[1]],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
    IconData icon,
    TextTheme textTheme, {
    bool isRequired = false,
    int maxLines = 1,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.darkGray,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired)
              const Text(' *', style: TextStyle(color: AppColors.errorRed)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          obscureText: isPassword,
          style: textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textTheme.bodySmall?.copyWith(
              color: AppColors.darkGrayLight,
            ),
            prefixIcon: Icon(icon, size: 16, color: AppColors.darkGrayLight),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.borderGray,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.borderGray,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.darkRed, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.errorRed,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: AppColors.lightGray,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildFilePicker(BuildContext context, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Photo (optional)',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.darkGray,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.image,
              allowMultiple: false,
              withData: true, // Required for web to get bytes
            );

            if (result != null) {
              setState(() {
                _selectedFileName = result.files.single.name;
                if (kIsWeb) {
                  _selectedFilePath = result.files.single.name;
                  _selectedFileBytes = result.files.single.bytes;
                } else {
                  _selectedFilePath = result.files.single.path;
                  _selectedFileBytes = null;
                }
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGray, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.image,
                  size: 16,
                  color: AppColors.darkGrayLight,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedFileName ?? 'Select profile photo',
                    style: textTheme.bodyMedium?.copyWith(
                      color: _selectedFileName != null
                          ? AppColors.darkGray
                          : AppColors.darkGrayLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_selectedFileName != null)
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.darkGrayLight,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedFileName = null;
                        _selectedFilePath = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Enrollment Date',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.darkGray,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(' *', style: TextStyle(color: AppColors.errorRed)),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _enrollmentDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.darkRed,
                      onPrimary: AppColors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              setState(() {
                _enrollmentDate = date;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGray, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.calendar,
                  size: 16,
                  color: AppColors.darkGrayLight,
                ),
                const SizedBox(width: 12),
                Text(
                  _enrollmentDate != null
                      ? '${_enrollmentDate!.day}/${_enrollmentDate!.month}/${_enrollmentDate!.year}'
                      : 'Select enrollment date',
                  style: textTheme.bodyMedium?.copyWith(
                    color: _enrollmentDate != null
                        ? AppColors.darkGray
                        : AppColors.darkGrayLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _saveStudent(StudentController controller, bool isEditing) async {
    if (!_formKey.currentState!.validate()) {
      safeSnackbar(
        'Validation Error',
        'Please fill all required fields',
        backgroundColor: AppColors.errorRed,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (_enrollmentDate == null) {
      safeSnackbar(
        'Validation Error',
        'Please select an enrollment date',
        backgroundColor: AppColors.errorRed,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Parse interests
    final interests = _interestsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final student = Student(
      studentId: isEditing ? widget.student!.studentId : '',
      fullName: _fullNameController.text.trim(),
      phoneNo: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      courseAvailing: _selectedCourseId ?? '',
      guardianName: _guardianNameController.text.trim(),
      guardianMobileNo: _guardianPhoneController.text.trim(),
      guardianEmail: _guardianEmailController.text.trim(),
      interests: interests,
      hobbies: [],
      profilePhoto: null, // Don't send as string
      password: _passwordController.text.trim(),
      createdAt: _enrollmentDate!,
      updatedAt: DateTime.now(),
      courseName: null,
    );

    // Prepare file upload args
    String? filePath;
    List<int>? fileBytes;
    String? fileName;
    if (_selectedFileName != null) {
      if (kIsWeb) {
        // On web, use bytes already picked
        // _selectedFilePath is actually the file name, not path
        // You need to store the bytes when picking the file
        // So, add a new field: List<int>? _selectedFileBytes;
        fileBytes = _selectedFileBytes;
        fileName = _selectedFileName;
      } else {
        // On native, use file path
        filePath = _selectedFilePath;
      }
    }

    if (isEditing) {
      await controller.editStudent(
        student.studentId,
        student,
        filePath: filePath,
        fileBytes: fileBytes,
        fileName: fileName,
      );
      if (mounted) Navigator.pop(context);
    } else {
      await controller.addStudent(
        student,
        filePath: filePath,
        fileBytes: fileBytes,
        fileName: fileName,
      );
      if (mounted) Navigator.pop(context);
    }
  }
}
