import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserAppointment extends StatefulWidget {
  final Map user;

  const UserAppointment({super.key, required this.user});

  @override
  State<UserAppointment> createState() => _UserAppointmentState();
}

class _UserAppointmentState extends State<UserAppointment> {
  final purpose = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();

  List doctors = [];
  int? selectedDoctor;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    final res = await ApiService.getDoctors();
    setState(() {
      doctors = res;
    });
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      date.text =
      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      time.text =
      "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00";
    }
  }

  Future<void> submit() async {
    setState(() => loading = true);

    try {
      await ApiService.createAppointment({
        "resident_id": widget.user['id'],
        "doctor_id": selectedDoctor,
        "purpose": purpose.text,
        "appointment_date": date.text,
        "appointment_time": time.text,
      });

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Appointment submitted")),
      );

      purpose.clear();
      date.clear();
      time.clear();
      selectedDoctor = null;

    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment")),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            // ================= DOCTOR DROPDOWN =================
            DropdownButtonFormField<int>(
              value: selectedDoctor,
              decoration: InputDecoration(
                labelText: "Select Doctor",
                border: OutlineInputBorder(),
              ),
              items: doctors.map<DropdownMenuItem<int>>((d) {
                return DropdownMenuItem(
                  value: d['id'],
                  child: Text(d['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDoctor = value;
                });
              },
            ),

            SizedBox(height: 10),

            TextField(
              controller: purpose,
              decoration: InputDecoration(labelText: "Purpose"),
            ),

            TextField(
              controller: date,
              readOnly: true,
              onTap: pickDate,
              decoration: InputDecoration(
                labelText: "Date",
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),

            TextField(
              controller: time,
              readOnly: true,
              onTap: pickTime,
              decoration: InputDecoration(
                labelText: "Time",
                suffixIcon: Icon(Icons.access_time),
              ),
            ),

            SizedBox(height: 20),

            loading
                ? CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submit,
                child: Text("Submit Appointment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}