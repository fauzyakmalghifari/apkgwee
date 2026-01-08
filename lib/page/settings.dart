import 'package:apkgawee1/page/theme_provider.dart';
import 'package:apkgawee1/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<Map<String, dynamic>> colorThemes = [
    {"name": "Red", "color": Colors.red},
    {"name": "Green", "color": Colors.green},
    {"name": "Blue", "color": Colors.blue},
    {"name": "Pink", "color": Colors.pink},
    {"name": "Yellow", "color": Colors.amber},
    {"name": "Orange", "color": Colors.orange},
    {"name": "Purple", "color": Colors.purple},
    {"name": "DeepPurple", "color": Colors.deepPurple},
    {"name": "LightBlue", "color": Colors.lightBlue},
  ];

  @override
  Widget build(BuildContext context) {
    // 🔹 WATCH hanya untuk membaca state
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      drawer: const AppDrawer(activeMenu: "setting"),

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Color Themes",
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= LAYOUT MODE =================
            Text(
              "Layout Themes",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: 8),

            _infoCard(
              context,
              "Choose your app appearance mode",
              child: Row(
                children: [
                  _themeCard(
                    context,
                    isSelected: !themeProvider.isDarkMode,
                    color: Colors.white,
                    onTap: () {
                      context.read<ThemeProvider>().toggleDarkMode(false);
                    },
                  ),
                  const SizedBox(width: 16),
                  _themeCard(
                    context,
                    isSelected: themeProvider.isDarkMode,
                    color: Colors.black,
                    onTap: () {
                      context.read<ThemeProvider>().toggleDarkMode(true);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ================= COLOR THEME =================
            Text(
              "Default Color Themes",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: 8),

            _infoCard(
              context,
              "Select primary color for the app",
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: colorThemes.map((theme) {
                  final color = theme["color"] as Color;

                  return GestureDetector(
                    onTap: () {
                      // 🔥 READ untuk aksi
                      context.read<ThemeProvider>().changeColor(color);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: themeProvider.primaryColor == color
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        theme["name"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= COMPONENT =================
  Widget _infoCard(BuildContext context, String text,
      {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style:
            TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _themeCard(
      BuildContext context, {
        required bool isSelected,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: isSelected
            ? Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
          ),
        )
            : null,
      ),
    );
  }
}
