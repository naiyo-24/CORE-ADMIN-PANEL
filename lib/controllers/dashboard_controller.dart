import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/dashboard.dart';

class DashboardController extends GetxController {
  // Observable state
  final Rx<DashboardMetrics> metrics = DashboardMetrics.empty().obs;
  final RxList<MonthlyFeeData> monthlyFees = <MonthlyFeeData>[].obs;
  final RxList<MonthlyPayoutData> monthlyTeacherPayout =
      <MonthlyPayoutData>[].obs;
  final RxList<MonthlyPayoutData> monthlyCounselllorPayout =
      <MonthlyPayoutData>[].obs;
  final RxBool isLoading = false.obs;

  // Year filtering
  final RxInt selectedYear = 2025.obs;
  final RxList<int> availableYears = <int>[2023, 2024, 2025].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  // Fetch all dashboard data
  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      // Simulate API calls
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for metrics
      metrics.value = DashboardMetrics(
        totalStudents: 1250,
        totalTeachers: 85,
        totalCounsellors: 45,
        totalCourses: 32,
        totalFeesCollected: 2500000,
        totalTeacherPayout: 850000,
        totalCounselllorPayout: 320000,
        lastUpdated: DateTime.now(),
      );

      // Mock monthly fees data for current year
      monthlyFees.value = [
        MonthlyFeeData(month: 'Jan', year: 2025, amount: 150000),
        MonthlyFeeData(month: 'Feb', year: 2025, amount: 175000),
        MonthlyFeeData(month: 'Mar', year: 2025, amount: 200000),
        MonthlyFeeData(month: 'Apr', year: 2025, amount: 185000),
        MonthlyFeeData(month: 'May', year: 2025, amount: 220000),
        MonthlyFeeData(month: 'Jun', year: 2025, amount: 210000),
        MonthlyFeeData(month: 'Jul', year: 2025, amount: 230000),
        MonthlyFeeData(month: 'Aug', year: 2025, amount: 245000),
        MonthlyFeeData(month: 'Sep', year: 2025, amount: 235000),
        MonthlyFeeData(month: 'Oct', year: 2025, amount: 250000),
        MonthlyFeeData(month: 'Nov', year: 2025, amount: 260000),
        MonthlyFeeData(month: 'Dec', year: 2025, amount: 275000),
      ];

      // Mock monthly teacher payout data
      monthlyTeacherPayout.value = [
        MonthlyPayoutData(month: 'Jan', year: 2025, amount: 50000),
        MonthlyPayoutData(month: 'Feb', year: 2025, amount: 55000),
        MonthlyPayoutData(month: 'Mar', year: 2025, amount: 60000),
        MonthlyPayoutData(month: 'Apr', year: 2025, amount: 58000),
        MonthlyPayoutData(month: 'May', year: 2025, amount: 65000),
        MonthlyPayoutData(month: 'Jun', year: 2025, amount: 62000),
        MonthlyPayoutData(month: 'Jul', year: 2025, amount: 68000),
        MonthlyPayoutData(month: 'Aug', year: 2025, amount: 70000),
        MonthlyPayoutData(month: 'Sep', year: 2025, amount: 68000),
        MonthlyPayoutData(month: 'Oct', year: 2025, amount: 72000),
        MonthlyPayoutData(month: 'Nov', year: 2025, amount: 75000),
        MonthlyPayoutData(month: 'Dec', year: 2025, amount: 80000),
      ];

      // Mock monthly counsellor payout data
      monthlyCounselllorPayout.value = [
        MonthlyPayoutData(month: 'Jan', year: 2025, amount: 20000),
        MonthlyPayoutData(month: 'Feb', year: 2025, amount: 22000),
        MonthlyPayoutData(month: 'Mar', year: 2025, amount: 25000),
        MonthlyPayoutData(month: 'Apr', year: 2025, amount: 24000),
        MonthlyPayoutData(month: 'May', year: 2025, amount: 28000),
        MonthlyPayoutData(month: 'Jun', year: 2025, amount: 26000),
        MonthlyPayoutData(month: 'Jul', year: 2025, amount: 30000),
        MonthlyPayoutData(month: 'Aug', year: 2025, amount: 32000),
        MonthlyPayoutData(month: 'Sep', year: 2025, amount: 30000),
        MonthlyPayoutData(month: 'Oct', year: 2025, amount: 33000),
        MonthlyPayoutData(month: 'Nov', year: 2025, amount: 35000),
        MonthlyPayoutData(month: 'Dec', year: 2025, amount: 38000),
      ];
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching dashboard data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Change selected year
  void setSelectedYear(int year) {
    selectedYear.value = year;
  }

  // Refresh dashboard data
  Future<void> refreshData() async {
    await fetchDashboardData();
  }
}
