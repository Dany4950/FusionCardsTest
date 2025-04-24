import 'package:flutter/material.dart';
import 'package:vms/presentation/dashboard/stores/stores_screen.dart';

class MoksaExpansionTile extends StatelessWidget {
  final String title;
  final String? subTitle;
  final List<Pair> children;
  final Widget? leadingIcon;
  final Widget? trailing;
  final Widget? chartWidget;

  const MoksaExpansionTile({
    super.key,
    required this.title,
    this.subTitle,
    required this.children,
    this.leadingIcon,
    this.trailing,
    this.chartWidget
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Colors.grey.shade200,
      collapsedBackgroundColor: Colors.grey.shade200,
      showTrailingIcon: children.isNotEmpty || trailing != null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: leadingIcon == null
          ? null
          : Container(
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: leadingIcon,
            ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subTitle == null
          ? null
          : Text(
              subTitle!,
              style: TextStyle(
                color: Colors.black.withAlpha(153),
              ),
            ),
      trailing: trailing,
      childrenPadding: EdgeInsets.all(16),
      children: [
        ...children.map((child) => Column(
              children: [
                SpacedPairRow(item: child),
                if (child != children.last) const Divider(),
              ],
            )),
        if (chartWidget != null) chartWidget!,
      ],
    );
  }
}
