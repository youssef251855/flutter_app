import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  void login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      User? user = await authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (user != null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'لم يتم العثور على مستخدم بهذا البريد الإلكتروني.';
          break;
        case 'wrong-password':
          message = 'كلمة المرور التي أدخلتها غير صحيحة.';
          break;
        case 'invalid-email':
          message = 'صيغة البريد الإلكتروني غير صحيحة.';
          break;
        case 'invalid-credential':
          message = 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
          break;
        default:
          message = 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
      }
      setState(() {
        errorMessage = message;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void register() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      User? user = await authService.registerWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (user != null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'هذا البريد الإلكتروني مستخدم بالفعل.';
          break;
        case 'weak-password':
          message = 'كلمة المرور ضعيفة جدًا (يجب أن تكون 6 أحرف على الأقل).';
          break;
        case 'invalid-email':
          message = 'صيغة البريد الإلكتروني غير صحيحة.';
          break;
        default:
          message = 'حدث خطأ أثناء إنشاء الحساب. يرجى المحاولة مرة أخرى.';
      }
      setState(() {
        errorMessage = message;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/download.jpg', // Make sure you have this image in the assets/images folder
                  height: 150,
                ),
                const SizedBox(height: 24),
                Text(
                  'أهلاً بك في طعم الشام',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 24),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 8),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: login,
                        child: const Text('تسجيل الدخول'),
                      ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: register,
                  child: const Text('إنشاء حساب جديد'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
