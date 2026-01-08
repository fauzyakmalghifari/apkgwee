import 'package:apkgawee1/page/add_job.dart';
import 'package:apkgawee1/page/message.dart';
import 'package:apkgawee1/page/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:apkgawee1/firebase_options.dart';

// pages
import 'package:apkgawee1/page/company_list.dart';
import 'package:apkgawee1/page/detail_job.dart';
import 'package:apkgawee1/page/home.dart';
import 'package:apkgawee1/page/login.dart';
import 'package:apkgawee1/page/notification.dart';
import 'package:apkgawee1/page/profile.dart';
import 'package:apkgawee1/page/recent_job.dart';
import 'package:apkgawee1/page/register.dart';
import 'package:apkgawee1/page/role.dart';
import 'package:apkgawee1/page/settings.dart';
import 'package:apkgawee1/page/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const JobApp(),
    ),
  );
}

class JobApp extends StatelessWidget {
  const JobApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,

      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/role': (context) => const RolePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/recent-job': (context) => const RecentJob(),
        '/detail-job': (context) => const JobDetailPage(),
        '/company-list': (context) => const CompanyListPage(),
        '/notification': (context) => const NotificationPage(),
        '/profile': (context) => const ProfilePage(),
        '/setting': (context) => const SettingsPage(),
        '/message': (context) => const MessagesPage(),
        '/add-job': (context) => const AddJobPage(),
      },
    );
  }
}
