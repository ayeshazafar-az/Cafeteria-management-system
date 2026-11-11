import 'package:flutter/material.dart';

class VendorApplication {
  final String id;
  final String stallName;
  final String applicantName;
  final String email;
  final String phone;
  final String cnic;
  final String requestedCategory;
  final String proposedStallNumber;
  final String submissionDate;
  final List<String> sampleMenuItems;
  final Map<String, bool> documentsVerified;
  String status; // 'pending', 'approved', 'rejected'
  String? rejectionReason;

  VendorApplication({
    required this.id,
    required this.stallName,
    required this.applicantName,
    required this.email,
    required this.phone,
    required this.cnic,
    required this.requestedCategory,
    required this.proposedStallNumber,
    required this.submissionDate,
    required this.sampleMenuItems,
    required this.documentsVerified,
    this.status = 'pending',
    this.rejectionReason,
  });
}

class AdminStallApprovalDetailScreen extends StatefulWidget {
  final VendorApplication application;

  const AdminStallApprovalDetailScreen({super.key, required this.application});

  @override
  State<AdminStallApprovalDetailScreen> createState() =>
      _AdminStallApprovalDetailScreenState();
}

class _AdminStallApprovalDetailScreenState
    extends State<AdminStallApprovalDetailScreen> {
  late Map<String, bool> _docs;
  final TextEditingController _rejectionController = TextEditingController();
  final TextEditingController _stallNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _docs = Map.from(widget.application.documentsVerified);
    _stallNoController.text = widget.application.proposedStallNumber;
  }

  @override
  void dispose() {
    _rejectionController.dispose();
    _stallNoController.dispose();
    super.dispose();
  }

  bool get _allDocsVerified => _docs.values.every((v) => v);

  void _showApproveDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green),
              SizedBox(width: 8),
              Text('Approve Vendor'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to approve "${widget.application.stallName}" for campus operations?',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                'Assigned Stall / Booth Number',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _stallNoController,
                decoration: InputDecoration(
                  hintText: 'e.g., Stall #A-04',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  widget.application.status = 'approved';
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${widget.application.stallName} has been APPROVED! Account credentials generated.',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirm Approval'),
            ),
          ],
        );
      },
    );
  }

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.cancel_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Reject Application'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Specify the reason for rejecting "${widget.application.stallName}". An email notice will be sent to the applicant.',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _rejectionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'e.g., Incomplete Food Safety License / Category quota full',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final reason = _rejectionController.text.trim();
                if (reason.isEmpty) return;

                setState(() {
                  widget.application.status = 'rejected';
                  widget.application.rejectionReason = reason;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Application for ${widget.application.stallName} REJECTED.',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Confirm Rejection'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Review'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusBgColor(widget.application.status),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.application.status.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: _getStatusTextColor(widget.application.status),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vendor & Applicant Overview Header Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.storefront_rounded,
                        size: 36,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.application.stallName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Owner: ${widget.application.applicantName}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  widget.application.requestedCategory,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Applied: ${widget.application.submissionDate}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Contact & Identification Details Section
            const Text(
              'Applicant Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _buildDetailTile(
                    Icons.badge_outlined,
                    'CNIC / National ID',
                    widget.application.cnic,
                  ),
                  const Divider(height: 1),
                  _buildDetailTile(
                    Icons.email_outlined,
                    'Email Address',
                    widget.application.email,
                  ),
                  const Divider(height: 1),
                  _buildDetailTile(
                    Icons.phone_outlined,
                    'Contact Phone',
                    widget.application.phone,
                  ),
                  const Divider(height: 1),
                  _buildDetailTile(
                    Icons.place_outlined,
                    'Requested Booth Location',
                    widget.application.proposedStallNumber,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Uploaded Documents Verification Checkbox Card
            const Text(
              'Required Documents Verification',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Review and verify legal and food safety documents.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: _docs.keys.map((docName) {
                  final isChecked = _docs[docName]!;
                  return CheckboxListTile(
                    activeColor: Colors.green,
                    secondary: Icon(
                      isChecked
                          ? Icons.verified_user_rounded
                          : Icons.find_in_page_outlined,
                      color: isChecked ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      docName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      isChecked
                          ? 'Verified & Valid'
                          : 'Tap to mark as verified',
                      style: TextStyle(
                        fontSize: 11,
                        color: isChecked ? Colors.green : Colors.grey.shade600,
                      ),
                    ),
                    value: isChecked,
                    onChanged: widget.application.status != 'pending'
                        ? null
                        : (val) {
                            setState(() {
                              _docs[docName] = val ?? false;
                            });
                          },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Proposed Sample Menu Highlights
            const Text(
              'Proposed Menu Highlights',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.application.sampleMenuItems.map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.restaurant_menu_rounded,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Rejection reason notice if rejected
            if (widget.application.status == 'rejected' &&
                widget.application.rejectionReason != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rejection Reason Provided:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.application.rejectionReason!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Action Buttons Row (Only active when pending)
            if (widget.application.status == 'pending') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _showRejectDialog,
                      icon: const Icon(Icons.close_rounded, size: 20),
                      label: const Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _allDocsVerified ? _showApproveDialog : null,
                      icon: const Icon(Icons.check_rounded, size: 20),
                      label: const Text(
                        'Approve Stall',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (!_allDocsVerified) ...[
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    '⚠️ Verify all required documents above to enable Approval',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.grey.shade600),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
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
