class DashboardMetrics {
  final int totalStudents;
  final int totalTeachers;
  final int totalCounsellors;
  final int totalCourses;
  final double totalFeesCollected;
  final double totalTeacherPayout;
  final double totalCounselllorPayout;
  final DateTime lastUpdated;

  DashboardMetrics({
    required this.totalStudents,
    required this.totalTeachers,
    required this.totalCounsellors,
    required this.totalCourses,
    required this.totalFeesCollected,
    required this.totalTeacherPayout,
    required this.totalCounselllorPayout,
    required this.lastUpdated,
  });

  factory DashboardMetrics.empty() {
    return DashboardMetrics(
      totalStudents: 0,
      totalTeachers: 0,
      totalCounsellors: 0,
      totalCourses: 0,
      totalFeesCollected: 0.0,
      totalTeacherPayout: 0.0,
      totalCounselllorPayout: 0.0,
      lastUpdated: DateTime.now(),
    );
  }
}

class MonthlyFeeData {
  final String month;
  final int year;
  final double amount;

  MonthlyFeeData({
    required this.month,
    required this.year,
    required this.amount,
  });
}

class MonthlyPayoutData {
  final String month;
  final int year;
  final double amount;

  MonthlyPayoutData({
    required this.month,
    required this.year,
    required this.amount,
  });
}
