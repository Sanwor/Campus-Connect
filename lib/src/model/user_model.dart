class UserModel {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final bool isStaff;
  final List<dynamic> groups;
  final Map<String, dynamic>? profile;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    required this.isStaff,
    this.groups = const [],
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      isStaff: json['is_staff'] ?? false,
      groups: json['groups'] ?? [],
      profile: json['profile'] is Map ? json['profile'] : null,
    );
  }

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return username;
  }

  String? get profileImage => profile?['image'];
  String? get dateOfBirth => profile?['dob'];
  String? get address => profile?['address'];
  String? get shift => profile?['shift'];
  String? get rollNo => profile?['roll_no'];
}