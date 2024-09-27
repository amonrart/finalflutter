import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'signup_screen.dart'; // Import SignupScreen
import 'package:firebase_auth/firebase_auth.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // ตัวแปรเก็บสถานะว่ากำลังเข้าสู่ระบบอยู่หรือไม่
  String _errorMessage = ''; // ข้อความแสดงข้อผิดพลาด

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: Offset(0.1, 1),
                    blurRadius: 0.1,
                    spreadRadius: 0.1,
                    color: Colors.black)
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "TODO",
                style: TextStyle(fontSize: 40),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: "Email", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(
                height: 10,
              ),
              _isLoading
                  ? const CircularProgressIndicator() // แสดงขณะกำลังโหลด
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              // Navigate to SignupScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupScreen()),
                              );
                            },
                            child: const Text("Sign up")),
                        TextButton(
                            onPressed: () async {
                              // เริ่มกระบวนการเข้าสู่ระบบ
                              setState(() {
                                _isLoading = true;
                                _errorMessage = '';
                              });

                              try {
                                // ดำเนินการ signin
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                // ถ้าเข้าสู่ระบบสำเร็จ ให้ไปยังหน้า ExpenseTrackerScreen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ExpenseTrackerScreen()),
                                );
                              } on FirebaseAuthException catch (e) {
                                // จัดการข้อผิดพลาดของ FirebaseAuth
                                setState(() {
                                  _errorMessage = e.message ?? 'Sign in failed';
                                });
                              } catch (e) {
                                // จัดการข้อผิดพลาดทั่วไป
                                setState(() {
                                  _errorMessage =
                                      'An unexpected error occurred';
                                });
                              } finally {
                                // หยุดการโหลดไม่ว่าผลลัพธ์จะสำเร็จหรือล้มเหลว
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            child: const Text("Sign in")),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
