import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/counsellor_controller.dart';
import '../../../models/counsellor.dart';

class OnboardEditCounsellorCard extends StatefulWidget {
  final Counsellor? counsellor;

  const OnboardEditCounsellorCard({super.key, this.counsellor});

  @override
  State<OnboardEditCounsellorCard> createState() =>
      _OnboardEditCounsellorCardState();
}

class _OnboardEditCounsellorCardState extends State<OnboardEditCounsellorCard> {
  final _formKey = GlobalKey<FormState>();
  final counsellorController = Get.find<CounsellorController>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _experienceController;
  late final TextEditingController _qualificationController;
  late final TextEditingController _commissionController;
  late final TextEditingController _altPhoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _bioController;

  String? _selectedProfilePhoto;
  String? _profilePhotoDisplayName;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.counsellor?.name ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.counsellor?.phoneNumber ?? '',
    );
    _emailController = TextEditingController(
      text: widget.counsellor?.email ?? '',
    );
    _addressController = TextEditingController(
      text: widget.counsellor?.address ?? '',
    );
    _experienceController = TextEditingController(
      text: widget.counsellor?.experienceYears.toString() ?? '',
    );
    _qualificationController = TextEditingController(
      text: widget.counsellor?.qualification ?? '',
    );
    _commissionController = TextEditingController(
      text: widget.counsellor?.commissionPercentage.toString() ?? '',
    );
    _altPhoneController = TextEditingController(
      text: widget.counsellor?.alternatePhoneNumber ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.counsellor?.password ?? '',
    );
    _bioController = TextEditingController(text: widget.counsellor?.bio ?? '');

    if (widget.counsellor?.profilePhotoUrl != null) {
      _selectedProfilePhoto = widget.counsellor!.profilePhotoUrl;
      _profilePhotoDisplayName = 'Current Photo';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _experienceController.dispose();
    _qualificationController.dispose();
    _commissionController.dispose();
    _altPhoneController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
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
            _selectedProfilePhoto = result.files.single.name;
            _profilePhotoDisplayName = result.files.single.name;
          } else {
            _selectedProfilePhoto = result.files.single.path;
            _profilePhotoDisplayName = result.files.single.name;
          }
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick profile photo: $e',
        backgroundColor: AppColors.errorRed,
        colorText: AppColors.white,
      );
    }
  }

  void _saveCounsellor() {
    if (_formKey.currentState!.validate()) {
      final counsellor = Counsellor(
        id: widget.counsellor?.id ?? '',
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        experienceYears: int.tryParse(_experienceController.text.trim()) ?? 0,
        qualification: _qualificationController.text.trim(),
        commissionPercentage:
            double.tryParse(_commissionController.text.trim()) ?? 0.0,
        alternatePhoneNumber: _altPhoneController.text.trim(),
        password: _passwordController.text.trim(),
        profilePhotoUrl: _selectedProfilePhoto,
        bio: _bioController.text.trim(),
      );

      if (widget.counsellor == null) {
        counsellorController.addCounsellor(counsellor);
      } else {
        counsellorController.editCounsellor(widget.counsellor!.id, counsellor);
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
                    widget.counsellor == null
                        ? 'Onboard New Counsellor'
                        : 'Edit Counsellor',
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
                      _buildSectionTitle('Personal Information', textTheme),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          controller: _nameController,
                          label: 'Name *',
                          validator: (val) => val!.isEmpty ? 'Required' : null,
                        ),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number *',
                          validator: (val) => val!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email *',
                          validator: (val) {
                            if (val!.isEmpty) return 'Required';
                            if (!GetUtils.isEmail(val)) return 'Invalid email';
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _altPhoneController,
                          label: 'Alternative Phone Number *',
                          validator: (val) => val!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _addressController,
                        label: 'Address *',
                        maxLines: 2,
                        validator: (val) => val!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Professional Information', textTheme),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildTextField(
                          controller: _experienceController,
                          label: 'Experience (Years) *',
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val!.isEmpty) return 'Required';
                            if (int.tryParse(val) == null) {
                              return 'Enter valid number';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _commissionController,
                          label: 'Commission Percentage *',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (val) {
                            if (val!.isEmpty) return 'Required';
                            if (double.tryParse(val) == null) {
                              return 'Enter valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _qualificationController,
                        label: 'Qualification *',
                        hint: 'e.g., M.A - Psychology, Ph.D - Counselling',
                        validator: (val) => val!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Additional Information', textTheme),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _bioController,
                        label: 'Bio *',
                        maxLines: 4,
                        hint: 'Write a brief bio about the counsellor...',
                        validator: (val) => val!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTwoColumnLayout(
                        isDesktop,
                        _buildFilePicker(),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password *',
                          obscureText: true,
                          validator: (val) {
                            if (val!.isEmpty) return 'Required';
                            if (val.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
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
                            onPressed: _saveCounsellor,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkRed,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: Text(
                              widget.counsellor == null
                                  ? 'Add Counsellor'
                                  : 'Save',
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
