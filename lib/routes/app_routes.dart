import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/residents_screen.dart';
import '../screens/appointments_screen.dart';
import '../screens/consultations_screen.dart';
import '../screens/medicines_screen.dart';
import '../screens/reports_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const residents = '/residents';
  static const appointments = '/appointments';
  static const consultations = '/consultations';
  static const medicines = '/medicines';
  static const reports = '/reports';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),

    dashboard: (context) => DashboardScreen(
      user: ModalRoute.of(context)!.settings.arguments as Map,
    ),

    residents: (context) => ResidentsScreen(),

    appointments: (context) {
      final user = ModalRoute.of(context)!.settings.arguments as Map;
      return AppointmentsScreen(user: user);
    },

    consultations: (context) {
      final user = ModalRoute.of(context)!.settings.arguments as Map;
      return ConsultationsScreen(user: user);
    },
    medicines: (context) => MedicinesScreen(),

    reports: (context) {
      final user = ModalRoute
          .of(context)!
          .settings
          .arguments as Map;
      return ReportsScreen(user: user);
    },
  };
}