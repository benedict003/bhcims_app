import 'package:flutter/material.dart';
import '../models/resident_model.dart';
import '../services/api_service.dart';

class ResidentsScreen extends StatefulWidget {
  @override
  State<ResidentsScreen> createState() => _ResidentsScreenState();
}

Widget residentCard(ResidentModel r) {
  String initials =
  "${r.firstName.isNotEmpty ? r.firstName[0] : ''}"
      "${r.lastName.isNotEmpty ? r.lastName[0] : ''}"
      .toUpperCase();

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${r.firstName} ${r.lastName}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                r.address,
                style: TextStyle(color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    ),
  );
}

class _ResidentsScreenState extends State<ResidentsScreen> {
  List<ResidentModel> data = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final res = await ApiService.getResidents();

    setState(() {
      data = res.map<ResidentModel>((e) => ResidentModel.fromJson(e)).toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Residents")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) {
          final r = data[i];
          return ListTile(
            title: Text("${r.firstName} ${r.lastName}"),
            subtitle: Text(r.address),
          );
        },
      ),
    );
  }
}