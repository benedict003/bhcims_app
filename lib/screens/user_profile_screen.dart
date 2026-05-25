import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserProfileScreen extends StatefulWidget {
  final Map user;

  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
  final gender = TextEditingController();
  final birthDate = TextEditingController();
  final contactNumber = TextEditingController();
  final address = TextEditingController();
  final bloodType = TextEditingController();
  final civilStatus = TextEditingController();

  @override
  void initState() {
    super.initState();

    firstName.text = widget.user['resident']['first_name'] ?? '';
    middleName.text = widget.user['resident']['middle_name'] ?? '';
    lastName.text = widget.user['resident']['last_name'] ?? '';
    gender.text = widget.user['resident']['gender'] ?? '';
    birthDate.text = widget.user['resident']['birth_date'] ?? '';
    contactNumber.text = widget.user['resident']['contact_number'] ?? '';
    address.text = widget.user['resident']['address'] ?? '';
    bloodType.text = widget.user['resident']['blood_type'] ?? '';
    civilStatus.text = widget.user['resident']['civil_status'] ?? '';
  }

  Future<void> updateProfile() async {
    await ApiService.updateResident({
      "first_name": firstName.text,
      "middle_name": middleName.text,
      "last_name": lastName.text,
      "gender": gender.text,
      "birth_date": birthDate.text,
      "contact_number": contactNumber.text,
      "address": address.text,
      "blood_type": bloodType.text,
      "civil_status": civilStatus.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            _field("First Name", firstName),
            _field("Middle Name", middleName),
            _field("Last Name", lastName),
            _field("Gender", gender),
            _field("Birth Date", birthDate),
            _field("Contact Number", contactNumber),
            _field("Address", address),
            _field("Blood Type", bloodType),
            _field("Civil Status", civilStatus),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: updateProfile,
              child: Text("Save Changes"),
            )
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}