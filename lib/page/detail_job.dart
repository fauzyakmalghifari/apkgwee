import 'package:apkgawee1/services/applyjob_service.dart';
import 'package:apkgawee1/widget/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JobDetailPage extends StatefulWidget {
  const JobDetailPage({super.key});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  int selectedTab = 0;

  String jobId = '';
  bool isLoading = true;
  bool hasApplied = false;

  Map<String, dynamic>? jobData;

  final user = FirebaseAuth.instance.currentUser;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobId = ModalRoute.of(context)!.settings.arguments as String;
    _loadJobDetail();
  }
  Future<void> _loadJobDetail() async {
    final jobDoc = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(jobId)
        .get();

    if (!jobDoc.exists) {
      setState(() => isLoading = false);
      return;
    }

    jobData = jobDoc.data();

    if (user != null) {
      final applied = await FirebaseFirestore.instance
          .collection('applications')
          .where('userUid', isEqualTo: user!.uid)
          .where('jobId', isEqualTo: jobId)
          .get();

      hasApplied = applied.docs.isNotEmpty;
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppDrawer(activeMenu: ""),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.work, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              jobData?['companyName'] ?? 'Company',
              style: TextStyle(
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.more_vert,
                  color: Theme.of(context).iconTheme.color),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (jobData?['type'] != null)
                  _badge(context, jobData!['type']),
                const SizedBox(width: 8),
                if (jobData?['category'] != null)
                  _badge(context, jobData!['category']),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              jobData?['title'] ?? '',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            Text(jobData?['location'] ?? ''),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  jobData?['salary'] ?? '',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text("Salary range (monthly)"),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                _tab(context, "Job Description", 0),
                const SizedBox(width: 24),
                _tab(context, "Our Gallery", 1),
              ],
            ),

            const SizedBox(height: 16),

            selectedTab == 0
                ? Text(jobData?['description'] ?? '')
                : const Center(child: Text("Gallery Content Here")),
          ],
        ),
      ),

      //bottom
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.bookmark_border),
            ),

            const SizedBox(width: 12),

            GestureDetector(
              onTap: () => _startChat(context),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasApplied
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: hasApplied
                      ? null
                      : () => _showApplyJobSheet(context),
                  child: Text(
                    hasApplied ? "SUDAH MELAMAR" : "APPLY JOB",
                    style:
                    const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //component
  Widget _badge(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border:
        Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, String text, int index) {
    final isActive = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 40,
              height: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
    );
  }

  //apply sheet
  void _showApplyJobSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _inputField("User Name", _nameController),
              const SizedBox(height: 12),
              _inputField("Email Address", _emailController,
                  type: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _inputField("Phone number", _phoneController,
                  type: TextInputType.phone),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Semua field wajib diisi")),
                    );
                    return;
                  }

                  await ApplyJobService().applyJob(
                    jobId: jobId,
                    jobTitle: jobData?['title'] ?? '',
                    companyUid: jobData?['companyUid'] ?? '',
                    companyName: jobData?['companyName'] ?? '',
                    username: _nameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                  );

                  Navigator.pop(context);
                  setState(() => hasApplied = true);
                },
                child: const Text("SUBMIT"),
              )
            ],
          ),
        );
      },
    );
  }

  //chat
  String _generateChatId(String uid1, String uid2) {
    return uid1.compareTo(uid2) < 0
        ? '${uid1}_$uid2'
        : '${uid2}_$uid1';
  }

  Future<void> _startChat(BuildContext context) async {
    if (user == null) return;

    final String myUid = user!.uid;
    final String companyUid = jobData?['companyUid'] ?? '';

    if (companyUid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Company tidak ditemukan")),
      );
      return;
    }

    final chatId = _generateChatId(myUid, companyUid);

    final chatRef =
    FirebaseFirestore.instance.collection('chats').doc(chatId);

    final chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      await chatRef.set({
        'members': [myUid, companyUid],
        'lastMessage': '',
        'updatedAt': FieldValue.serverTimestamp(),
        'jobId': jobId,
        'companyName': jobData?['companyName'] ?? '',
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Chat berhasil dibuat")),
    );
  }


  Widget _inputField(String hint, TextEditingController c,
      {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: c,
      keyboardType: type,
      decoration: InputDecoration(hintText: hint),
    );
  }
}
