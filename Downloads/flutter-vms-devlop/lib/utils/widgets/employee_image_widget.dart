import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vms/utils/util_functions.dart';

class ProfilePhotoWidget extends StatelessWidget {
  final String photoUrl;
  final double radius;
  final int employeeId;

  const ProfilePhotoWidget({
    required this.photoUrl,
    this.radius = 20,
    super.key,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrl.isEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.grey,
        radius: radius,
        child: Icon(
          Icons.person,
          size: radius * 1.25,
          color: Colors.white,
        ),
      );
    }

    return FutureBuilder<String?>(
      future: getPresignedEmpImageUrl(employeeId, photoUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return CircleAvatar(
            backgroundColor: Colors.grey,
            radius: radius,
            child: Icon(
              Icons.error_outline,
              size: radius * 1.25,
              color: Colors.white,
            ),
          );
        } else {
          return ClipOval(
            child: CachedNetworkImage(
              imageUrl: snapshot.data!,
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
              placeholder: (context, url) => SizedBox(
                width: radius * 2,
                height: radius * 2,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: Colors.grey,
                radius: radius,
                child: Icon(
                  Icons.error_outline,
                  size: radius * 1.25,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
