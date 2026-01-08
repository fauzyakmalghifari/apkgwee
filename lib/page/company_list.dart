import 'package:apkgawee1/widget/sidebar.dart';
import 'package:flutter/material.dart';

class CompanyListPage extends StatefulWidget {
  const CompanyListPage({super.key});

  @override
  State<CompanyListPage> createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      //side bar
      drawer: const AppDrawer(activeMenu: ""),

      //app bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Company List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.more_vert,
                  color: Theme.of(context).iconTheme.color),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),

      //body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              decoration: InputDecoration(
                hintText: "Type Company Name",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            //company list
            _companyCard(
              context,
              name: "Google",
              location: "California, United States",
              jobs: "10 Jobs",
              logo: _googleLogo(),
            ),
            _companyCard(
              context,
              name: "Microsoft",
              location: "Redmond, Washington, USA",
              jobs: "9 Jobs",
              logo: _microsoftLogo(),
            ),
            _companyCard(
              context,
              name: "Twitter",
              location: "San Francisco, United States",
              jobs: "4 Jobs",
              logo: _twitterLogo(),
            ),
            _companyCard(
              context,
              name: "Tencent",
              location: "Shenzhen, China",
              jobs: "4 Jobs",
              logo: _tencentLogo(),
            ),
            _companyCard(
              context,
              name: "Google",
              location: "California, United States",
              jobs: "10 Jobs",
              logo: _googleLogo(),
            ),
            _companyCard(
              context,
              name: "Microsoft",
              location: "Redmond, Washington, USA",
              jobs: "9 Jobs",
              logo: _microsoftLogo(),
            ),
          ],
        ),
      ),
    );
  }

  //company card
  Widget _companyCard(
      BuildContext context, {
        required String name,
        required String location,
        required String jobs,
        required Widget logo,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          // LOGO
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: logo,
          ),

          const SizedBox(width: 12),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  jobs,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleLogo() {
    return const Icon(Icons.g_mobiledata, size: 40, color: Colors.red);
  }

  Widget _microsoftLogo() {
    return GridView.count(
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        ColoredBox(color: Colors.red),
        ColoredBox(color: Colors.green),
        ColoredBox(color: Colors.blue),
        ColoredBox(color: Colors.yellow),
      ],
    );
  }

  Widget _twitterLogo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.flutter_dash, color: Colors.white),
    );
  }

  Widget _tencentLogo() {
    return const Center(
      child: Text(
        "Tencent",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}
