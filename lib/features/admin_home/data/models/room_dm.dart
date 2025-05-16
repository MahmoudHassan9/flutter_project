class RoomDM {
  final String id;
  final String name;
  final String description;
  final double price;
  final int capacity;
  bool isAvailable;

  RoomDM({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.capacity,
    this.isAvailable = true,
  });

  // Static list to store rooms
  static final List<RoomDM> rooms = [
    RoomDM(
      id: '1',
      name: 'Deluxe Suite',
      description: 'Spacious suite with ocean view, king-size bed, and luxury amenities.',
      price: 200.0,
      capacity: 2,
    ),
    RoomDM(
      id: '2',
      name: 'Family Room',
      description: 'Large family room with two queen beds, perfect for families.',
      price: 250.0,
      capacity: 4,
    ),
    RoomDM(
      id: '3',
      name: 'Executive Room',
      description: 'Modern room with city view, work desk, and premium services.',
      price: 180.0,
      capacity: 2,
    ),
    RoomDM(
      id: '4',
      name: 'Presidential Suite',
      description: 'Luxury suite with separate living area, jacuzzi, and butler service.',
      price: 500.0,
      capacity: 2,
    ),
  ];

  // Add a new room
  static void addRoom(RoomDM room) {
    rooms.add(room);
  }

  // Remove a room
  static void removeRoom(String id) {
    rooms.removeWhere((room) => room.id == id);
  }

  // Update room availability
  static void updateRoomAvailability(String id, bool isAvailable) {
    final index = rooms.indexWhere((room) => room.id == id);
    if (index != -1) {
      rooms[index].isAvailable = isAvailable;
    }
  }

  // Update room details
  static void updateRoom(String id, RoomDM updatedRoom) {
    final index = rooms.indexWhere((room) => room.id == id);
    if (index != -1) {
      rooms[index] = updatedRoom;
    }
  }
}
