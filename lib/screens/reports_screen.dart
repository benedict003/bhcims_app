import 'package:flutter/material.dart';
import '../models/consultation_model.dart';
import '../models/appointment_model.dart';
import '../services/api_service.dart';

class ReportsScreen extends StatefulWidget {

  final Map user;

  const ReportsScreen({super.key, required this.user});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool loading = true;

  List<AppointmentModel> appointments = [];
  List<ConsultationModel> consultations = [];

  String selectedReport = "menu"; // menu | appointments | consultations

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      if (widget.user['role'] == 'admin') {
        appointments = await ApiService.getAppointments();
        consultations = await ApiService.getConsultationsAll();
      } else {
        appointments =
        await ApiService.getAppointmentsByUser(widget.user['id']);

        consultations =
        await ApiService.getConsultations(widget.user['id']);
      }
    } catch (e) {
      debugPrint("Error loading reports: $e");
    }

    setState(() => loading = false);
  }

  void openAppointmentsReport() {
    setState(() => selectedReport = "appointments");
  }

  void openConsultationsReport() {
    setState(() => selectedReport = "consultations");
  }

  void backToMenu() {
    setState(() => selectedReport = "menu");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
        leading: selectedReport == "menu"
            ? null
            : IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: backToMenu,
        ),
      ),

      body: loading
          ? Center(child: CircularProgressIndicator())

      // ================= MENU =================
          : selectedReport == "menu"
          ? Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            reportCard(
              icon: Icons.calendar_month,
              title: "Appointments Report",
              subtitle: "View all appointments (resident, doctor, date)",
              onTap: openAppointmentsReport,
            ),
            SizedBox(height: 12),
            reportCard(
              icon: Icons.medical_services,
              title: "Consultations Report",
              subtitle: "View consultation records and treatments",
              onTap: openConsultationsReport,
            ),
          ],
        ),
      )

      // ================= APPOINTMENTS TABLE =================
          : selectedReport == "appointments"
          ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Resident")),
            DataColumn(label: Text("Doctor")),
            DataColumn(label: Text("Date")),
            DataColumn(label: Text("Purpose")),
          ],
          rows: appointments.map((a) {
            return DataRow(cells: [
              DataCell(Text(a.residentName ?? "")),
              DataCell(Text(a.doctorName ?? "")),
              DataCell(Text(a.appointmentDate ?? "")),
              DataCell(Text(a.purpose ?? "")),
            ]);
          }).toList(),
        ),
      )

      // ================= CONSULTATIONS TABLE =================
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Resident")),
            DataColumn(label: Text("Symptoms")),
            DataColumn(label: Text("Diagnosis")),
            DataColumn(label: Text("Treatment")),
            DataColumn(label: Text("Date")),
          ],
          rows: consultations.map((c) {
            return DataRow(cells: [
              DataCell(Text(c.residentName ?? "Unknown")),
              DataCell(Text(c.symptoms)),
              DataCell(Text(c.diagnosis)),
              DataCell(Text(c.treatment ?? "")),
              DataCell(Text(c.consultationDate)),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  // ================= REPORT CARD =================
  Widget reportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 35),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}