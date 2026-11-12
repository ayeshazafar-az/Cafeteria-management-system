import 'package:flutter/material.dart';
import 'admin_stall_approval_detail_screen.dart';

class AdminVendorApplicationsScreen extends StatefulWidget {
  const AdminVendorApplicationsScreen({super.key});

  @override
  State<AdminVendorApplicationsScreen> createState() =>
      _AdminVendorApplicationsScreenState();
}

class _AdminVendorApplicationsScreenState
    extends State<AdminVendorApplicationsScreen> {
  String _selectedStatus = 'Pending';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _statusFilters = const [
    'All',
    'Pending',
    'Approved',
    'Rejected',
  ];

  final List<VendorApplication> _applications = [
    VendorApplication(
      id: 'app_201',
      stallName: 'Quetta Karak Chai & Paratha',
      applicantName: 'Tariq Mahmood',
      email: 'tariq.chai@vendor.pk',
      phone: '0300-5123498',
      cnic: '61101-4829103-1',
      requestedCategory: 'Snacks & Tea',
      proposedStallNumber: 'Stall #B-02',
      submissionDate: '11 Nov 2026',
      sampleMenuItems: const [
        'Doodh Patti Chai',
        'Aloo Cheese Paratha',
        'Lacha Paratha',
        'Elaichi Tea',
      ],
      documentsVerified: {
        'CNIC Copy': true,
        'Food Hygiene Certificate': true,
        'Campus NOC & Lease Agreement': false,
      },
      status: 'pending',
    ),
    VendorApplication(
      id: 'app_202',
      stallName: 'Shawarma & Wrap House',
      applicantName: 'Bilal Ahmed',
      email: 'bilal.wraps@vendor.pk',
      phone: '0333-8941205',
      cnic: '61101-9384712-5',
      requestedCategory: 'Fast Food',
      proposedStallNumber: 'Stall #A-05',
      submissionDate: '10 Nov 2026',
      sampleMenuItems: const [
        'Zinger Shawarma',
        'Arabic Platter',
        'Garlic Mayo Fries',
        'Mint Margarita',
      ],
      documentsVerified: {
        'CNIC Copy': true,
        'Food Hygiene Certificate': true,
        'Campus NOC & Lease Agreement': true,
      },
      status: 'pending',
    ),
    VendorApplication(
      id: 'app_203',
      stallName: 'Fresh Press Juice Corner',
      applicantName: 'Sanaullah Khan',
      email: 'sana.juices@vendor.pk',
      phone: '0321-4458921',
      cnic: '37405-1928374-7',
      requestedCategory: 'Drinks',
      proposedStallNumber: 'Kiosk #C-01',
      submissionDate: '08 Nov 2026',
      sampleMenuItems: const [
        'Fresh Orange Juice',
        'Mango Shake',
        'Apple Pomegranate Mix',
      ],
      documentsVerified: {
        'CNIC Copy': true,
        'Food Hygiene Certificate': true,
        'Campus NOC & Lease Agreement': true,
      },
      status: 'approved',
    ),
    VendorApplication(
      id: 'app_204',
      stallName: 'Spicy Noodle Cart',
      applicantName: 'Kamran Raza',
      email: 'kamran.noodles@vendor.pk',
      phone: '0345-7712390',
      cnic: '61101-7654321-9',
      requestedCategory: 'Fast Food',
      proposedStallNumber: 'Stall #A-06',
      submissionDate: '05 Nov 2026',
      sampleMenuItems: const ['Chicken Chow Mein', 'Hot & Sour Soup'],
      documentsVerified: {
        'CNIC Copy': true,
        'Food Hygiene Certificate': false,
        'Campus NOC & Lease Agreement': false,
      },
      status: 'rejected',
      rejectionReason:
          'Missing valid Food Authority Hygiene Certificate and open-flame gas cylinders are not permitted in Zone A.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VendorApplication> get _filteredApplications {
    return _applications.where((app) {
      final matchesStatus =
          _selectedStatus == 'All' ||
          app.status.toLowerCase() == _selectedStatus.toLowerCase();

      final query = _searchQuery.toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          app.stallName.toLowerCase().contains(query) ||
          app.applicantName.toLowerCase().contains(query) ||
          app.requestedCategory.toLowerCase().contains(query);

      return matchesStatus && matchesSearch;
    }).toList();
  }

  int _countByStatus(String status) {
    if (status == 'All') return _applications.length;
    return _applications
        .where((a) => a.status.toLowerCase() == status.toLowerCase())
        .length;
  }

  Future<void> _openApplicationDetail(VendorApplication application) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AdminStallApprovalDetailScreen(application: application),
      ),
    );
    // Refresh UI immediately in case status or doc checkboxes changed
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final filteredList = _filteredApplications;

    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Applications')),
      body: Column(
        children: [
          // Top Summary Metrics Strip
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                _buildSummaryPill(
                  'Pending',
                  _countByStatus('Pending'),
                  Colors.orange,
                ),
                const SizedBox(width: 10),
                _buildSummaryPill(
                  'Approved',
                  _countByStatus('Approved'),
                  Colors.green,
                ),
                const SizedBox(width: 10),
                _buildSummaryPill(
                  'Rejected',
                  _countByStatus('Rejected'),
                  Colors.red,
                ),
              ],
            ),
          ),

          // Search Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search stall name, owner, or category...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Status Filter Chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _statusFilters.length,
              itemBuilder: (context, index) {
                final filter = _statusFilters[index];
                final isSelected = _selectedStatus == filter;
                final count = _countByStatus(filter);

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text('$filter ($count)'),
                    selected: isSelected,
                    selectedColor: primaryColor,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedStatus = filter);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Applications List
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_off_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No $_selectedStatus Applications',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try switching filters or clearing your search query.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final app = filteredList[index];
                      final verifiedCount = app.documentsVerified.values
                          .where((v) => v)
                          .length;
                      final totalDocs = app.documentsVerified.length;
                      final allDocsReady = verifiedCount == totalDocs;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _openApplicationDetail(app),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        app.stallName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusBgColor(app.status),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        app.status.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusTextColor(
                                            app.status,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Applicant: ${app.applicantName} • ${app.proposedStallNumber}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primaryColor.withOpacity(
                                              0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            app.requestedCategory,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
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
                                              '$verifiedCount/$totalDocs Docs',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: allDocsReady
                                                    ? Colors.green
                                                    : Colors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          app.submissionDate,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.chevron_right,
                                          size: 18,
                                          color: Colors.grey.shade500,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPill(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green.shade50;
      case 'rejected':
        return Colors.red.shade50;
      default:
        return Colors.orange.shade50;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
