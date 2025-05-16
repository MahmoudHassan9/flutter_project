import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../admin_home/data/models/room_dm.dart';
import '../../../user_home/data/models/booking_dm.dart';
import '../../../auth/ui/widgets/custom_button.dart';
import '../../../auth/data/models/user_dm.dart';

class RoomDetails extends StatefulWidget {
  const RoomDetails({super.key, required this.model});

  final RoomDM model;

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  void _handleBookRoom(BuildContext context) {
    // Get current user
    final currentUser = UserDM.getCurrentUser();
    if (currentUser == null) {
      AppDialogs.showMessage(
        context,
        message: 'Please login to book a room',
        color: Colors.red,
      );
      return;
    }

    // Validate room availability
    if (!widget.model.isAvailable) {
      AppDialogs.showMessage(
        context,
        message: 'Sorry, this room is no longer available',
        color: Colors.red,
      );
      return;
    }

    // Create a new booking
    final booking = BookingDM(
      id: (BookingDM.bookings.length + 1).toString(),
      roomId: widget.model.id,
      userId: currentUser.id!,
      userName: currentUser.fullName!,
      roomName: widget.model.name,
      checkIn: DateTime.now(),
      checkOut: DateTime.now().add(const Duration(days: 1)),
      totalPrice: widget.model.price,
      status: 'pending',
    );

    // Add booking to static list
    BookingDM.addBooking(booking);

    // Update room availability
    RoomDM.updateRoomAvailability(widget.model.id, false);
    
    // Update local state
    setState(() {});

    // Show success message
    AppDialogs.showMessage(
      context,
      message: 'Room booked successfully!',
      color: Colors.green,
    );

    // Pop back to refresh the rooms list
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        title: Text(
          widget.model.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppConstants.roomImage,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 300,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  featureItem(
                    Icons.bed,
                    '${widget.model.capacity} persons',
                  ),
                  const SizedBox(width: 12),
                  featureItem(
                    Icons.tv,
                    'Smart TV',
                  ),
                  const SizedBox(width: 12),
                  featureItem(
                    Icons.bathtub,
                    'Private Bath',
                  ),
                  const SizedBox(width: 12),
                  featureItem(
                    Icons.wifi,
                    'Free WiFi',
                  ),
                  const SizedBox(width: 12),
                  featureItem(
                    Icons.ac_unit,
                    'Air Conditioning',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.model.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Room Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('Room Type', 'Deluxe Room'),
                    _buildDetailRow('Bed Type', 'King Size'),
                    _buildDetailRow('Room Size', '45 sqm'),
                    _buildDetailRow('View', 'City View'),
                    _buildDetailRow('Floor', '5th Floor'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavBar(context),
    );
  }

  Widget bottomNavBar(BuildContext context) => Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.blue.withOpacity(0.4),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Text(
              '\$${widget.model.price.toStringAsFixed(2)} /night',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Book Now',
              onPressed: widget.model.isAvailable 
                ? () => _handleBookRoom(context) 
                : null,
            ),
          ],
        ),
      );

  Widget featureItem(IconData icon, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.blue.withOpacity(0.4),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      );

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
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
            ),
          ),
        ],
      ),
    );
  }
}
