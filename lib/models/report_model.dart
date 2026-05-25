class ReportModel {
  final int id;
  final String reportName;
  final String generatedDate;

  ReportModel({
    required this.id,
    required this.reportName,
    required this.generatedDate,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      reportName: json['report_name'] ?? '',
      generatedDate: json['generated_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'report_name': reportName,
      'generated_date': generatedDate,
    };
  }
}
