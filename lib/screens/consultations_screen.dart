import 'package:flutter/material.dart';
import '../models/consultation_model.dart';
import '../models/medicine_model.dart';
import '../services/api_service.dart';

class ConsultationsScreen extends StatefulWidget {
  final Map user;

  const ConsultationsScreen({super.key, required this.user});
  @override
  State<ConsultationsScreen> createState() => _ConsultationsScreenState();
}

class _ConsultationsScreenState extends State<ConsultationsScreen> {
  List<ConsultationModel> consultations = [];
  List<MedicineModel> medicines = [];

  int? selectedMedicine;
  DateTime? selectedDate;

  bool loading = true;

  final symptoms = TextEditingController();
  final diagnosis = TextEditingController();
  final treatment = TextEditingController();
  final prescription = TextEditingController();
  final quantity = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      consultations = await ApiService.getConsultations(widget.user['id']);
      medicines = await ApiService.getMedicines();
    } catch (e) {
      debugPrint("Error loading data: $e");
    }

    setState(() => loading = false);
  }

  // ================= DATE PICKER =================
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // ================= CREATE =================
  Future<void> create() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a date")),
      );
      return;
    }

    final model = ConsultationModel(
      residentId: 1,
      symptoms: symptoms.text,
      diagnosis: diagnosis.text,
      treatment: treatment.text,
      prescription: prescription.text,
      consultationDate: selectedDate!.toIso8601String().split('T')[0],
      medicineId: selectedMedicine,
      quantityUsed: int.tryParse(quantity.text),
    );

    await ApiService.createConsultation(model.toJson());

    clearForm();
    load();
  }

  void clearForm() {
    symptoms.clear();
    diagnosis.clear();
    treatment.clear();
    prescription.clear();
    quantity.clear();

    setState(() {
      selectedMedicine = null;
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Consultations")),

      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // ================= FORM =================
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: symptoms,
                  decoration: InputDecoration(labelText: "Symptoms"),
                ),
                TextField(
                  controller: diagnosis,
                  decoration: InputDecoration(labelText: "Diagnosis"),
                ),

                TextField(
                  controller: treatment,
                  decoration: InputDecoration(labelText: "Treatment"),
                ),

                TextField(
                  controller: prescription,
                  decoration: InputDecoration(labelText: "Prescription"),
                ),

                // ================= DATE PICKER UI =================
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    selectedDate == null
                        ? "Select Date"
                        : selectedDate!.toLocal().toString().split(' ')[0],
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: pickDate,
                ),

                DropdownButton<int>(
                  value: selectedMedicine,
                  hint: Text("Select Medicine"),
                  isExpanded: true,
                  items: medicines.map((m) {
                    return DropdownMenuItem(
                      value: m.id,
                      child: Text(m.medicineName),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => selectedMedicine = v),
                ),

                TextField(
                  controller: quantity,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Quantity"),
                ),

                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: create,
                  child: Text("Save Consultation"),
                ),
              ],
            ),
          ),

          Divider(),

          // ================= LIST =================
          Expanded(
            child: ListView.builder(
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
          ),
        ],
      ),
    );
  }
}