import 'package:flutter/material.dart';
import '../models/medicine_model.dart';
import '../services/api_service.dart';

class MedicinesScreen extends StatefulWidget {
  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen>
    with SingleTickerProviderStateMixin {

  List<MedicineModel> data = [];
  bool loading = true;
  String? role;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    loadUserAndData();
  }

  Future<void> loadUserAndData() async {
    final user = await ApiService.getUser();
    role = user?['role'];

    if (role != 'admin' && role != 'doctor') {
      setState(() {
        loading = false;
      });
      return;
    }

    await load();
  }

  Future<void> load() async {
    final res = await ApiService.getMedicines();

    setState(() {
      data = res;
      loading = false;
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Medicines Inventory"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())

          : (role != 'admin' && role != 'doctor')
          ? const Center(
        child: Text(
          "You are not allowed to view medicines",
          style: TextStyle(
            fontSize: 16,
            color: Colors.redAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      )

          : (data.isEmpty)
          ? const Center(
        child: Text(
          "No medicines found",
          style: TextStyle(fontSize: 16),
        ),
      )

          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (_, i) => animatedCard(data[i], i),
        ),
      ),
    );
  }

  Widget animatedCard(MedicineModel m, int index) {
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        (index / data.length).clamp(0.0, 1.0),
        ((index + 1) / data.length).clamp(0.0, 1.0),
        curve: Curves.easeOut,
      ),
    );

    Color stockColor;
    if (m.stockQuantity <= 5) {
      stockColor = Colors.red;
    } else if (m.stockQuantity <= 20) {
      stockColor = Colors.orange;
    } else {
      stockColor = Colors.green;
    }

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(animation),

        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),

          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),

            leading: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: stockColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.medication_outlined,
                color: stockColor,
              ),
            ),

            title: Text(
              m.medicineName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Unit: ${m.unit}",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),

            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: stockColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${m.stockQuantity}",
                style: TextStyle(
                  color: stockColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}