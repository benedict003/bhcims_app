class ConsultationModel {
  final int? id;
  final int residentId;
  final String symptoms;
  final String diagnosis;
  final String? treatment;
  final String? prescription;
  final String consultationDate;
  final String? residentName;

  final int? medicineId;
  final int? quantityUsed;

  ConsultationModel({
    this.id,
    required this.residentId,
    required this.symptoms,
    required this.diagnosis,
    this.treatment,
    this.prescription,
    required this.consultationDate,
    this.medicineId,
    this.quantityUsed,
    this.residentName,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
    return ConsultationModel(
      id: json['id'],
      residentId: json['resident_id'],
      symptoms: json['symptoms'],
      diagnosis: json['diagnosis'],
      treatment: json['treatment'],
      prescription: json['prescription'],
      consultationDate: json['consultation_date'],
      medicineId: json['medicine_id'],
      quantityUsed: json['quantity_used'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "resident_id": residentId,
      "symptoms": symptoms,
      "diagnosis": diagnosis,
      "treatment": treatment,
      "prescription": prescription,
      "consultation_date": consultationDate,
      "medicine_id": medicineId,
      "quantity_used": quantityUsed,
    };
  }
}