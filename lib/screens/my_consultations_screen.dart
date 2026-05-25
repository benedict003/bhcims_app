import 'package:flutter/material.dart';
import '../models/consultation_model.dart';
import '../services/api_service.dart';

class MyConsultationsScreen extends StatefulWidget {
  final Map user;

  const MyConsultationsScreen({super.key, required this.user});

  @override
  State<MyConsultationsScreen> createState() => _MyConsultationsScreenState();
}

class _MyConsultationsScreenState extends State<MyConsultationsScreen> {
  List<ConsultationModel> consultations = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      consultations =
      await ApiService.getConsultations(widget.user['id']);
    } catch (e) {
      debugPrint("Error loading consultations: $e");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Consultations")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : consultations.isEmpty
          ? const Center(child: Text("No consultations found"))
          : ListView.builder(
        itemCount: consultations.length,
        itemBuilder: (_, i) {
          final c = consultations[i];

          return Card(
            child: ListTile(
              title: Text(c.diagnosis),
              subtitle: Text(c.symptoms),
              trailing: Text(c.consultationDate),
            ),
          );
        },
      ),
    );
  }
}