import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../theme/app_theme.dart';
import '../../controllers/course_controller.dart';
import '../../models/course.dart';

class EditCreateCourseCard extends StatefulWidget {
  final Course? course;

  const EditCreateCourseCard({super.key, this.course});

  @override
  State<EditCreateCourseCard> createState() => _EditCreateCourseCardState();
}

class _EditCreateCourseCardState extends State<EditCreateCourseCard> {
  final _formKey = GlobalKey<FormState>();
  final courseController = Get.find<CourseController>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _codeController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _visionController;
  late final TextEditingController _medicalController;
  late final TextEditingController _qualificationController;
  late final TextEditingController _ageController;
  late final TextEditingController _installmentPolicyController;

  // General Category Controllers
  late final TextEditingController _generalJobRolesController;
  late final TextEditingController _generalPlacementTypeController;
  late final TextEditingController _generalPlacementRateController;
  late final TextEditingController _generalAdvantagesController;
  late final TextEditingController _generalFeesController;

  // Executive Category Controllers
  late final TextEditingController _executiveJobRolesController;
  late final TextEditingController _executivePlacementTypeController;
  late final TextEditingController _executivePlacementRateController;
  late final TextEditingController _executiveAdvantagesController;
  late final TextEditingController _executiveFeesController;

  bool _internshipIncluded = false;
  bool _installmentAvailable = false;
  bool _generalPlacementAssistance = false;
  bool _executivePlacementAssistance = false;
  String? _photoUrl;
  String? _photoDisplayName;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.course?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.course?.description ?? '',
    );
    _codeController = TextEditingController(text: widget.course?.code ?? '');
    _weightController = TextEditingController(
      text: widget.course?.weightRequirements ?? '',
    );
    _heightController = TextEditingController(
      text: widget.course?.heightRequirements ?? '',
    );
    _visionController = TextEditingController(
      text: widget.course?.visionStandards ?? '',
    );
    _medicalController = TextEditingController(
      text: widget.course?.medicalRequirements ?? '',
    );
    _qualificationController = TextEditingController(
      text: widget.course?.minEducationalQualification ?? '',
    );
    _ageController = TextEditingController(
      text: widget.course?.ageCriteria ?? '',
    );
    _installmentPolicyController = TextEditingController(
      text: widget.course?.installmentPolicy ?? '',
    );

    _generalJobRolesController = TextEditingController(
      text: widget.course?.generalCategory.jobRolesOffered ?? '',
    );
    _generalPlacementTypeController = TextEditingController(
      text: widget.course?.generalCategory.placementType ?? '',
    );
    _generalPlacementRateController = TextEditingController(
      text: widget.course?.generalCategory.placementRate.toString() ?? '',
    );
    _generalAdvantagesController = TextEditingController(
      text: widget.course?.generalCategory.advantagesHighlights ?? '',
    );
    _generalFeesController = TextEditingController(
      text: widget.course?.generalCategory.courseFees.toString() ?? '',
    );

    _executiveJobRolesController = TextEditingController(
      text: widget.course?.executiveCategory.jobRolesOffered ?? '',
    );
    _executivePlacementTypeController = TextEditingController(
      text: widget.course?.executiveCategory.placementType ?? '',
    );
    _executivePlacementRateController = TextEditingController(
      text: widget.course?.executiveCategory.placementRate.toString() ?? '',
    );
    _executiveAdvantagesController = TextEditingController(
      text: widget.course?.executiveCategory.advantagesHighlights ?? '',
    );
    _executiveFeesController = TextEditingController(
      text: widget.course?.executiveCategory.courseFees.toString() ?? '',
    );

    _internshipIncluded = widget.course?.internshipIncluded ?? false;
    _installmentAvailable = widget.course?.installmentAvailable ?? false;
    _generalPlacementAssistance =
        widget.course?.generalCategory.placementAssistance ?? false;
    _executivePlacementAssistance =
        widget.course?.executiveCategory.placementAssistance ?? false;
    _photoUrl = widget.course?.photoUrl;
    _photoDisplayName = widget.course?.photoUrl != null
        ? 'Current Photo'
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _visionController.dispose();
    _medicalController.dispose();
    _qualificationController.dispose();
    _ageController.dispose();
    _installmentPolicyController.dispose();
    _generalJobRolesController.dispose();
    _generalPlacementTypeController.dispose();
    _generalPlacementRateController.dispose();
    _generalAdvantagesController.dispose();
    _generalFeesController.dispose();
    _executiveJobRolesController.dispose();
    _executivePlacementTypeController.dispose();
    _executivePlacementRateController.dispose();
    _executiveAdvantagesController.dispose();
    _executiveFeesController.dispose();
    super.dispose();
  }

  Future<void> _pickCoursePhoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null) {
        setState(() {
          if (kIsWeb) {
            _photoUrl = result.files.single.name;
            _photoDisplayName = result.files.single.name;
          } else {
            _photoUrl = result.files.single.path;
            _photoDisplayName = result.files.single.name;
          }
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick course photo: $e',
        backgroundColor: AppColors.errorRed,
        colorText: AppColors.white,
      );
    }
  }

  void _saveCourse() {
    if (_formKey.currentState!.validate()) {
      final course = Course(
        id: widget.course?.id ?? '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        code: _codeController.text.trim(),
        weightRequirements: _weightController.text.trim(),
        heightRequirements: _heightController.text.trim(),
        visionStandards: _visionController.text.trim(),
        medicalRequirements: _medicalController.text.trim(),
        minEducationalQualification: _qualificationController.text.trim(),
        ageCriteria: _ageController.text.trim(),
        internshipIncluded: _internshipIncluded,
        installmentAvailable: _installmentAvailable,
        installmentPolicy: _installmentPolicyController.text.trim(),
        photoUrl: _photoUrl,
        videoUrl: widget.course?.videoUrl,
        generalCategory: CourseCategory(
          jobRolesOffered: _generalJobRolesController.text.trim(),
          placementAssistance: _generalPlacementAssistance,
          placementType: _generalPlacementTypeController.text.trim(),
          placementRate:
              double.tryParse(_generalPlacementRateController.text.trim()) ?? 0,
          advantagesHighlights: _generalAdvantagesController.text.trim(),
          courseFees: double.tryParse(_generalFeesController.text.trim()) ?? 0,
        ),
        executiveCategory: CourseCategory(
          jobRolesOffered: _executiveJobRolesController.text.trim(),
          placementAssistance: _executivePlacementAssistance,
          placementType: _executivePlacementTypeController.text.trim(),
          placementRate:
              double.tryParse(_executivePlacementRateController.text.trim()) ??
              0,
          advantagesHighlights: _executiveAdvantagesController.text.trim(),
          courseFees:
              double.tryParse(_executiveFeesController.text.trim()) ?? 0,
        ),
      );

      if (widget.course == null) {
        courseController.addCourse(course);
      } else {
        courseController.editCourse(widget.course!.id, course);
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
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header
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
                    widget.course == null ? 'Create New Course' : 'Edit Course',
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

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information
                      _buildSectionTitle('Basic Information', textTheme),
                      const SizedBox(height: 16),
                      _buildTextField(_nameController, 'Course Name *'),
                      const SizedBox(height: 12),
                      _buildTextField(_codeController, 'Course Code *'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        _descriptionController,
                        'Description *',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),

                      // Medical & Physical Requirements
                      _buildSectionTitle(
                        'Medical & Physical Requirements',
                        textTheme,
                      ),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          _weightController,
                          'Weight Requirements *',
                        ),
                        _buildTextField(
                          _heightController,
                          'Height Requirements *',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          _visionController,
                          'Vision Standards *',
                        ),
                        _buildTextField(
                          _medicalController,
                          'Medical Requirements *',
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Eligibility
                      _buildSectionTitle('Eligibility Criteria', textTheme),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          _qualificationController,
                          'Min Educational Qualification *',
                        ),
                        _buildTextField(_ageController, 'Age Criteria *'),
                      ),
                      const SizedBox(height: 32),

                      // Course Features
                      _buildSectionTitle('Course Features', textTheme),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _internshipIncluded,
                            onChanged: (val) {
                              setState(
                                () => _internshipIncluded = val ?? false,
                              );
                            },
                          ),
                          Text(
                            'Internship Included',
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 32),
                          Checkbox(
                            value: _installmentAvailable,
                            onChanged: (val) {
                              setState(
                                () => _installmentAvailable = val ?? false,
                              );
                            },
                          ),
                          Text(
                            'Installment Available',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        _installmentPolicyController,
                        'Installment Policy',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 32),

                      // General Category
                      _buildCategorySection(
                        'General Category',
                        _generalJobRolesController,
                        _generalPlacementTypeController,
                        _generalPlacementRateController,
                        _generalAdvantagesController,
                        _generalFeesController,
                        _generalPlacementAssistance,
                        (val) =>
                            setState(() => _generalPlacementAssistance = val),
                        textTheme,
                        isDesktop,
                      ),
                      const SizedBox(height: 32),

                      // Executive Category
                      _buildCategorySection(
                        'Executive Category',
                        _executiveJobRolesController,
                        _executivePlacementTypeController,
                        _executivePlacementRateController,
                        _executiveAdvantagesController,
                        _executiveFeesController,
                        _executivePlacementAssistance,
                        (val) =>
                            setState(() => _executivePlacementAssistance = val),
                        textTheme,
                        isDesktop,
                      ),
                      const SizedBox(height: 32),

                      // Photo Upload
                      _buildSectionTitle('Course Photo', textTheme),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _pickCoursePhoto,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderGray),
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.lightGray,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.cloud_upload,
                                color: AppColors.darkRed,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _photoDisplayName ?? 'Choose Course Photo',
                                  style: TextStyle(
                                    color: _photoUrl != null
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
                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: AppColors.darkGray),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _saveCourse,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkRed,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: Text(
                              widget.course == null
                                  ? 'Create Course'
                                  : 'Save Changes',
                              style: TextStyle(color: AppColors.white),
                            ),
                          ),
                        ],
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

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkRed, width: 2),
        ),
      ),
      maxLines: maxLines,
      validator: (val) => (val?.isEmpty ?? true) ? 'Required' : null,
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
    }
    return Column(children: [left, const SizedBox(height: 12), right]);
  }

  Widget _buildCategorySection(
    String title,
    TextEditingController jobRolesController,
    TextEditingController placementTypeController,
    TextEditingController placementRateController,
    TextEditingController advantagesController,
    TextEditingController feesController,
    bool placementAssistance,
    Function(bool) onAssistanceChanged,
    TextTheme textTheme,
    bool isDesktop,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title, textTheme),
        const SizedBox(height: 16),
        _buildTextField(jobRolesController, 'Job Roles Offered *'),
        const SizedBox(height: 12),
        _buildTwoColumnLayout(
          isDesktop,
          _buildTextField(placementTypeController, 'Placement Type *'),
          _buildTextField(
            placementRateController,
            'Placement Rate (%) *',
            maxLines: 1,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Checkbox(
              value: placementAssistance,
              onChanged: (val) => onAssistanceChanged(val ?? false),
            ),
            Text('Placement Assistance', style: textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          advantagesController,
          'Advantages & Highlights *',
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        _buildTextField(feesController, 'Course Fees (₹) *', maxLines: 1),
      ],
    );
  }
}
