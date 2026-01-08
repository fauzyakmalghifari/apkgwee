import 'package:apkgawee1/widget/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final user = FirebaseAuth.instance.currentUser;
  bool isCompany = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    isCompany = doc.data()?['role'] == 'company';
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading || user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: const AppDrawer(activeMenu: "notification"),

      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),


      body: isCompany ? _companyView() : _userView(),
    );
  }

  //company view
  Widget _companyView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('companyUid', isEqualTo: user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Belum ada lamaran"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['jobTitle'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("Pelamar: ${data['username']}"),
                    const SizedBox(height: 12),

                    if (data['status'] == 'pending')
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _updateStatus(
                              applicationId: doc.id,
                              status: 'accepted',
                              jobTitle: data['jobTitle'],
                              userUid: data['userUid'],
                            ),
                            child: const Text("Terima"),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () => _updateStatus(
                              applicationId: doc.id,
                              status: 'rejected',
                              jobTitle: data['jobTitle'],
                              userUid: data['userUid'],
                            ),
                            child: const Text("Tolak"),
                          ),
                        ],
                      )
                    else
                      Text(
                        data['status'] == 'accepted'
                            ? "✅ Diterima"
                            : "❌ Ditolak",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: data['status'] == 'accepted'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //user view
  Widget _userView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .where('userUid', isEqualTo: user!.uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Belum ada notifikasi"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final data =
            snapshot.data!.docs[index].data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: Text(data['title']),
                subtitle: Text(data['message']),
                trailing: Icon(
                  data['type'] == 'accepted'
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: data['type'] == 'accepted'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            );
          },
        );
      },
    );
  }

  //update status
  Future<void> _updateStatus({
    required String applicationId,
    required String status,
    required String jobTitle,
    required String userUid,
  }) async {
    await FirebaseFirestore.instance
        .collection('applications')
        .doc(applicationId)
        .update({'status': status});

    await FirebaseFirestore.instance.collection('notifications').add({
      'userUid': userUid,
      'title':
      status == 'accepted' ? 'Lamaran Diterima' : 'Lamaran Ditolak',
      'message': 'Lamaran kamu untuk $jobTitle $status',
      'type': status,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}