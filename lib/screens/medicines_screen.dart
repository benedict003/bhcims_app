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

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    load();
  }

  Future<void> load() async {
    final res = await ApiService.getMedicines();

    setState(() {
      data = res;
      loading = false;
    });

    // start animation after data loads
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getStockColor(int stock) {
    if (stock <= 10) return Colors.red;
    if (stock <= 30) return Colors.orange;
    return Colors.green;
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

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animation),

        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [

                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(
                    Icons.medication,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        m.medicineName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Unit: ${m.unit}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getStockColor(m.stockQuantity).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: getStockColor(m.stockQuantity),
                    ),
                  ),
                  child: Text(
                    "Stock: ${m.stockQuantity}",
                    style: TextStyle(
                      color: getStockColor(m.stockQuantity),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          : Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, i) {
            return animatedCard(data[i], i);
          },
        ),
      ),
    );
  }
}