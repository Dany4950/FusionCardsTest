import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/data/theft/thefts_list_data.dart';
import 'package:vms/manager/utils.dart';
import 'package:vms/presentation/dashboard/video_player_screen.dart';

class TheftItemCard extends StatelessWidget {
  final TheftsListItem theft;

  const TheftItemCard(this.theft, {super.key});

  @override
  Widget build(BuildContext context) {
    print('Building TheftItemCard for ${theft.name}');
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Card(
        elevation: 0,
        color: AppColors.lightGrey,
        child: ListTile(
          title: Text(
            '${theft.name}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('MMM dd yyyy hh:mm a')
                  .format(theft.createdAt.toLocal())),
              Text('Probability: ${theft.theftProbability}'),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.play_circle_outline),
            onPressed: () {
              if (theft.videoUri != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      videoUrl: theft.videoUri!,
                    ),
                  ),
                );
              } else {
                showToast("Video not found!");
              }
            },
          ),
        ),
      ),
    );
  }
}
