import 'package:flutter/material.dart';
import '../../auth/screens/auth_screen.dart';
import 'admin_stall_approval_detail_screen.dart';

class RegisteredStall {
  final String id;
  final String name;
  final String ownerName;
  bool isActive;
  final int totalOrdersToday;

  RegisteredStall({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.isActive,
    required this.totalOrdersToday,
  });
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final List<VendorApplication> _applications = [
    VendorApplication(
      id: 'req_1',
      stallName: 'Pizza & Pasta Hub',
      applicantName: 'Usman Ghani',
      email: 'usman.pizza@vendor.pk',
      phone: '0300-5544332',
      cnic: '61101-4829103-1',
      requestedCategory: 'Italian / Fast Food',
      proposedStallNumber: 'Stall #A-04',
      submissionDate: '18 Oct 2026',
      sampleMenuItems: const [
        'Chicken Fajita Pizza',
        'Creamy Alfredo Pasta',
        'Garlic Bread Supreme',
      ],
      documentsVerified: {
        'CNIC Copy': true,
        'Food Hygiene Certificate': true,
        'Campus NOC & Lease Agreement': false,
      },
      status: 'pending',
    ),
    VendorApplication(
      id: 'req_2',
      stallName: 'Fresh Fruit Juice Bar',
      applicantName: 'Tariq Mahmood',
      email: 'tariq.juice@vendor.pk',
      phone: '0333-8941205',
      cnic: '61101-9384712-5',
      requestedCategory: 'Beverages',
      proposedStallNumber: 'Kiosk #C-02',
      submissionDate: '17 Oct 2026',
      sampleMenuItems: const [
        'Fresh Orange Juice',
        'Mint Margarita',
        'Mango Shake',
      ],
      documentsVerified: {
        'CNIC Copy': true,
        'Food Hygiene Certificate': true,
        'Campus NOC & Lease Agreement': true,
      },
      status: 'pending',
    ),
  ];

  final List<RegisteredStall> registeredStalls = [
    RegisteredStall(
      id: 'st_1',
      name: 'Central Fast Food',
      ownerName: 'Zahid Khan',
      isActive: true,
      totalOrdersToday: 74,
    ),
    RegisteredStall(
      id: 'st_2',
      name: 'Campus Chai & Snacks',
      ownerName: 'Bilal Hassan',
      isActive: true,
      totalOrdersToday: 92,
    ),
    RegisteredStall(
      id: 'st_3',
      name: 'Lahori Biryani Corner',
      ownerName: 'Sajid Ali',
      isActive: true,
      totalOrdersToday: 48,
    ),
  ];

  List<VendorApplication> get _pendingApplications =>
      _applications.where((app) => app.status == 'pending').toList();

  Future<void> _openApplicationDetail(VendorApplication application) async {
    final previousStatus = application.status;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AdminStallApprovalDetailScreen(application: application),
      ),
    );

    if (!mounted) return;

    // If approved on the detail screen, register the new stall into All Stalls
    if (previousStatus == 'pending' && application.status == 'approved') {
      final alreadyAdded = registeredStalls.any(
        (s) => s.name.toLowerCase() == application.stallName.toLowerCase(),
      );
      if (!alreadyAdded) {
        registeredStalls.add(
          RegisteredStall(
            id: 'st_${DateTime.now().millisecondsSinceEpoch}',
            name: application.stallName,
            ownerName: application.applicantName,
            isActive: true,
            totalOrdersToday: 0,
          ),
        );
      }
    }

    setState(() {});
  }

  void _signOut(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _pendingApplications.length;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Campus Super Admin'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              tooltip: 'Sign Out Admin',
              onPressed: () => _signOut(context),
            ),
          ],
          bottom: TabBar(
            tabs: [
              const Tab(icon: Icon(Icons.dashboard_outlined), text: 'Overview'),
              Tab(
                icon: Badge(
                  isLabelVisible: pendingCount > 0,
                  label: Text('$pendingCount'),
                  child: const Icon(Icons.verified_user_outlined),
                ),
                text: 'Approvals',
              ),
              const Tab(icon: Icon(Icons.storefront_outlined), text: 'All Stalls'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildApprovalsTab(),
            _buildStallsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Campus Cafeteria Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.3,
            children: [
              _buildMetricTile(
                'Total Campus Orders',
                '214',
                Icons.shopping_bag_outlined,
                Colors.blue,
              ),
              _buildMetricTile(
                'Total Campus Sales',
                'PKR 64,200',
                Icons.account_balance_wallet_outlined,
                Colors.green,
              ),
              _buildMetricTile(
                'Active Stalls',
                '${registeredStalls.where((s) => s.isActive).length}',
                Icons.store_rounded,
                Colors.orange,
              ),
              _buildMetricTile(
                'Pending Approvals',
                '${_pendingApplications.length}',
                Icons.pending_actions_rounded,
                Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'System Activity Log',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Central Fast Food reached 50+ orders today'),
                  subtitle: Text('10 mins ago'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.person_add, color: Colors.blue),
                  title: Text('New Vendor Request: Pizza & Pasta Hub'),
                  subtitle: Text('1 hour ago'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalsTab() {
    final pendingList = _pendingApplications;

    return pendingList.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                SizedBox(height: 12),
                Text(
                  'No pending vendor requests',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pendingList.length,
            itemBuilder: (context, index) {
              final req = pendingList[index];
              final verifiedDocs =
                  req.documentsVerified.values.where((v) => v).length;
              final totalDocs = req.documentsVerified.length;
              final allDocsReady = verifiedDocs == totalDocs;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _openApplicationDetail(req),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                req.stallName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              req.submissionDate,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Applicant: ${req.applicantName} • ${req.proposedStallNumber}',
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Category: ${req.requestedCategory}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  allDocsReady
                                      ? Icons.verified_rounded
                                      : Icons.pending_actions,
                                  size: 14,
                                  color: allDocsReady
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$verifiedDocs/$totalDocs Docs Verified',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: allDocsReady
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.fact_check_outlined,
                                size: 18,
                              ),
                              label: const Text('Inspect Documents & Review'),
                              onPressed: () => _openApplicationDetail(req),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildStallsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: registeredStalls.length,
      itemBuilder: (context, index) {
        final stall = registeredStalls[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: stall.isActive
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              child: Icon(
                Icons.storefront,
                color: stall.isActive ? Colors.green : Colors.red,
              ),
            ),
            title: Text(
              stall.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Owner: ${stall.ownerName} • Today: ${stall.totalOrdersToday} orders',
            ),
            trailing: Switch(
              value: stall.isActive,
              activeThumbColor: Colors.green,
              onChanged: (val) {
                setState(() {
                  stall.isActive = val;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${stall.name} set to ${val ? "Active" : "Disabled"}',
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricTile(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
