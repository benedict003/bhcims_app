import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/api_service.dart';

class AppointmentsScreen extends StatefulWidget {

  final Map user;

  const AppointmentsScreen({super.key, required this.user});
  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<AppointmentModel> appointments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final res = await ApiService.getAppointments();

      if (!mounted) return;

      setState(() {
        appointments = res;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Appointments")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (_, i) {
            final a = appointments[i];

            return ListTile(
              title: Text(a.residentName),
              subtitle: Text(a.purpose),
            );
          },

      ),
    );
  }
}