import 'package:apkgawee1/page/company_list.dart';
import 'package:apkgawee1/page/create_resume.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apkgawee1/widget/sidebar.dart';
import 'package:flutter/material.dart';

class FindJobPage extends StatefulWidget {
  const FindJobPage({super.key});

  @override
  State<FindJobPage> createState() => _FindJobPageState();
}

class _FindJobPageState extends State<FindJobPage> {
  final TextEditingController _qController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  List<QueryDocumentSnapshot>? _results;
  bool _searching = false;

  Future<void> _performSearch() async {
    final q = _qController.text.trim().toLowerCase();
    final location = _locationController.text.trim().toLowerCase();

    setState(() {
      _searching = true;
      _results = null;
    });

    try {
      final snap = await FirebaseFirestore.instance
          .collection('jobs')
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();

      final filtered = snap.docs.where((d) {
        final data = d.data() as Map<String, dynamic>;
        final title = (data['title'] ?? '').toString().toLowerCase();
        final desc = (data['description'] ?? '').toString().toLowerCase();
        final loc = (data['location'] ?? '').toString().toLowerCase();

        final matchesQ = q.isEmpty || title.contains(q) || desc.contains(q);
        final matchesLoc = location.isEmpty || loc.contains(location);
        return matchesQ && matchesLoc;
      }).toList();

      setState(() {
        _results = filtered.cast<QueryDocumentSnapshot>();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Search failed: $e')));
    } finally {
      setState(() {
        _searching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      //side bar
      drawer: const AppDrawer(activeMenu: "find"),

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,

        // tombol back tetap
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          "Find Job",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // search field
            TextField(
              controller: _qController,
              decoration: InputDecoration(
                hintText: "job title, keywords, or company",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: "Enter city or locality",
                prefixIcon: const Icon(Icons.location_on),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // search button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _performSearch,
                child: const Text(
                  "SEARCH",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Search results
            if (_searching) ...[
              const SizedBox(height: 12),
              const Center(child: CircularProgressIndicator()),
            ],

            if (!_searching && _results != null) ...[
              const SizedBox(height: 12),
              Text(
                'Results',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _results!.length,
                itemBuilder: (context, index) {
                  final doc = _results![index];
                  final data = doc.data() as Map<String, dynamic>;
                  return Card(
                    child: ListTile(
                      title: Text(data['title'] ?? 'No title'),
                      subtitle: Text(
                        '${data['companyName'] ?? ''} • ${data['location'] ?? ''}',
                      ),
                      trailing: TextButton(
                        child: const Text('View'),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/detail-job',
                            arguments: doc.id,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],

            //popular search
            const Text(
              "Popular Searches",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _popularItem(context, "Software developer fresher"),
                _popularItem(context, "Worker From Home"),
                _popularItem(context, "Driver"),
                _popularItem(context, "hr fresher"),
                _popularItem(context, "software testing"),
                _popularItem(context, "sales executive"),
                _popularItem(context, "business analyst"),
                _popularItem(context, "receptionist"),
                _popularItem(context, "data analyst"),
                _popularItem(context, "seo executive"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //widget
  Widget _searchField({required String hint, required IconData icon}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _popularItem(BuildContext context, String text) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompanyListPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search, size: 16),
            const SizedBox(width: 6),
            Text(text),
          ],
        ),
      ),
    );
  }
}
