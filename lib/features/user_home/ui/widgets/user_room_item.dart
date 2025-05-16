import 'package:flutter/cupertino.dart';
import 'package:software_task/features/admin_home/data/models/room_dm.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_colors.dart';

class UserRoomItem extends StatelessWidget {
  const UserRoomItem({super.key, required this.model});
final RoomDM model;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            height: 175,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  AppConstants.roomImage,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  model.name ?? '',
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '\$${model.price!}/night' ?? '',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
