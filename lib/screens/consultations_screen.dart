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

  // 🎨 INPUT STYLE (BLUE THEME)
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue),
      labelStyle: const TextStyle(color: Colors.blue),

      filled: true,
      fillColor: Colors.white, // ✅ WHITE INSIDE BOX

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        title: const Text("Consultations"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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

              // 💙 FORM CARD
              Card(
                elevation: 4,
                color: Colors.blue.shade50,
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
                          color: Colors.blue,
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
                        decoration:
                        _inputStyle("Treatment", Icons.medical_services),
                      ),
                      const SizedBox(height: 10),

                      TextField(
                        controller: prescription,
                        decoration:
                        _inputStyle("Prescription", Icons.receipt),
                      ),
                      const SizedBox(height: 10),

                      // 📅 DATE PICKER
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // ✅ WHITE INSIDE
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.calendar_month, color: Colors.blue),
                          title: Text(
                            selectedDate == null
                                ? "Select Consultation Date"
                                : selectedDate!.toLocal().toString().split(' ')[0],
                            style: const TextStyle(color: Colors.blue),
                          ),
                          trailing: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                          onTap: pickDate,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 💊 MEDICINE DROPDOWN
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white, // ✅ WHITE INSIDE
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: DropdownButton<int>(
                          value: selectedMedicine,
                          hint: const Text("Select Medicine"),
                          isExpanded: true,
                          underline: const SizedBox(),
                          //ITEMS-SECTION
                          items: medicines.map((m) {
                            return DropdownMenuItem(
                              value: m.id,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  // 💊 Medicine name
                                  Expanded(
                                    child: Text(
                                      m.medicineName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  // 📦 Stock indicator
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (m.stockQuantity <= 10)
                                          ? Colors.red.shade100
                                          : Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Stock: ${m.stockQuantity}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: (m.stockQuantity <= 10)
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (v) => setState(() => selectedMedicine = v),
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
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
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

              // 💛 HISTORY TITLE
              Text(
                "History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade800,
                ),
              ),

              const SizedBox(height: 10),

              // 📋 LIST
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: consultations.length,
                itemBuilder: (_, i) {
                  final c = consultations[i];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.medical_information,
                          color: Colors.blue,
                        ),
                      ),
                      title: Text(
                        c.diagnosis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
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