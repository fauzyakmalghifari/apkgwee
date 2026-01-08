import 'package:apkgawee1/services/job_services.dart';
import 'package:flutter/material.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _salary = TextEditingController();
  final _location = TextEditingController();
  final _category = TextEditingController();

  final JobService _jobService = JobService();
  bool isLoading = false;

  final List<String> categories = [
    "Designer",
    "Manager",
    "Programmer",
  ];

  Future<void> _submit() async {
    if (_title.text.isEmpty ||
        _desc.text.isEmpty ||
        _salary.text.isEmpty ||
        _location.text.isEmpty ||
        _category.text.isEmpty) {
      _showError('Semua field wajib diisi');
      return;
    }

    setState(() => isLoading = true);

    try {
      await _jobService.addJob(
        title: _title.text.trim(),
        description: _desc.text.trim(),
        salary: _salary.text.trim(),
        location: _location.text.trim(),
        category: _category.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Job'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _field('Job Title', _title),
            _field('Description', _desc),
            _field('Salary', _salary),
            _field('Location', _location),
            DropdownButtonFormField<String>(
              initialValue: _category.text.isEmpty ? null : _category.text,
              hint: const Text("Job Category"),
              items: categories.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Text(c),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _category.text = value ?? '';
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SUBMIT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
