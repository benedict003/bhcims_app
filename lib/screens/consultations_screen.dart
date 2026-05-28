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

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> create() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date")),
      );
      return;
    }

    final model = ConsultationModel(
      residentId: widget.user['id'],
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

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consultations"),
        centerTitle: true,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= FORM CARD =================
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      const Text(
                        "New Consultation",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextField(
                        controller: symptoms,
                        decoration: _inputStyle("Symptoms", Icons.sick),
                      ),
                      const SizedBox(height: 10),

                      TextField(
                        controller: diagnosis,
                        decoration: _inputStyle("Diagnosis", Icons.healing),
                      ),
                      const SizedBox(height: 10),

                      TextField(
                        controller: treatment,
                        decoration: _inputStyle("Treatment", Icons.medical_services),
                      ),
                      const SizedBox(height: 10),

                      TextField(
                        controller: prescription,
                        decoration: _inputStyle("Prescription", Icons.receipt),
                      ),
                      const SizedBox(height: 10),

                      // DATE PICKER
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[100],
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.calendar_month),
                          title: Text(
                            selectedDate == null
                                ? "Select Consultation Date"
                                : selectedDate!.toLocal().toString().split(' ')[0],
                          ),
                          trailing: const Icon(Icons.arrow_drop_down),
                          onTap: pickDate,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // MEDICINE DROPDOWN
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButton<int>(
                          value: selectedMedicine,
                          hint: const Text("Select Medicine"),
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: medicines.map((m) {
                            return DropdownMenuItem(
                              value: m.id,
                              child: Text(m.medicineName),
                            );
                          }).toList(),
                          onChanged: (v) =>
                              setState(() => selectedMedicine = v),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: quantity,
                        keyboardType: TextInputType.number,
                        decoration:
                        _inputStyle("Quantity", Icons.numbers),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: create,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Save Consultation"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // ================= LIST =================
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: consultations.length,
                itemBuilder: (_, i) {
                  final c = consultations[i];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.medical_information),
                      ),
                      title: Text(
                        c.diagnosis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Symptoms: ${c.symptoms}\nDate: ${c.consultationDate}",
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}