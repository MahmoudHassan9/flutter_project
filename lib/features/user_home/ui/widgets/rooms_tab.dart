import 'package:flutter/material.dart';
import 'package:software_task/features/admin_home/data/models/room_dm.dart';
import 'package:software_task/features/user_home/data/models/booking_dm.dart';
import 'package:software_task/features/auth/data/models/user_dm.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import 'room_details.dart';

class RoomsTab extends StatefulWidget {
  const RoomsTab({super.key});

  @override
  State<RoomsTab> createState() => _RoomsTabState();
}

class _RoomsTabState extends State<RoomsTab> {
  @override
  Widget build(BuildContext context) {
    final rooms = RoomDM.rooms;
    if (rooms.isEmpty) {
      return const Center(
        child: Text(
          'No rooms available',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomDetails(model: room),
                ),
              ).then((_) => setState(() {}));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(
                      12,
                    ),
                  ),
                  child: Image.asset(
                    AppConstants.roomImage,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              room.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  room.isAvailable ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              room.isAvailable ? 'AVAILABLE' : 'BOOKED',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                          'Price', '\$${room.price.toStringAsFixed(2)}/night'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Capacity', '${room.capacity} persons'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Description', room.description,
                          maxLines: 2),
                      const SizedBox(height: 12),
                      if (room.isAvailable)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blue,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              _bookRoom(context, room);
                            },
                            child: const Text('Book Now'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, {int? maxLines}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }

  void _bookRoom(BuildContext context, RoomDM room) {
    // Get current user
    final currentUser = UserDM.getCurrentUser();
    if (currentUser == null) {
      AppDialogs.showMessage(
        context,
        message: 'Please login first to book a room',
        color: Colors.red,
      );
      return;
    }

    // Create a new booking
    final booking = BookingDM(
      id: (BookingDM.bookings.length + 1).toString(),
      roomId: room.id,
      userId: currentUser.id!,
      userName: currentUser.fullName!,
      roomName: room.name,
      checkIn: DateTime.now(),
      checkOut: DateTime.now().add(const Duration(days: 1)),
      totalPrice: room.price,
      status: 'pending',
    );

    // Add booking to static list
    BookingDM.addBooking(booking);

    // Update room availability
    RoomDM.updateRoomAvailability(room.id, false);

    setState(() {});

    // Show success message
    AppDialogs.showMessage(
      context,
      message: 'Room booked successfully!',
      color: Colors.green,
    );
  }
}
