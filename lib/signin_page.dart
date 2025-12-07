import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  Future<String> get _filePath async {
  final dir = await getApplicationSupportDirectory();
  return '${dir.path}/sign_file.txt';
}

 Future<bool> checkValue(String user, String pass) async {
  final path = await _filePath;
  final file = File(path);
  if (!(await file.exists())) return false;

  final lines = await file.readAsLines();

  for (var line in lines) {
    final parts = line.split(',');
    if (parts.length >= 3) {
      final uname = parts[0].trim().replaceFirst('username_', '');
      final pword = parts[1].trim().replaceFirst('password_', '');
      if (uname == user && pword == pass) {
        return true;
      }
    }
  }
  return false;
}

  void signIn() async {
    final user = usernameCtrl.text.trim();
    final pass = passwordCtrl.text.trim();
    final result = await checkValue(user, pass);

    if (result) {
      Navigator.pushReplacementNamed(context, '/home',
          arguments: {'username': user});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('بيانات الدخول غير صحيحة'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'الاسم')),
            TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'كلمة السر'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: signIn, child: const Text('دخول')),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text('مستخدم جديد؟ سجل هنا'),
            )
          ],
        ),
      ),
    );
  }
}