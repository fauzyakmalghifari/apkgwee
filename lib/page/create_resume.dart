import 'package:apkgawee1/widget/sidebar.dart';
import 'package:flutter/material.dart';

class CreateResumePage extends StatefulWidget {
  const CreateResumePage({super.key});

  @override
  State<CreateResumePage> createState() => _CreateResumePageState();
}

class _CreateResumePageState extends State<CreateResumePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      //side bar
      drawer: const AppDrawer(activeMenu: ""),

      //app bar
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Resume",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            //post resume
            Text(
              "Post Your Resumes",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Adding your resume allows you to reply very quickly "
                  "to many jobs from any device",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            _iconCard(Icons.upload_file),

            const SizedBox(height: 16),

            Text(
              "Upload your resume",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Upload your resume and you'll be able to apply to "
                  "jobs in just one click!",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 16),

            _primaryButton(
              text: "Upload",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Upload resume belum diaktifkan"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            Divider(color: theme.dividerColor),

            const SizedBox(height: 32),

            //create resume
            _iconCard(Icons.edit_document),

            const SizedBox(height: 16),

            Text(
              "Create your resume",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Don't have a resume? Create one in no time with "
                  "our easy-to-use Resume-builder tool",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 16),

            _primaryButton(
              text: "Create",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Create resume belum diaktifkan"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //icon card
  Widget _iconCard(IconData icon) {
    final theme = Theme.of(context);

    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        size: 42,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _primaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}