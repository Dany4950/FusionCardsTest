import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vms/common/fonts.dart';
import 'package:vms/common/images.dart';
import 'package:vms/data/kitchen_safety_data.dart';
import 'package:vms/presentation/dashboard/kitchen_safety/vm_kitchen_safety.dart';
import 'package:vms/presentation/dashboard/stores/vm_stores.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';
import 'package:vms/presentation/widgets/moksa_nav_bar.dart';
import 'package:vms/presentation/widgets/stores_date_tab_bars.dart';
import 'package:vms/utils/widgets/employee_image_widget.dart';

import '../../../common/colors.dart';
import '../../../utils/widgets/common_widget.dart';
import 'kitchen_safety_details.dart';
import 'kitchen_safety_live.dart';

class KitchenSafetyScreen extends StatefulWidget {
  const KitchenSafetyScreen({super.key});

  @override
  State<KitchenSafetyScreen> createState() => _KitchenSafetyScreenState();
}

class _KitchenSafetyScreenState extends State<KitchenSafetyScreen>
    with SingleTickerProviderStateMixin {
  VMKitchenSafety vmKitchenSafety = Get.find();
  VMStores vmStores = Get.find();
  final VMDateRange dateRangeVM = Get.find();
  List<String> types = ["Live", "History"];
  late RxString selectedItem = RxString(types.first);

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
    vmKitchenSafety.pagingController
        .removePageRequestListener(_pageRequestListener);

    super.dispose();
  }

  void _pageRequestListener(int pageKey) {
    if (vmStores.storesForDropDown.value != null) {
      vmKitchenSafety.currentPage.value = pageKey;
      vmKitchenSafety.getKitchenSafetyDetailsOfAllEmployeesByStore(
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
        vmKitchenSafety.pagingController.refresh();
      }
    });

    _selectedStoreListener = ever(vmStores.selectedStore, (store) {
      if (store != null) {
        _pageRequestListener(0);
        vmKitchenSafety.pagingController.refresh();
      }
    });

    _dateListener = ever(dateRangeVM.selectedDate, (dateType) {
      // _pageRequestListener(0);
      vmKitchenSafety.pagingController.refresh();
    });

    vmKitchenSafety.pagingController.refresh();
    vmKitchenSafety.pagingController
        .addPageRequestListener(_pageRequestListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoksaNavBar("Kitchen Safety"),
      body: Obx(
        () => vmStores.storesForDropDown.value == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StoresDateTabBars(isKitchenScreen: true),
                  // Gap(8),
                  Expanded(
                    child: Obx(
                      () => vmStores.isLiveSelected
                          ? KitchenSafetyLiveWidget(-1)
                          : PagedListView(
                              pagingController:
                                  vmKitchenSafety.pagingController,
                              builderDelegate:
                                  PagedChildBuilderDelegate<KsEmployeeData>(
                                itemBuilder: (context, item, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: KSafetyCard(item),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class KSafetyCard extends StatelessWidget {
  final KsEmployeeData employee;

  const KSafetyCard(this.employee, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: getText(
            employee.firstName,
            fontWeight: Weight.medium,
            fontSize: 14,
          ),
          leading: ProfilePhotoWidget(
            photoUrl: employee.photo,
            employeeId: employee.employeeId,
          ),
          children: [
            buildSafetyStatus("mask".png, 'Mask', employee.wearingMask),
            divider,
            buildSafetyStatus("gloves".png, 'Gloves', employee.wearingGloves),
            divider,
            buildSafetyStatus(
                "hairnet".png, 'Hairnet', employee.wearingHairNet),
            divider,
            buildSafetyStatus(
                "uniform".png, 'Uniform', employee.wearingUniform),
            Gap(2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KitchenSafetyDetails(employee),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.pink.withOpacity(0.09),
                          child: Icon(
                            Icons.image,
                            size: 20,
                            color: AppColors.pink,
                          ),
                        ),
                        Gap(7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getText("View Image", fontSize: 12),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Gap(14),
          ],
        ),
      ),
    );
  }

  Widget buildSafetyStatus(String image, String item, String status) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
      child: Row(
        children: [
          getAssetImage(image, width: 32, height: 32),
          Gap(6),
          Expanded(
            child: getText(
              item,
              fontSize: 12,
              fontWeight: Weight.medium,
            ),
          ),
          Gap(6),
          CircleAvatar(
            backgroundColor: AppColors.white,
            radius: 9.5,
            child: getAssetImage(
              status.toLowerCase() == 'false'
                  ? "circle_on".png
                  : "circle_off".png,
              width: 14,
              height: 14,
            ),
          ),
        ],
      ),
    );
  }
}
