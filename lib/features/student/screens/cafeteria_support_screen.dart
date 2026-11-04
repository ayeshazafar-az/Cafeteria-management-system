import 'package:flutter/material.dart';

class CafeteriaSupportScreen extends StatefulWidget {
  const CafeteriaSupportScreen({super.key});

  @override
  State<CafeteriaSupportScreen> createState() => _CafeteriaSupportScreenState();
}

class _CafeteriaSupportScreenState extends State<CafeteriaSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Wrong / Missing Item';
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  final List<String> _issueCategories = const [
    'Wrong / Missing Item',
    'Delayed Order Preparation',
    'Payment Charged but Failed',
    'Food Quality / Hygiene Issue',
    'Stall Feedback / General Inquiry',
  ];

  final List> _faqs = const [
    {
      'question': 'How do I know when my food is ready?',
      'answer':
          'Check your active "My Orders" tab. When the stall updates your order to READY, you will receive an in-app notification and your token card will highlight in green.'
    },
    {
      'question': 'What if my order is taking too long?',
      'answer':
          'Standard prep time is 10-15 minutes. If your order exceeds 20 minutes, tap the stall name on your active order card to contact the stall vendor directly or visit counter #1.'
    },
    {
      'question': 'How do refunds work for cancelled orders?',
      'answer':
          'If a stall cancels an order or runs out of stock, cash payments do not need reversal. For online payments, funds are automatically refunded to your mobile account within 24 hours.'
    },
    {
      'question': 'Can I modify or cancel my order after placing it?',
      'answer':
          'Orders can only be cancelled before the vendor marks them as "PREPARING". Once preparation starts, cancellations are not permitted.'
    },
  ];

  @override
  void dispose() {
    _orderIdController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      final orderId = _orderIdController.text.trim();
      final details = _detailsController.text.trim();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Support Ticket Sent'),
            ],
          ),
          content: Text(
            'Your query regarding "$_selectedCategory" ${orderId.isNotEmpty ? "(Order $orderId)" : ""} has been submitted to Campus Support.\n\nTicket ID: #TK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _orderIdController.clear();
                _detailsController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Help & Cafeteria Support'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.help_outline), text: 'FAQs'),
              Tab(icon: Icon(Icons.report_problem_outlined), text: 'Report Issue'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFaqTab(),
            _buildReportIssueTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Support Header Banner
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.support_agent_rounded, size: 36, color: Colors.blue),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Campus Support Counter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Main Cafeteria Desk • Open 8:00 AM - 5:00 PM',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _faqs.length,
            itemBuilder: (context, index) {
              final faq = _faqs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  leading: const Icon(Icons.quiz_outlined, size: 20, color: Colors.orange),
                  title: Text(
                    faq['question']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        faq['answer']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportIssueTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Submit a Support Ticket',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Our team investigates order disputes and stall issues immediately.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            const Text(
              'Issue Category',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
              items: _issueCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 16),

            const Text(
              'Order Token / ID (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _orderIdController,
              decoration: InputDecoration(
                hintText: 'e.g., #104 or ord_104',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Describe the Issue',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _detailsController,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please provide details about the issue';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Explain what went wrong with your order or stall experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _submitTicket,
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text(
                  'Submit Issue Report',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}