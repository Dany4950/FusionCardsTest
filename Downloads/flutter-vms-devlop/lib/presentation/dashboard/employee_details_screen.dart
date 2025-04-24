import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';
import 'package:vms/utils/widgets/employtrack_card_widget.dart';

import '../../common/colors.dart';
import '../../common/fonts.dart';
import '../../data/employee_efficiency_details.dart';
import '../../utils/widgets/common_widget.dart';
import 'employee_efficiency/vm_employee_efficiency.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final EmployeeEfficiencyItemData employee;
  final DateRangeType range;

  const EmployeeDetailsScreen(
      {super.key, required this.employee, required this.range});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  // List<EmployeeData>? employeeData;
  bool isLoading = true;
  VMEmployeeEfficiency vmEmployeeEfficiency = Get.find();

  @override
  void initState() {
    super.initState();
    _fetchEmployeeDetails();
  }

  Future<void> _fetchEmployeeDetails() async {
    try {
      final data = await vmEmployeeEfficiency.getEmployeeEfficiencyByEmpid(
          widget.employee.employeeId,
          range: widget.range);
      debugPrint("data of employee---$data");
      setState(() {
        // employeeData = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  int parseEfficiencyScore(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    if (value is String) {
      String cleanValue = value.replaceAll('%', '').trim();
      return int.tryParse(cleanValue) ?? 0;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: false,
        title: getText(
          widget.employee.employee ?? "",
          fontSize: 18,
          fontWeight: Weight.medium,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.employee == null
              ? const Center(child: Text('No data found!'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getText(
                        "Employee Tracking",
                        fontWeight: Weight.medium,
                        fontSize: 14,
                      ),
                      const Gap(14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                EmploytrackCardWidget(
                                  icon: Icons.people_outline,
                                  title: 'With Customers',
                                  value: widget.employee.customer.toString(),
                                ),
                                const SizedBox(height: 20),
                                EmploytrackCardWidget(
                                  icon: Icons.shelves,
                                  title: 'Filling Shelves',
                                  value:
                                      widget.employee.fillingShelves.toString(),
                                ),
                                const SizedBox(height: 20),
                                EmploytrackCardWidget(
                                  icon: Icons.wallet_travel_rounded,
                                  title: 'Working Hours',
                                  value: "Coming Soon",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                EmploytrackCardWidget(
                                    icon: Icons.tablet_android,
                                    title: 'On Mobile',
                                    value: widget.employee.mobile.toString()),
                                const SizedBox(height: 20),
                                EmploytrackCardWidget(
                                    icon: Icons.timer_outlined,
                                    title: 'Login Time',
                                    value: widget.employee.idle.toString()),
                                const SizedBox(height: 20),
                                EmploytrackCardWidget(
                                    icon: Icons.timer,
                                    title: 'Sitting Idle',
                                    value: widget.employee.idle.toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      getText(
                        "Employee Efficiency Score",
                        fontWeight: Weight.medium,
                        fontSize: 14,
                      ),
                      const Gap(14),
                      Container(
                        height: 131,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    getScoreTitle(
                                        "Based on Mobile Usage ",
                                        (parseEfficiencyScore(
                                            widget.employee.efficiencyScore))),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: CircularPercentIndicator(
                                radius: 45,
                                lineWidth: 8,
                                animation: true,
                                circularStrokeCap: CircularStrokeCap.round,
                                percent: parseEfficiencyScore(
                                            widget.employee.efficiencyScore)
                                        .clamp(0, 100) /
                                    100,
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    getText(
                                      '${parseEfficiencyScore(widget.employee.efficiencyScore)}%',
                                      fontWeight: Weight.medium,
                                      fontSize: 16,
                                      txtHeight: 0,
                                    ),
                                    getText(
                                      'Efficient',
                                      fontWeight: Weight.medium,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                                backgroundColor:
                                    AppColors.lightBlue.withOpacity(0.2),
                                progressColor: AppColors.lightBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget getScoreTitle(String title, int score) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(fontSize: 16),
          ),
          TextSpan(
            text: "$score %",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
