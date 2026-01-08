import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../page/home.dart';
import '../page/recent_job.dart';
import '../page/find_job.dart';
import '../page/notification.dart';
import '../page/message.dart';
import '../page/profile.dart';
import '../page/settings.dart';
import '../page/login.dart';

class AppDrawer extends StatelessWidget {
  final String activeMenu;

  const AppDrawer({super.key, required this.activeMenu});

  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget page,
        bool isActive = false,
        String? badge,
      }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight:
                  isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin keluar dari akun ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.work,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Gawee",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:
                      Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _drawerItem(
              context,
              icon: Icons.home,
              title: "Home",
              page: const HomePage(),
              isActive: activeMenu == "home",
            ),
            _drawerItem(
              context,
              icon: Icons.work_outline,
              title: "Recent Job",
              page: const RecentJob(),
              isActive: activeMenu == "recent",
            ),
            _drawerItem(
              context,
              icon: Icons.search,
              title: "Find Job",
              page: const FindJobPage(),
              isActive: activeMenu == "find",
            ),
            _drawerItem(
              context,
              icon: Icons.notifications_outlined,
              title: "Notifications",
              page: const NotificationPage(),
              isActive: activeMenu == "notif",
            ),
            _drawerItem(
              context,
              icon: Icons.message_outlined,
              title: "Messages",
              page: const MessagesPage(),
              isActive: activeMenu == "messages",
            ),
            _drawerItem(
              context,
              icon: Icons.person_outline,
              title: "Profile",
              page: const ProfilePage(),
              isActive: activeMenu == "profile",
            ),
            _drawerItem(
              context,
              icon: Icons.settings_outlined,
              title: "Setting",
              page: const SettingsPage(),
              isActive: activeMenu == "settings",
            ),

            const Spacer(),

            // LOGOUT (VALIDASI)
            InkWell(
              onTap: () => _confirmLogout(context),
              child: Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Logout",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
