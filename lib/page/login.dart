import 'package:flutter/material.dart';
import 'package:apkgawee1/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isCompany = false;
  bool isLoading = false;

  final TextEditingController companyIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showError('Email dan password wajib diisi');
      return;
    }

    if (isCompany && companyIdController.text.isEmpty) {
      _showError('Company ID wajib diisi');
      return;
    }

    setState(() => isLoading = true);

    try {
      ///LOGIN + VALIDASI ROLE
      final userCredential = await _authService.loginWithRoleCheck(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        isCompanyLogin: isCompany,
      );

      final uid = userCredential.user!.uid;

      //AMBIL DATA FIRESTORE (UNTUK COMPANY ID SAJA)
      if (isCompany) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (!doc.exists) {
          await FirebaseAuth.instance.signOut();
          throw 'Data company tidak ditemukan';
        }

        final companyIdFromDb = doc['companyId'];

        if (companyIdFromDb != companyIdController.text.trim()) {
          await FirebaseAuth.instance.signOut();
          throw 'Company ID tidak valid';
        }
      }

      if (!mounted) return;

      //NAVIGASI
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showError(e.toString().replaceAll('Exception:', '').trim());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }


  //ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EEFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _logo(),
              const SizedBox(height: 30),
              _tabs(),
              const SizedBox(height: 30),
              const Text(
                'Sign in to your registered account',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              if (isCompany) ...[
                _inputField(
                  hint: 'Company ID',
                  controller: companyIdController,
                ),
                const SizedBox(height: 16),
              ],

              _inputField(hint: 'Email', controller: emailController),
              const SizedBox(height: 16),
              _inputField(
                hint: 'Password',
                controller: passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 24),

              _loginButton(),
              const SizedBox(height: 24),

              if (!isCompany) _socialLogin(),
              const SizedBox(height: 24),

              if (!isCompany) _registerLink(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  //widget
  Widget _logo() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logogawee.png', height: 40),
          const SizedBox(width: 8),
          const Text(
            'Gawee',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8E3CF7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    return Row(
      children: [
        _tabItem(
          title: 'JOB SEEKER',
          active: !isCompany,
          onTap: () => setState(() => isCompany = false),
        ),
        _tabItem(
          title: 'COMPANY',
          active: isCompany,
          onTap: () => setState(() => isCompany = true),
        ),
      ],
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8E3CF7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isLoading ? null : _handleLogin,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          'LOGIN',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _socialLogin() {
    return const SizedBox();
  }

  Widget _registerLink() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/register'),
        child: const Text(
          "Don't have an account? Register",
          style: TextStyle(color: Color(0xFF8E3CF7)),
        ),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _tabItem({
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? const Color(0xFF8E3CF7) : Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 2,
              color: active ? const Color(0xFF8E3CF7) : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}