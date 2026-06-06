import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wissme/Authentication/login_auth.dart';
import 'package:wissme/validation.dart';
import '../DataBase Work/insert_data.dart';

class RegisterAuth extends StatefulWidget {
  const RegisterAuth({super.key});

  @override
  State<RegisterAuth> createState() => _Registration();
}

class _Registration extends State<RegisterAuth> {
  bool _isObscure = true;
  bool _isObscure1 = true;
  bool _isLoading = false;

  String type = "none";

  final formKey = GlobalKey<FormState>();
  final firstController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final enrollController = TextEditingController();
  final organizationController = TextEditingController();
  final passwordController = TextEditingController();
  final cPasswordController = TextEditingController();

  @override
  void dispose() {
    firstController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    enrollController.dispose();
    organizationController.dispose();
    passwordController.dispose();
    cPasswordController.dispose();
    super.dispose();
  }

  // Reusable input decoration
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFADB5BD), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
      errorStyle: const TextStyle(fontSize: 12, color: Color(0xFFEF4444)),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
        letterSpacing: 0.1,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          obscureText: obscure,
          style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A2E)),
          validator: validator,
          decoration: _inputDecoration(hint: hint, icon: icon, suffix: suffix),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildBackButton(),
                  const SizedBox(height: 32),
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildSignUpForm(),
                  const SizedBox(height: 24),
                  _buildSignUpButton(),
                  const SizedBox(height: 20),
                  _buildLoginLink(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: const Icon(
            Icons.person_add_alt_1_rounded,
            color: Color(0xFF1A73E8),
            size: 24,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Create account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Fill in the details below to get started.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First & Last name side by side
          Row(
            children: [
              Expanded(
                child: _buildField(
                  controller: firstController,
                  label: 'First name',
                  hint: 'First name',
                  icon: Icons.person_outline_rounded,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (!val.isValidName) return 'Invalid name';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildField(
                  controller: lastnameController,
                  label: 'Last name',
                  hint: 'Last name',
                  icon: Icons.person_outline_rounded,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (!val.isValidName) return 'Invalid name';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildField(
            controller: emailController,
            label: 'Email address',
            hint: 'you@example.com',
            icon: Icons.mail_outline_rounded,
            keyboard: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Please enter your email';
              if (!val.isValidEmail) return 'Please enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildField(
            controller: mobileController,
            label: 'Mobile number',
            hint: '+91 00000 00000',
            icon: Icons.phone_outlined,
            keyboard: TextInputType.phone,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Please enter mobile number';
              if (!val.isValidPhone) return 'Please enter a valid number';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // User type dropdown
          _buildLabel('User type'),
          const SizedBox(height: 8),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.badge_outlined, color: Color(0xFF9CA3AF), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: type,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1A1A2E),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "none",
                          child: Text(
                            'Select user type',
                            style: TextStyle(color: Color(0xFFADB5BD), fontSize: 14),
                          ),
                        ),
                        DropdownMenuItem(value: "Student", child: Text('Student')),
                        DropdownMenuItem(value: "Teacher", child: Text('Teacher')),
                      ],
                      onChanged: (value) => setState(() => type = value!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _buildField(
            controller: enrollController,
            label: 'Unique ID',
            hint: 'Enter your enrollment / ID',
            icon: Icons.badge_outlined,
            keyboard: TextInputType.number,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Please enter unique ID';
              if (!val.isValidUniqueId) return 'Please enter a valid ID';
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildField(
            controller: organizationController,
            label: 'Organization',
            hint: 'School / college name',
            icon: Icons.business_outlined,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Please enter organization';
              if (!val.isValidOrgName) return 'Please enter a valid name';
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildField(
            controller: passwordController,
            label: 'Password',
            hint: 'Create a password',
            icon: Icons.lock_outline_rounded,
            obscure: _isObscure,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Please enter a password';
              if (!val.isValidPassword) return 'Password must be at least 6 characters';
              return null;
            },
            suffix: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF9CA3AF),
                size: 20,
              ),
              onPressed: () => setState(() => _isObscure = !_isObscure),
            ),
          ),
          const SizedBox(height: 16),

          _buildField(
            controller: cPasswordController,
            label: 'Confirm password',
            hint: 'Re-enter your password',
            icon: Icons.lock_outline_rounded,
            obscure: _isObscure1,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Please confirm your password';
              if (val != passwordController.text) return 'Passwords do not match';
              return null;
            },
            suffix: IconButton(
              icon: Icon(
                _isObscure1 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF9CA3AF),
                size: 20,
              ),
              onPressed: () => setState(() => _isObscure1 = !_isObscure1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A73E8),
          disabledBackgroundColor: const Color(0xFF93C5FD),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Text(
          'Create account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Already have an account?',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Sign in',
              style: TextStyle(
                color: Color(0xFF1A73E8),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSignUp() {
    if (formKey.currentState!.validate()) {
      if (type == "none") {
        _showSnackBar('Please select a user type.', isError: true);
        return;
      }
      setState(() => _isLoading = true);
      registration();
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> registration() async {
    if (passwordController.text != cPasswordController.text) {
      setState(() => _isLoading = false);
      _showSnackBar("Passwords do not match.", isError: true);
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (kDebugMode) print(userCredential);

      await insertDataRegister(
        userCredential.user!.uid,
        firstController.text.trim(),
        lastnameController.text.trim(),
        emailController.text.trim(),
        mobileController.text.trim(),
        enrollController.text.trim(),
        organizationController.text.trim(),
        type,
        passwordController.text,
        cPasswordController.text,
      );

      setState(() => _isLoading = false);
      if (!mounted) return;
      _showSnackBar("Account created! Please sign in.");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);

      String message;
      if (e.code == 'weak-password') {
        message = 'Password is too weak. Please choose a stronger one.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for this email.';
      } else {
        message = 'Something went wrong. Please try again.';
      }

      _showSnackBar(message, isError: true);
    }
  }
}