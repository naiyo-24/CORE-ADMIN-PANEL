import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/counsellor_controller.dart';
import 'onboard_edit_counsellor_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CounsellorTableCard extends StatelessWidget {
  const CounsellorTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.textThemeFromContext(context);
    final counsellorController = Get.find<CounsellorController>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Counsellors Directory',
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.darkGray,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Obx(() {
            if (counsellorController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.darkRed),
              );
            }

            final counsellors = counsellorController.filteredCounsellors;

            if (counsellors.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'No counsellors found',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.darkGrayLight,
                    ),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                headingRowColor: MaterialStateColor.resolveWith(
                  (_) => AppColors.lightGray,
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'ID',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Photo',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Name',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Phone',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Email',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Address',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Experience',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Qualification',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Commission %',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Alt Phone',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Actions',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                ],
                rows: List.generate(counsellors.length, (index) {
                  final counsellor = counsellors[index];

                  return DataRow(
                    color: MaterialStateColor.resolveWith(
                      (_) =>
                          index.isEven ? AppColors.white : AppColors.lightGray,
                    ),
                    cells: [
                      DataCell(Text(counsellor.id, style: textTheme.bodySmall)),
                      DataCell(
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: counsellor.profilePhotoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    counsellor.profilePhotoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        color: AppColors.darkGrayLight,
                                      );
                                    },
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  color: AppColors.darkGrayLight,
                                ),
                        ),
                      ),
                      DataCell(
                        Text(
                          counsellor.name,
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          counsellor.phoneNumber,
                          style: textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        Text(counsellor.email, style: textTheme.bodySmall),
                      ),
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Text(
                            counsellor.address,
                            style: textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${counsellor.experienceYears} years',
                          style: textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Text(
                            counsellor.qualification,
                            style: textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${counsellor.commissionPercentage}%',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.successGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          counsellor.alternatePhoneNumber,
                          style: textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.penToSquare,
                                size: 16,
                                color: AppColors.accentBlue,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      OnboardEditCounsellorCard(
                                        counsellor: counsellor,
                                      ),
                                  barrierDismissible: false,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.trash,
                                size: 16,
                                color: AppColors.errorRed,
                              ),
                              onPressed: () {
                                _showDeleteConfirmation(
                                  context,
                                  counsellor.id,
                                  counsellor.name,
                                  counsellorController,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String counsellorId,
    String counsellorName,
    CounsellorController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Counsellor'),
          content: Text('Are you sure you want to delete $counsellorName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteCounsellor(counsellorId);
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.errorRed),
              ),
            ),
          ],
        );
      },
    );
  }
}
