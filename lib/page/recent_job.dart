import 'package:apkgawee1/widget/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecentJob extends StatefulWidget {
  const RecentJob({super.key});

  @override
  State<RecentJob> createState() => _RecentJobState();
}

class _RecentJobState extends State<RecentJob> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // Sidebar
      drawer: const AppDrawer(activeMenu: "recent"),

      // AppBar
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Recent Job",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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

      // Body
      body: Column(
        children: [
          // 🔍 SEARCH BAR (TETAP ADA)
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
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
          ),

          // 📋 JOB LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('jobs')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("Belum ada lowongan pekerjaan"));
                }

                // Filter search
                final jobs = snapshot.data!.docs.where((doc) {
                  final data =
                  doc.data() as Map<String, dynamic>;
                  final title =
                  (data['title'] ?? '').toString().toLowerCase();
                  final location =
                  (data['location'] ?? '')
                      .toString()
                      .toLowerCase();

                  return title.contains(searchText) ||
                      location.contains(searchText);
                }).toList();

                if (jobs.isEmpty) {
                  return const Center(
                      child: Text("Pekerjaan tidak ditemukan"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final doc = jobs[index];
                    final data =
                    doc.data() as Map<String, dynamic>;

                    return _jobItem(
                      context,
                      jobId: doc.id,
                      title: data['title'],
                      location: data['location'],
                      salary: data['salary'],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //job item

  Widget _jobItem(
      BuildContext context, {
        required String jobId,
        required String title,
        required String location,
        required String salary,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail-job',
          arguments: jobId,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.work, color: Colors.white),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                    const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(location),
                  const SizedBox(height: 4),
                  Text(
                    salary,
                    style:
                    const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
