import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ResidentRegisterScreen extends StatefulWidget {
  @override
  State<ResidentRegisterScreen> createState() => _ResidentRegisterScreenState();
}

class _ResidentRegisterScreenState extends State<ResidentRegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    setState(() => loading = true);

    final res = await ApiService.register(
      name.text,
      email.text,
      password.text,
    );

    setState(() => loading = false);

    if (res['user'] != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? "Error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Resident Registration")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: name, decoration: InputDecoration(labelText: "Full Name")),
            TextField(controller: email, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: password, obscureText: true, decoration: InputDecoration(labelText: "Password")),

            SizedBox(height: 20),

            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: register,
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}