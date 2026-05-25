class MedicineModel {
  final int id;
  final String medicineName;
  final int stockQuantity;
  final String expirationDate;
  final String unit;

  MedicineModel({
    required this.id,
    required this.medicineName,
    required this.stockQuantity,
    required this.expirationDate,
    required this.unit,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      medicineName: json['medicine_name'] ?? '',
      stockQuantity: json['stock_quantity'] ?? 0,
      expirationDate: json['expiration_date'] ?? '',
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicine_name': medicineName,
      'stock_quantity': stockQuantity,
      'expiration_date': expirationDate,
      'unit': unit,
    };
  }
}
