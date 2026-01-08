import 'package:apkgawee1/widget/sidebar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      //side bar
      drawer: const AppDrawer(activeMenu: "profile"),

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          "Profile",
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage("assets/profile.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Name
            Center(
              child: Text(
                "Richard Brownlee",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:
                  Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Job title
            Center(
              child: Text(
                "Engineer",
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              "Duis aute irure dolor in reprehenderit in voluptate velit esse "
                  "cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat "
                  "cupidatat non proident",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color,
              ),
            ),

            const SizedBox(height: 24),

            // Resume Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Icon(Icons.description, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Resume",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "david_resume.pdf",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.file_upload, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Skills
            Text(
              "Skills",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),

            const SizedBox(height: 16),

            _skillItem(context, "Problem Solving", 0.7),
            _skillItem(context, "Drawing", 0.35),
            _skillItem(context, "Illustration", 0.8),
            _skillItem(context, "Photoshop", 0.34),
          ],
        ),
      ),
    );
  }

  //skil item
  Widget _skillItem(BuildContext context, String skill, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill,
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color,
                ),
              ),
              Text(
                "${(value * 100).toInt()}%",
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade300,
              color: Theme.of(context).colorScheme.primary,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
