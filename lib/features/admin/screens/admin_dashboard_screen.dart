import 'package:flutter/material.dart';
import '../../auth/screens/auth_screen.dart';

class PendingVendorRequest {
  final String id;
  final String applicantName;
  final String stallName;
  final String category;
  final String requestDate;

  const PendingVendorRequest({
    required this.id,
    required this.applicantName,
    required this.stallName,
    required this.category,
    required this.requestDate,
  });
}

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
  final List<PendingVendorRequest> pendingRequests = [
    const PendingVendorRequest(
      id: 'req_1',
      applicantName: 'Usman Ghani',
      stallName: 'Pizza & Pasta Hub',
      category: 'Italian / Fast Food',
      requestDate: '18 Oct 2026',
    ),
    const PendingVendorRequest(
      id: 'req_2',
      applicantName: 'Tariq Mahmood',
      stallName: 'Fresh Fruit Juice Bar',
      category: 'Beverages',
      requestDate: '17 Oct 2026',
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

  void _signOut(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.dashboard_outlined), text: 'Overview'),
              Tab(icon: Icon(Icons.verified_user_outlined), text: 'Approvals'),
              Tab(icon: Icon(Icons.storefront_outlined), text: 'All Stalls'),
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
                '${pendingRequests.length}',
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
    return pendingRequests.isEmpty
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
            itemCount: pendingRequests.length,
            itemBuilder: (context, index) {
              final req = pendingRequests[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            req.stallName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            req.requestDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Applicant: ${req.applicantName}'),
                      Text(
                        'Category: ${req.category}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                pendingRequests.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Vendor request rejected'),
                                ),
                              );
                            },
                            child: const Text('Reject'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                registeredStalls.add(
                                  RegisteredStall(
                                    id: DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                    name: req.stallName,
                                    ownerName: req.applicantName,
                                    isActive: true,
                                    totalOrdersToday: 0,
                                  ),
                                );
                                pendingRequests.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${req.stallName} approved and added to campus stalls!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: const Text('Approve Stall'),
                          ),
                        ],
                      ),
                    ],
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
              activeColor: Colors.green,
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
