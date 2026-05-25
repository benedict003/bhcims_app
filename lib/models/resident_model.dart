class ResidentModel {
  final int? id;
  final int? userId;

  String firstName;
  String middleName;
  String lastName;
  String gender;
  String birthDate;
  String contactNumber;
  String address;
  String bloodType;
  String civilStatus;

  ResidentModel({
    this.id,
    this.userId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.contactNumber,
    required this.address,
    required this.bloodType,
    required this.civilStatus,
  });

  factory ResidentModel.fromJson(Map<String, dynamic> json) {
    return ResidentModel(
      id: json['id'],
      userId: json['user_id'],

      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      gender: json['gender'] ?? '',
      birthDate: json['birth_date'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      address: json['address'] ?? '',
      bloodType: json['blood_type'] ?? '',
      civilStatus: json['civil_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'gender': gender,
      'birth_date': birthDate,
      'contact_number': contactNumber,
      'address': address,
      'blood_type': bloodType,
      'civil_status': civilStatus,
    };
  }
}