import 'package:flutter/material.dart';
import '../models/resident_model.dart';
import '../services/api_service.dart';

class ResidentsScreen extends StatefulWidget {
  @override
  State<ResidentsScreen> createState() => _ResidentsScreenState();
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