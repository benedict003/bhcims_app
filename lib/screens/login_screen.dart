import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';
import 'user_dashboard.dart';
import 'resident_register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  login() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await ApiService.login(
        emailController.text,
        passwordController.text,
      );

      setState(() {
        loading = false;
      });

      if (response['token'] != null) {
        await ApiService.saveToken(response['token']);

        final user = response['user'];
        final role = user['role'];

        Widget nextPage;

        // ================= ROLE ROUTING =================
        if (role == 'admin') {
          nextPage = DashboardScreen(user: user);
        } else if (role == 'doctor' || role == 'nurse') {
          nextPage = DashboardScreen(user: user);
        } else {
          nextPage = UserDashboard(user: user); // RESIDENT
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => nextPage),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Login failed"),
          ),
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
//INPUT STYLE
  InputDecoration inputStyle(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,

      prefixIcon: Icon(
        icon,
        color: Colors.blue.shade400,
      ),

      filled: true,
      fillColor: Colors.white,

      labelStyle: TextStyle(
        color: Colors.blue.shade400,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.blue.shade100,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.blue.shade300,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('BHCIMS Login'),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [

            SizedBox(height: 40),

            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.local_hospital,
                size: 45,
                color: Colors.blue.shade400,
              ),
            ),

            SizedBox(height: 20),

            Text(
              "BHCIMS",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade400,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Barangay Health Center Information Management System",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),

            SizedBox(height: 35),

            // ================= EMAIL =================
            TextField(
              controller: emailController,
              decoration: inputStyle(
                'Email',
                Icons.email_outlined,
              ),
            ),

            SizedBox(height: 20),

            // ================= PASSWORD =================
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: inputStyle(
                'Password',
                Icons.lock_outline,
              ),
            ),

            SizedBox(height: 30),

            // ================= LOGIN BUTTON =================
            loading
                ? CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade400,
                  foregroundColor: Colors.white,

                  padding: EdgeInsets.symmetric(vertical: 14),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: login,
                child: Text('LOGIN'),
              ),
            ),

            SizedBox(height: 10),

            // ================= REGISTER BUTTON =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue.shade400,

                  side: BorderSide(
                    color: Colors.blue.shade200,
                  ),

                  padding: EdgeInsets.symmetric(vertical: 14),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResidentRegisterScreen(),
                    ),
                  );
                },
                child: Text("CREATE ACCOUNT"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}