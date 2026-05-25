import 'package:flutter/material.dart';
import '../models/medicine_model.dart';
import '../services/api_service.dart';

class MedicinesScreen extends StatefulWidget {
  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  List<MedicineModel> data = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final res = await ApiService.getMedicines();

    setState(() {
      data = res; // ✅ already List<MedicineModel>
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medicines")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) {
          final m = data[i];
          return ListTile(
            title: Text(m.medicineName),
            subtitle: Text("Stock: ${m.stockQuantity}"),
            trailing: Text(m.unit),
          );
        },
      ),
    );
  }
}