import 'package:flutter/material.dart';

typedef FaqItem = Map<String, String>;

class CafeteriaSupportScreen extends StatefulWidget {
  const CafeteriaSupportScreen({super.key});

  @override
  State<CafeteriaSupportScreen> createState() => _CafeteriaSupportScreenState();
}

class _CafeteriaSupportScreenState extends State<CafeteriaSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _orderTokenController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedIssueType = 'Delayed Order';

  final List<String> _issueTypes = const [
    'Delayed Order',
    'Missing or Wrong Item',
    'Payment / Refund Query',
    'Food Quality / Hygiene Feedback',
    'App Technical Issue',
  ];

  final List<FaqItem> _faqs = const [
    {
      'question': 'How long does it take for my order to be prepared?',
      'answer':
          'Most snacks and drinks take 5–10 minutes, while full meals take 12–20 minutes. You can track the live countdown timer on your active order card.',
    },
    {
      'question': 'Can I cancel an order after placing it?',
      'answer':
          'Orders can only be cancelled before the vendor accepts and moves the ticket to "Preparing" on their Kitchen Display.',
    },
    {
      'question': 'What if I miss the Ready notification chime?',
      'answer':
          'Your order stays at the stall pickup counter under your Token Number. Simply show your digital token screen at the counter.',
    },
    {
      'question': 'How do I pay for my campus cafeteria order?',
      'answer':
          'You can pay via Cash on Pickup at the stall counter or select Online Payment during checkout.',
    },
  ];

  @override
  void dispose() {
    _orderTokenController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitTicket() {
    if (!_formKey.currentState!.validate()) return;

    final ticketId =
        'TKT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    _orderTokenController.clear();
    _messageController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Support ticket #$ticketId submitted! Admin team will respond shortly.',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Cafeteria Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  Icon(Icons.support_agent_rounded, size: 36, color: primaryColor),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need Help with an Order?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Cafeteria Desk Hours: Mon–Fri, 8:00 AM – 5:00 PM',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: _faqs.map((faq) {
                  return ExpansionTile(
                    title: Text(
                      faq['question']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    children: [
                      Text(
                        faq['answer']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Report an Issue',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedIssueType,
                    decoration: InputDecoration(
                      labelText: 'Issue Category',
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _issueTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedIssueType = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _orderTokenController,
                    decoration: InputDecoration(
                      labelText: 'Order Token Number (Optional)',
                      hintText: 'e.g., #104',
                      prefixIcon: const Icon(Icons.confirmation_number_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 3,
                    validator: (val) => (val == null || val.trim().length < 8)
                        ? 'Please describe your issue in at least 8 characters'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Describe Your Issue',
                      hintText: 'Share stall name and what happened...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submitTicket,
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text(
                        'Submit Support Request',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
