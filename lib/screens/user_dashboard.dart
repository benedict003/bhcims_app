import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'user_appointment.dart';
import 'login_screen.dart';
import 'appointments_screen.dart';
import 'my_consultations_screen.dart';

class UserDashboard extends StatelessWidget {
  final Map user;

  const UserDashboard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resident Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ApiService.logout();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
                    (route) => false,
              );
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Welcome, ${user['name'] ?? ''}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Resident Account",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // BOOK APPOINTMENT
            _card(
              context,
              "Book Appointment",
              Icons.calendar_month,
              UserAppointment(user: user),
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppointmentsScreen(user: user),
                  ),
                );
              },
              child: _infoCard(
                "My Appointments",
                "View your scheduled visits",
                Icons.event_note,
              ),
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyConsultationsScreen(user: user),
                  ),
                );
              },
              child: _infoCard(
                "My Consultations",
                "Medical records & diagnosis history",
                Icons.medical_services,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
      BuildContext context,
      String title,
      IconData icon,
      Widget page,
      ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blue.shade100,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 35,
              color: Colors.blue,
            ),

            const SizedBox(width: 15),

            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
      String title,
      String subtitle,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),

          const SizedBox(width: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}