import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/common/fonts.dart';
import 'package:vms/common/images.dart';
import 'package:vms/data/all_stores_data.dart';
import 'package:vms/presentation/dashboard/stores/vm_stores.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

class StoresTabBar extends StatelessWidget {
  final VMStores vmStores = Get.find();
  final VMDateRange dateRangeVM = Get.find();
  final bool isKitchenScreen;
  final bool shouldShowLive;

  StoresTabBar({
    super.key,
    this.isKitchenScreen = false,
    this.shouldShowLive = true,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeStores();
    });
  }

  void initializeStores() {
    vmStores.getAllStoresForDropdown();

    if ((vmStores.isLiveSelected && shouldShowLive == false) ||
        (vmStores.isStoreWithKitechSelected == false && isKitchenScreen)) {
      final availableStores = filteredStores.where((store) => store.id != -1);
      if (availableStores.isNotEmpty) {
        vmStores.selectedStore.value = availableStores.first;
      }
    }
  }

  Widget getItem(StoreData store) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: GestureDetector(
        onTap: () {
          if (dateRangeVM.isEnable.value) {
            vmStores.selectedStore.value = store;
          }
        },
        child: Opacity(
          opacity: dateRangeVM.isEnable.value ? 1 : 0.5,
          child: Container(
            decoration: BoxDecoration(
              border: store.id == vmStores.selectedStore.value?.id
                  ? Border(
                      bottom: BorderSide(
                        width: 2.5,
                        color: AppColors.darkBlue,
                      ),
                    )
                  : null,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 9.0),
                  child: Image(
                    image: AssetImage(
                      store.id == vmStores.selectedStore.value?.id
                          ? "active_home".png
                          : "home".png,
                    ),
                    width: 20,
                  ),
                ),
                store.id == -1
                    ? Center(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF007A),
                            borderRadius: BorderRadius.circular(15),
                            shape: BoxShape.rectangle,
                          ),
                          child: Text('LIVE',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      )
                    : Text(
                        store.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: Weight.medium,
                          fontFamily: AppFonts.inter,
                          color: store.id == vmStores.selectedStore.value?.id
                              ? AppColors.darkBlue
                              : AppColors.black.withOpacity(0.5),
                        ),
                      ),
                Gap(10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Iterable<StoreData> get filteredStores =>
  //     vmStores.storesForDropDown.value
  //         ?.where((store) => isKitchenScreen
  //             ? store.hasKitchen == true || store.id == -1
  //             : true)
  //         .where((store) => shouldShowLive ? true : store.id != -1) ??
  //     [];

  Iterable<StoreData> get filteredStores =>
      vmStores.storesForDropDown.value
          ?.where((store) => isKitchenScreen
              ? store.hasKitchen == true || (shouldShowLive && store.id == -1)
              : true)
          .where((store) => shouldShowLive ? true : store.id != -1) ??
      [];

  List<Widget> get storeItems =>
      filteredStores.map((store) => getItem(store)).toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Obx(
          () => Row(children: storeItems),
        ),
      ),
    );
  }
}
