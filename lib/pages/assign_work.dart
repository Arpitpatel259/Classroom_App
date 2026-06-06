// ignore_for_file: body_might_complete_normally_nullable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wissme/DataBase%20Work/insert_work.dart';
import 'package:wissme/main.dart';

class AssignWork extends StatefulWidget {
  const AssignWork({super.key});

  @override
  State<AssignWork> createState() => _AssignWorkState();
}

class _AssignWorkState extends State<AssignWork> {
  final _formKey = GlobalKey<FormState>();
  final classController = TextEditingController();
  final workNameController = TextEditingController();
  final workTitleController = TextEditingController();
  final facultyController = TextEditingController();
  final dateInput = TextEditingController();

  bool _isLoading = false;

  // Design Tokens
  final Color primaryBlue = const Color(0xFF1A73E8);
  final Color darkText = const Color(0xFF1A1A2E);
  final Color bodyText = const Color(0xFF6B7280);
  final Color backgroundColor = const Color(0xFFF7F8FA);
  final Color borderColor = const Color(0xFFE5E7EB);

  @override
  void dispose() {
    classController.dispose();
    workNameController.dispose();
    workTitleController.dispose();
    facultyController.dispose();
    dateInput.dispose();
    super.dispose();
  }

  // Reusable input decoration matching Login/Register
  InputDecoration _inputDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFADB5BD), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: darkText,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(fontSize: 15, color: darkText),
          validator: validator,
          decoration: _inputDecoration(hint: hint, icon: icon),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Assign New Work",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildField(
                  controller: classController,
                  label: "Class Name",
                  hint: "e.g. 10th Grade A",
                  icon: Icons.school_outlined,
                  validator: (val) =>
                  (val == null || val.isEmpty)
                      ? 'Please enter class name'
                      : null,
                ),
                _buildField(
                  controller: workTitleController,
                  label: "Work Title",
                  hint: "e.g. Mathematics Chapter 5",
                  icon: Icons.title_rounded,
                  validator: (val) =>
                  (val == null || val.isEmpty)
                      ? 'Please enter work title'
                      : null,
                ),
                _buildField(
                  controller: workNameController,
                  label: "Work Details / Instructions",
                  hint: "Describe the assignment here...",
                  icon: Icons.description_outlined,
                  maxLines: 3,
                  validator: (val) =>
                  (val == null || val.isEmpty)
                      ? 'Please enter work details'
                      : null,
                ),
                _buildLabel("Due Date"),
                TextFormField(
                  controller: dateInput,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: _inputDecoration(hint: "Select deadline",
                      icon: Icons.calendar_month_outlined),
                  validator: (val) =>
                  (val == null || val.isEmpty)
                      ? 'Please select a due date'
                      : null,
                ),
                const SizedBox(height: 18),
                _buildField(
                  controller: facultyController,
                  label: "Faculty Name",
                  hint: "Enter your name",
                  icon: Icons.person_outline_rounded,
                  validator: (val) =>
                  (val == null || val.isEmpty)
                      ? 'Please enter faculty name'
                      : null,
                ),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.assignment_add, color: primaryBlue, size: 28),
        ),
        const SizedBox(height: 16),
        Text(
          "Create Assignment",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: darkText,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Fill in the details to assign work to your students.",
          style: TextStyle(fontSize: 14, color: bodyText),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleAssignment,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
            : const Text(
          'Assign Work',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: primaryBlue),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        dateInput.text = formattedDate;
      });
    }
  }

  void _handleAssignment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await insertDataForWork(
          classController.text.trim(),
          workNameController.text.trim(),
          workTitleController.text.trim(),
          dateInput.text,
          facultyController.text.trim(),
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Work Assigned Successfully!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
