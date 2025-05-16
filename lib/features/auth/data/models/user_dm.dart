class UserDM {
  final String? id;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? password;
  final String? gender;

  // Static variable to track current user's email
  static String? currentUserEmail;

  UserDM({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.password,
    this.gender,
  });

  // Static list of users
  static final List<UserDM> users = [
  ];

  // Add a new user to the static list
  static void addUser(UserDM user) {
    users.add(user);
  }

  // Remove a user from the static list
  static void removeUser(String id) {
    users.removeWhere((user) => user.id == id);
  }

  // Update a user in the static list
  static void updateUser(UserDM updatedUser) {
    final index = users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      users[index] = updatedUser;
    }
  }

  // Find a user by email and password
  static UserDM? findUser(String email, String password) {
    try {
      final user = users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
      // Set current user email when found
      currentUserEmail = email;
      return user;
    } catch (e) {
      return null;
    }
  }

  // Check if email already exists
  static bool isEmailExists(String email) {
    try {
      users.firstWhere((user) => user.email == email);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get current user
  static UserDM? getCurrentUser() {
    if (currentUserEmail == null) return null;
    try {
      return users.firstWhere((user) => user.email == currentUserEmail);
    } catch (e) {
      return null;
    }
  }
} 