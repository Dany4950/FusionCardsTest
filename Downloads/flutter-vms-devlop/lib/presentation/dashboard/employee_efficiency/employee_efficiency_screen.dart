import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/presentation/dashboard/employee_details_screen.dart';
import 'package:vms/presentation/dashboard/employee_efficiency/vm_employee_efficiency.dart';
import 'package:vms/presentation/dashboard/stores/vm_stores.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';
import 'package:vms/presentation/widgets/moksa_nav_bar.dart';
import 'package:vms/presentation/widgets/stores_date_tab_bars.dart';
import 'package:vms/utils/widgets/employee_image_widget.dart';
import '../../../data/employee_efficiency_details.dart';
import 'employee_efficiency_live.dart';

class EmployeeEfficiencyScreen extends StatefulWidget {
  const EmployeeEfficiencyScreen({super.key});

  @override
  State<EmployeeEfficiencyScreen> createState() =>
      _EmployeeEfficiencyScreenState();
}

class _EmployeeEfficiencyScreenState extends State<EmployeeEfficiencyScreen>
    with SingleTickerProviderStateMixin {
  VMEmployeeEfficiency vmEmployeeEfficiency = Get.find();
  VMStores vmStores = Get.find();
  final VMDateRange dateRangeVM = Get.find();

  // Add variables to store listener subscriptions
  late Worker _storesListener;
  late Worker _selectedStoreListener;
  late Worker _dateListener;

  @override
  void dispose() {
    // Cancel all the listeners
    _storesListener.dispose();
    _selectedStoreListener.dispose();
    _dateListener.dispose();

    // Remove page request listener
    vmEmployeeEfficiency.pagingController
        .removePageRequestListener(_pageRequestListener);

    super.dispose();
  }

  void _pageRequestListener(int pageKey) {
    if (vmStores.storesForDropDown.value != null) {
      vmEmployeeEfficiency.currentPage.value = pageKey;
      vmEmployeeEfficiency.getEmployeeEfficiencyByStoreid(
        vmStores.selectedStore.value!.id,
        pageKey,
        range: dateRangeVM.selectedDate.value,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageRequestListener(0);

    // Use ever() instead of listen() to get a Worker reference
    _storesListener = ever(vmStores.storesForDropDown, (stores) {
      if (stores != null) {
        vmEmployeeEfficiency.pagingController.refresh();
      }
    });

    _selectedStoreListener = ever(vmStores.selectedStore, (store) {
      if (store != null) {
        vmEmployeeEfficiency.pagingController.refresh();
      }
    });

    _dateListener = ever(dateRangeVM.selectedDate, (dateType) {
      vmEmployeeEfficiency.pagingController.refresh();
    });

    vmEmployeeEfficiency.pagingController.refresh();
    vmEmployeeEfficiency.pagingController
        .addPageRequestListener(_pageRequestListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoksaNavBar("Employee Efficiency"),
      body: Obx(
        () => vmStores.storesForDropDown.value == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: StoresDateTabBars())),
                  Gap(8),
                  Expanded(
                    child: vmStores.isLiveSelected
                        ? EmployeeEfficiencyLiveWidget(-1)
                        : PagedListView(
                            pagingController:
                                vmEmployeeEfficiency.pagingController,
                            builderDelegate: PagedChildBuilderDelegate<
                                EmployeeEfficiencyItemData>(
                              itemBuilder: (context, item, index) {
                                return EmployeeCard(item);
                              },
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final EmployeeEfficiencyItemData employee;
  final bool isLive;
  final VMEmployeeEfficiency vmEmployeeEfficiency = Get.find();

  EmployeeCard(this.employee, {this.isLive = false, super.key});

  double getEfficiencyPercent() {
    if (employee.efficiencyScore == null) return 0.0;

    try {
      double value;
      if (employee.efficiencyScore is int) {
        value = (employee.efficiencyScore as int).toDouble();
      } else {
        String scoreStr =
            employee.efficiencyScore.toString().replaceAll('%', '').trim();
        value = double.tryParse(scoreStr) ?? 0.0;
      }

      return (value / 100).clamp(0.0, 1.0);
    } catch (e) {
      return 0.0;
    }
  }

  String getEfficiencyDisplay() {
    if (employee.efficiencyScore == null) return "0%";

    try {
      if (employee.efficiencyScore is int) {
        return "${employee.efficiencyScore}%";
      }

      String scoreStr = employee.efficiencyScore.toString();
      if (!scoreStr.endsWith('%')) {
        scoreStr = '$scoreStr%';
      }
      return scoreStr;
    } catch (e) {
      return "0%";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: AppColors.lightGrey,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          clipBehavior: Clip.hardEdge,
          child: ProfilePhotoWidget(
            photoUrl: employee.photo,
            employeeId: employee.employeeId,
          ),
        ),
        title: Text(
          employee.employee ?? "",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Store: ${employee.storename}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: CircularPercentIndicator(
          radius: 26.0,
          lineWidth: 6.0,
          circularStrokeCap: CircularStrokeCap.round,
          percent: getEfficiencyPercent(),
          center: Text(
            getEfficiencyDisplay(),
          ),
          backgroundColor: AppColors.white,
          progressColor: AppColors.lightBlue,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                final range = Get.find<VMDateRange>().selectedDate.value;

                return EmployeeDetailsScreen(
                  employee: employee,
                  range: range,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
