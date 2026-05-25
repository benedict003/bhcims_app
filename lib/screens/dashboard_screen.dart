import 'package:flutter/material.dart';
import '../services/api_service.dart';

import 'residents_screen.dart';
import 'appointments_screen.dart';
import 'consultations_screen.dart';
import 'medicines_screen.dart';
import 'reports_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Map user;

  DashboardScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    String role = user['role'];

    return Scaffold(
      appBar: AppBar(
        title: Text('BHCIMS Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await ApiService.logout();

              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                    (route) => false,
              );
            },
          )
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user['name']}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 5),

            Text(
              'Role: ${role.toUpperCase()}',
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: role == 'admin'
                    ? _adminCards(context)
                    : _staffCards(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ADMIN =================
  List<Widget> _adminCards(BuildContext context) {
    return [
      _card(context, 'Residents', Icons.people, ResidentsScreen()),
      _card(context, 'Appointments', Icons.calendar_today,
          AppointmentsScreen(user: user)),
      _card(context, 'Consultations', Icons.medical_services,
          ConsultationsScreen(user: user)),
      _card(context, 'Medicines', Icons.medication, MedicinesScreen()),
      _card(context, 'Reports', Icons.bar_chart,
              ReportsScreen(user: user)),
    ];
  }

  // ================= STAFF =================
  List<Widget> _staffCards(BuildContext context) {
    return [
      _card(context, 'Appointments', Icons.calendar_today,
          AppointmentsScreen(user: user)),
      _card(context, 'Consultations', Icons.medical_services,
          ConsultationsScreen(user: user)),
      _card(context, 'Medicines', Icons.medication, MedicinesScreen()),
    ];
  }

  // ================= CARD WIDGET =================
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
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}