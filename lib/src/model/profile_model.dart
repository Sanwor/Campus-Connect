class ProfileModel {
  final String firstName;
  final String lastName;
  final String rollNo;
  final int semester;
  final String dob;
  final String address;
  final String? image;
  final String shift;

  ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.rollNo,
    required this.semester,
    required this.dob,
    required this.address,
    this.image,
    required this.shift,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      rollNo: json['roll_no'] ?? '',
      semester: json['semester'] ?? 0,
      dob: json['dob'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
      shift: json['shift'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'roll_no': rollNo,
      'semester': semester,
      'dob': dob,
      'address': address,
      'image': image,
      'shift': shift,
    };
  }
}