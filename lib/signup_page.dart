import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController deptCtrl = TextEditingController();


  Future<void> save(String user, String pass, String dept) async {
  try {
    final dir = await getApplicationSupportDirectory();
    print('📁 Folder Path: ${dir.path}');
    final file = File('${dir.path}/sign_file.txt');

    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }

    await file.writeAsString(
      'username_$user,password_$pass,department_$dept\n',
      mode: FileMode.append,
    );

    print('✅ Data saved for user: $user');
  } catch (e, st) {
    print('❌ Error saving data: $e');
    print(st);
  }
}
  void signUp() async {
    final user = usernameCtrl.text.trim();
    final pass = passwordCtrl.text.trim();
    final dept = deptCtrl.text.trim();

    if (user.isEmpty || pass.isEmpty || dept.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('املأ جميع الحقول')));
      return;
    }

    await save(user, pass, dept);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('تم التسجيل بنجاح')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل مستخدم جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'الاسم')),
            TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'كلمة السر')),
            TextField(controller: deptCtrl, decoration: const InputDecoration(labelText: 'التخصص')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: signUp, child: const Text('تسجيل'))
          ],
        ),
      ),
    );
  }
}