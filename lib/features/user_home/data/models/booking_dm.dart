class BookingDM {
  final String id;
  final String roomId;
  final String userId;
  final String userName;
  final String roomName;
  final DateTime checkIn;
  final DateTime checkOut;
  final double totalPrice;
  final String status; // 'pending', 'confirmed', 'cancelled'

  BookingDM({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.userName,
    required this.roomName,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
  });

  // Static list to store bookings
  static final List<BookingDM> bookings = [];

  // Add a new booking
  static void addBooking(BookingDM booking) {
    bookings.add(booking);
  }

  // Remove a booking
  static void removeBooking(String id) {
    bookings.removeWhere((booking) => booking.id == id);
  }

  // Get bookings for a specific user
  static List<BookingDM> getUserBookings(String userId) {
    return bookings.where((booking) => booking.userId == userId).toList();
  }

  // Update booking status
  static void updateBookingStatus(String id, String newStatus) {
    final index = bookings.indexWhere((booking) => booking.id == id);
    if (index != -1) {
      final booking = bookings[index];
      bookings[index] = BookingDM(
        id: booking.id,
        roomId: booking.roomId,
        userId: booking.userId,
        userName: booking.userName,
        roomName: booking.roomName,
        checkIn: booking.checkIn,
        checkOut: booking.checkOut,
        totalPrice: booking.totalPrice,
        status: newStatus,
      );
    }
  }
} 