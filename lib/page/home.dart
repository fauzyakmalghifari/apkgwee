import 'package:apkgawee1/page/theme_provider.dart';
import 'package:apkgawee1/widget/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ===== USER DATA =====
  bool isCompany = false;
  String username = "";
  bool isLoading = true;

  // ===== CATEGORY FILTER =====
  String? selectedCategory;

  final List<String> categories = [
    "Designer",
    "Manager",
    "Programmer",
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      setState(() => isLoading = false);
      return;
    }

    setState(() {
      isCompany = doc['role'] == 'company';

      if (isCompany) {
        username = doc['companyName'] ?? 'Company';
      } else {
        username = doc['username'] ?? doc['email'] ?? 'User';
      }

      isLoading = false;
    });
  }

  // ===== JOB STREAM WITH CATEGORY FILTER =====
  Stream<QuerySnapshot> _jobStream() {
    if (selectedCategory == null) {
      return FirebaseFirestore.instance
          .collection('jobs')
          .orderBy('createdAt', descending: true)
          .snapshots();
    }

    return FirebaseFirestore.instance
        .collection('jobs')
        .where('category', isEqualTo: selectedCategory)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppDrawer(activeMenu: "home"),

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleDarkMode(!themeProvider.isDarkMode);
            },
          ),
        ],
      ),

      // ===== BODY =====
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isCompany ? "Welcome Company" : "Hello"),
                    const SizedBox(height: 4),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(radius: 22),
              ],
            ),

            const SizedBox(height: 16),

            /// SEARCH
            if (!isCompany)
              TextField(
                decoration: InputDecoration(
                  hintText: "Search job here...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            /// RECOMMENDED
            if (!isCompany)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recommended Jobs",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "See our recommendations job for you based your skills",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.work, color: Colors.white, size: 48),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            /// JOB CATEGORY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Job Categories",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("More", style: TextStyle(color: Colors.deepPurple)),
              ],
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              children: categories.map((category) {
                final isActive = selectedCategory == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isActive,
                  selectedColor:
                  Theme.of(context).colorScheme.primary,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory =
                      isActive ? null : category;
                    });
                  },
                  labelStyle: TextStyle(
                    color: isActive ? Colors.white : null,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            /// FEATURED JOBS
            const Text(
              "Featured Jobs",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            StreamBuilder<QuerySnapshot>(
              stream: _jobStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Text(
                      "Tidak ada pekerjaan di kategori ini");
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    final data =
                    doc.data() as Map<String, dynamic>;
                    return _jobCard(
                      jobId: doc.id,
                      title: data['title'],
                      salary: data['salary'],
                      location: data['location'],
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: isCompany
          ? FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, '/add-job'),
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget _jobCard({
    required String jobId,
    required String title,
    required String salary,
    required String location,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.work,
            color: Colors.deepPurpleAccent),
        title: Text(title),
        subtitle: Text("$location\n$salary"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detail-job',
            arguments: jobId,
          );
        },
      ),
    );
  }
}