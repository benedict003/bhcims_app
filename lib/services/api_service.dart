import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/consultation_model.dart';
import '../models/medicine_model.dart';
import '../models/appointment_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // =========================
  // TOKEN HANDLING
  // =========================
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // =========================
  // HEADERS
  // =========================
  static Future<Map<String, String>> headers() async {
    final token = await getToken();

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // =========================
  // SAFE JSON PARSE
  // =========================
  static dynamic _safeDecode(http.Response response) {
    final body = response.body;

    // 🚨 Detect Laravel HTML error page
    if (body.trim().startsWith('<!DOCTYPE html>') ||
        body.contains('<html')) {
      throw Exception(
        'Server returned HTML error instead of JSON. '
            'Check Laravel logs or API route.',
      );
    }

    try {
      return jsonDecode(body);
    } catch (e) {
      throw Exception('Invalid JSON response: $body');
    }
  }

  // =========================
  // LOGIN
  // =========================
  static Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': email,
        'password': password,
      },
    );

    final data = _safeDecode(response);

    if (response.statusCode == 200 && data['token'] != null) {
      await saveToken(data['token']);
    }

    return data;
  }

  // =========================
  // LOGOUT
  // =========================
  static Future<void> logout() async {
    final token = await getToken();

    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    await clearToken();
  }

  // =========================
  // RESIDENTS
  // =========================
  static Future<List> getResidents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/residents'),
      headers: await headers(),
    );

    final data = _safeDecode(response);

    if (response.statusCode == 200) {
      return List.from(data);
    }

    throw Exception(data.toString());
  }

  // =========================
  // CONSULTATIONS
  // =========================
  static Future<List<AppointmentModel>> getAppointments() async {
    final res = await http.get(
      Uri.parse('$baseUrl/appointments'),
      headers: await headers(),
    );

    final data = _safeDecode(res);

    return List<AppointmentModel>.from(
      data.map((e) => AppointmentModel.fromJson(e)),
    );
  }

  static Future<List> getDoctors() async {
    final res = await http.get(
      Uri.parse("$baseUrl/doctors"),
      headers: await headers(), // 🔥 REQUIRED
    );

    print("DOCTORS STATUS: ${res.statusCode}");
    print("DOCTORS BODY: ${res.body}");

    final data = _safeDecode(res);

    return List.from(data);
  }

  static Future<Map<String, dynamic>> createAppointment(Map data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/appointments'),
      headers: await headers(),
      body: jsonEncode(data),
    );

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    final decoded = jsonDecode(res.body);

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception(decoded.toString());
    }

    return decoded;
  }

  static Future createConsultation(Map data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/consultations'),
      headers: await headers(),
      body: jsonEncode(data),
    );

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    if (res.body.trim().startsWith('<')) {
      throw Exception("Laravel returned HTML error");
    }

    try {
      return jsonDecode(res.body);
    } catch (e) {
      throw Exception("Invalid JSON: ${res.body}");
    }
  }

  static Future deleteConsultation(int id) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/consultations/$id"),
      headers: await headers(),
    );

    return jsonDecode(res.body);
  }
  static Future<List<ConsultationModel>> getConsultationsAll() async {
    final res = await http.get(
      Uri.parse('$baseUrl/consultations'),
      headers: await headers(),
    );

    final data = jsonDecode(res.body);

    return List<ConsultationModel>.from(
      data.map((e) => ConsultationModel.fromJson(e)),
    );
  }

  static Future<List<ConsultationModel>> getConsultations(int residentId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/consultations?resident_id=$residentId'),
      headers: await headers(),
    );

    final decoded = jsonDecode(res.body);

    // 👇 SAFE extraction
    final list = (decoded is List)
        ? decoded
        : decoded['data'] ?? decoded['consultations'] ?? [];

    return List<ConsultationModel>.from(
      list.map((e) => ConsultationModel.fromJson(e)),
    );
  }

  static Future<List<AppointmentModel>> getAppointmentsByUser(int id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/appointments?resident_id=$id'),
      headers: await headers(),
    );

    final data = jsonDecode(res.body);

    return List<AppointmentModel>.from(
      data.map((e) => AppointmentModel.fromJson(e)),
    );
  }

  static Future<List<ConsultationModel>> getConsultationsByUser(int id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/consultations?resident_id=$id'),
      headers: await headers(),
    );

    final data = jsonDecode(res.body);

    return List<ConsultationModel>.from(
      data.map((e) => ConsultationModel.fromJson(e)),
    );
  }
  // =========================
  // MEDICINES
  // =========================
  static Future<List<MedicineModel>> getMedicines() async {
    final response = await http.get(
      Uri.parse('$baseUrl/medicines'),
      headers: await headers(),
    );

    final data = _safeDecode(response);

    return List<MedicineModel>.from(
      data.map((e) => MedicineModel.fromJson(e)),
    );
  }



  // =========================
  // REPORTS
  // =========================
  static Future<List> getReports() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reports'),
      headers: await headers(),
    );

    final data = _safeDecode(response);

    return List.from(data);
  }
// reports create
  static Future createReport(Map data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/reports'),
      headers: await headers(),
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);
  }

// reports update
  static Future updateReport(int id, Map data) async {
    final res = await http.put(
      Uri.parse('$baseUrl/reports/$id'),
      headers: await headers(),
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);
  }
// reports delete
  static Future deleteReport(int id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/reports/$id'),
      headers: await headers(),
    );

    return jsonDecode(res.body);
  }

  // =========================
  // DASHBOARD
  // =========================
  static Future<Map<String, dynamic>> getStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/stats'),
      headers: await headers(),
    );

    final data = _safeDecode(response);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(data.toString());
  }

  // =========================
  // REGISTER
  // =========================
  static Future<Map<String, dynamic>> register(
      String name,
      String email,
      String password,
      ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    return jsonDecode(res.body);
  }

}