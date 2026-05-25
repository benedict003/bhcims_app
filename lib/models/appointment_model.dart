class AppointmentModel {
  final int id;
  final int residentId;
  final String residentName;
  final String doctorName;
  final String appointmentDate;
  final String appointmentTime;
  final String purpose;
  final String status;

  AppointmentModel({
    required this.id,
    required this.residentId,
    required this.residentName,
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.purpose,
    required this.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? 0,
      residentId: json['resident_id'] ?? 0,


      residentName: json['resident_name'] ?? '',
      doctorName: json['doctor_name'] ?? '',

      appointmentDate: json['appointment_date'] ?? '',
      appointmentTime: json['appointment_time'] ?? '',
      purpose: json['purpose'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resident_id': residentId,
      'resident_name': residentName,
      'doctor_name': doctorName,
      'appointment_date': appointmentDate,
      'appointment_time': appointmentTime,
      'purpose': purpose,
      'status': status,
    };
  }
}