import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vms/data/theft/thefts_list_data.dart';
import 'package:vms/presentation/dashboard/stores/vm_stores.dart';
import 'package:vms/presentation/dashboard/theft/theft_item_card.dart';
import 'package:vms/presentation/dashboard/theft/vm_theft.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';

class TheftList extends StatefulWidget {
  final Widget topItems;

  const TheftList({
    super.key,
    required this.topItems,
  });

  @override
  State<TheftList> createState() => _TheftListState();
}

class _TheftListState extends State<TheftList> {
  late VMTheft vmTheft;
  late VMStores vmStores;
  late VMDateRange dateRangeVM;

  @override
  void initState() {
    super.initState();
    vmTheft = Get.find<VMTheft>();
    vmStores = Get.find<VMStores>();
    dateRangeVM = Get.find<VMDateRange>();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        vmTheft.pagingController.refresh();
      },
      child: Obx(
        () => vmTheft.isFirstPageEmpty.value
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: widget.topItems,
              )
            : PagedListView<int, TheftsListItem>(
                pagingController: vmTheft.pagingController,
                physics: const AlwaysScrollableScrollPhysics(),
                builderDelegate: PagedChildBuilderDelegate<TheftsListItem>(
                  firstPageProgressIndicatorBuilder: (context) => Column(
                    children: [
                      widget.topItems,
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
                  firstPageErrorIndicatorBuilder: (context) => Column(
                    children: [
                      widget.topItems,
                      Center(
                        child: Column(
                          children: [
                            const Text('Error loading thefts'),
                            ElevatedButton(
                              onPressed: () =>
                                  vmTheft.pagingController.refresh(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Column(
                    children: [
                      widget.topItems,
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No thefts found'),
                        ),
                      ),
                    ],
                  ),
                  itemBuilder: (context, item, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == 0) widget.topItems,
                        TheftItemCard(item),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }
}

// class TheftList extends StatefulWidget {
//   final Widget topItems;

//   const TheftList({super.key, required this.topItems});

//   @override
//   State<TheftList> createState() => _TheftListState();
// }

// class _TheftListState extends State<TheftList> {
//   VMTheft vmTheft = Get.find();
//   late VMStores vmStores;
//   late DateRangeVM dateRangeVM;

//   @override
//   void initState() {
//     super.initState();
//     vmTheft = Get.find<VMTheft>();
//     vmStores = Get.find<VMStores>();
//     dateRangeVM = Get.find<DateRangeVM>();

//     vmTheft.pagingController.addPageRequestListener((pageKey) {
//       if (vmStores.selectedStore.value != null) {
//         vmTheft.currentPage.value = pageKey;
//         vmTheft.getTheftListByStoreId(
//           vmStores.selectedStore.value!.id.toString(),
//           pageKey,
//           range: dateRangeVM.selectedDate.value,
//         );
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (vmStores.selectedStore.value != null) {
//         vmTheft.pagingController.refresh();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => vmTheft.isFirstPageEmpty.value
//           ? widget.topItems
//           : PagedListView(
//               pagingController: vmTheft.pagingController,
//               builderDelegate:
//                   PagedChildBuilderDelegate<TheftsListItem>(
//                 itemBuilder: (context, theft, index) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (index == 0) widget.topItems,
//                       TheftItemCard(theft),
//                     ],
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }
