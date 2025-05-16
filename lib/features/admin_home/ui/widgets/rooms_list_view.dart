import 'package:flutter/material.dart';
import 'package:software_task/features/admin_home/data/models/room_dm.dart';
import 'package:software_task/features/admin_home/ui/widgets/room_item.dart';
import 'package:software_task/features/user_home/ui/widgets/room_details.dart';
import 'package:software_task/features/user_home/ui/widgets/user_room_item.dart';

import 'edit_room_screen.dart';

class RoomsListView extends StatefulWidget {
  const RoomsListView({super.key, required this.isAdmin});

  final bool isAdmin;

  @override
  State<RoomsListView> createState() => _RoomsListViewState();
}

class _RoomsListViewState extends State<RoomsListView> {
  List<RoomDM> rooms = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  void _loadRooms() {
    setState(() {
      // Get rooms from the static list
      rooms = RoomDM.rooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return const Center(
        child: Text('No rooms available'),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          if (widget.isAdmin) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditRoomScreen(
                  roomDM: rooms[index],
                ),
              ),
            ).then((_) {
              // Reload rooms after returning from edit screen
              _loadRooms();
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoomDetails(
                  model: rooms[index],
                ),
              ),
            );
          }
        },
        child: widget.isAdmin
            ? RoomItem(
                roomDM: rooms[index],
              )
            : UserRoomItem(
                model: rooms[index],
              ),
      ),
      itemCount: rooms.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
    );
  }
}
