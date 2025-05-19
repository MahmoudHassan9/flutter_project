import 'package:flutter/material.dart';
import 'package:software_task/features/admin_home/data/models/room_dm.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/app_syles.dart';
import '../../../auth/ui/widgets/custom_button.dart';
import '../../../auth/ui/widgets/title_and_text_form_field.dart';

class EditRoomScreen extends StatefulWidget {
  const EditRoomScreen({
    super.key,
    required this.roomDM,
  });

  final RoomDM roomDM;

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  late TextEditingController roomTitleController;
  late TextEditingController roomDescriptionController;
  late TextEditingController roomPriceController;
  late TextEditingController roomCapacityController;
  late TextEditingController roomIDController;
  GlobalKey<FormState> formKey = GlobalKey();

  // Track changed fields
  bool isTitleChanged = false;
  bool isDescriptionChanged = false;
  bool isPriceChanged = false;
  bool isCapacityChanged = false;

  @override
  void initState() {
    super.initState();
    roomTitleController = TextEditingController();
    roomDescriptionController = TextEditingController();
    roomPriceController = TextEditingController();
    roomCapacityController = TextEditingController();
    roomIDController = TextEditingController();

    // Initialize controllers with room data
    roomTitleController.text = widget.roomDM.name;
    roomDescriptionController.text = widget.roomDM.description;
    roomPriceController.text = widget.roomDM.price.toString();
    roomCapacityController.text = widget.roomDM.capacity.toString();
    roomIDController.text = widget.roomDM.id;

    // Add listeners to detect changes
    roomTitleController.addListener(() {
      setState(() {
        isTitleChanged = roomTitleController.text != widget.roomDM.name;
      });
    });

    roomDescriptionController.addListener(() {
      setState(() {
        isDescriptionChanged =
            roomDescriptionController.text != widget.roomDM.description;
      });
    });

    roomPriceController.addListener(() {
      setState(() {
        try {
          isPriceChanged =
              double.parse(roomPriceController.text) != widget.roomDM.price;
        } catch (e) {
          isPriceChanged = true;
        }
      });
    });

    roomCapacityController.addListener(() {
      setState(() {
        try {
          isCapacityChanged =
              int.parse(roomCapacityController.text) != widget.roomDM.capacity;
        } catch (e) {
          isCapacityChanged = true;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    roomTitleController.dispose();
    roomDescriptionController.dispose();
    roomPriceController.dispose();
    roomCapacityController.dispose();
    roomIDController.dispose();
  }

  bool _hasChanges() {
    return isTitleChanged ||
        isDescriptionChanged ||
        isPriceChanged ||
        isCapacityChanged;
  }

  void _handleUpdateRoom() {
    if (!formKey.currentState!.validate()) return;

    if (!_hasChanges()) {
      AppDialogs.showMessage(
        context,
        message: 'No changes to update',
        color: Colors.orange,
      );
      return;
    }

    // Create updated room object
    final updatedRoom = RoomDM(
      id: roomIDController.text,
      name: roomTitleController.text,
      description: roomDescriptionController.text,
      price: double.parse(roomPriceController.text),
      capacity: int.parse(roomCapacityController.text),
      isAvailable: widget.roomDM.isAvailable,
    );

    // Update the room in the static list
    RoomDM.updateRoom(roomIDController.text, updatedRoom);

    Navigator.pop(context);
    AppDialogs.showMessage(
      context,
      message: 'Room updated successfully',
      color: Colors.green,
    );
  }

  void _handleDeleteRoom() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Room'),
        content: const Text('Are you sure you want to delete this room?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Delete the room from the static list
              RoomDM.removeRoom(roomIDController.text);
              Navigator.pop(context); // Return to room list
              AppDialogs.showMessage(
                context,
                message: 'Room deleted successfully',
                color: Colors.red,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppColors.blue,
        centerTitle: true,
        title: Text(
          'Edit Room',
          style: AppStyles.appBar,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TitleAndTextFormField(
                  controller: roomIDController,
                  enabled: false,
                  title: 'Room ID',
                  hint: 'Enter room ID',
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'ID is required';
                    }
                    return null;
                  },
                ),
                TitleAndTextFormField(
                  controller: roomTitleController,
                  title: 'Room Name',
                  hint: 'Enter room name',
                  filledColor:
                      isTitleChanged ? Colors.blue.withOpacity(0.1) : null,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'Room name is required';
                    }
                    return null;
                  },
                ),
                TitleAndTextFormField(
                  controller: roomDescriptionController,
                  title: 'Room Description',
                  hint: 'Enter room description',
                  maxLines: 7,
                  filledColor: isDescriptionChanged
                      ? Colors.blue.withOpacity(0.1)
                      : null,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'Room description is required';
                    }
                    return null;
                  },
                ),
                TitleAndTextFormField(
                  controller: roomCapacityController,
                  title: 'Room Capacity',
                  hint: 'Enter number of persons',
                  filledColor:
                      isCapacityChanged ? Colors.blue.withOpacity(0.1) : null,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'Room capacity is required';
                    }
                    if (int.tryParse(input) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TitleAndTextFormField(
                  controller: roomPriceController,
                  title: 'Room Price',
                  hint: 'Enter room price per night',
                  filledColor:
                      isPriceChanged ? Colors.blue.withOpacity(0.1) : null,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'Price is required';
                    }
                    if (double.tryParse(input) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "Update",
                        color: AppColors.blue,
                        onPressed: _handleUpdateRoom,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        text: "Delete",
                        color: AppColors.red,
                        onPressed: _handleDeleteRoom,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
