import 'package:flutter/material.dart';

class VendorRegistrationScreen extends StatefulWidget {
  const VendorRegistrationScreen({super.key});

  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Stall & Applicant Controllers
  final TextEditingController _stallNameController = TextEditingController();
  final TextEditingController _applicantNameController =
      TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _menuItemController = TextEditingController();

  String _selectedCategory = 'Fast Food';
  String _selectedZone = 'Main Cafeteria - Zone A';
  bool _agreedToGuidelines = false;

  final List<String> _categories = const [
    'Fast Food',
    'Snacks & Tea',
    'Desi',
    'Drinks',
    'Bakery & Desserts',
  ];

  final List<String> _campusZones = const [
    'Main Cafeteria - Zone A',
    'Student Center - Zone B',
    'Library Kiosk - Zone C',
    'Sports Complex Court',
  ];

  final List<String> _sampleMenuItems = ['Zinger Burger', 'Masala Fries'];

  // Simulated uploaded document filenames
  final Map<String, String?> _uploadedDocs = {
    'CNIC Copy': null,
    'Food Hygiene Certificate': null,
    'Campus NOC & Lease Agreement': null,
  };

  @override
  void dispose() {
    _stallNameController.dispose();
    _applicantNameController.dispose();
    _cnicController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _menuItemController.dispose();
    super.dispose();
  }

  void _addMenuItem() {
    final dish = _menuItemController.text.trim();
    if (dish.isEmpty) return;
    if (!_sampleMenuItems.contains(dish)) {
      setState(() {
        _sampleMenuItems.add(dish);
      });
    }
    _menuItemController.clear();
  }

  void _simulateDocumentPick(String docKey) {
    setState(() {
      if (_uploadedDocs[docKey] == null) {
        final slug = docKey.toLowerCase().replaceAll(
          RegExp(r'[^a-z0-9]+'),
          '_',
        );
        _uploadedDocs[docKey] = '${slug}_2026.pdf';
      } else {
        _uploadedDocs[docKey] = null;
      }
    });
  }

  bool get _allDocsAttached =>
      _uploadedDocs.values.every((fileName) => fileName != null);

  void _submitApplication() {
    if (!_formKey.currentState!.validate()) return;

    if (_sampleMenuItems.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least 2 sample menu items.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_allDocsAttached) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please attach all 3 required verification documents.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_agreedToGuidelines) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept the Campus Hygiene & Safety Guidelines.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final refId =
        'APP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Expanded(child: Text('Application Submitted')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your booth application for "${_stallNameController.text.trim()}" has been sent to the Super Admin Committee for review.',
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reference ID: #$refId',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Preferred Zone: $_selectedZone',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Text(
                    'Estimated Review Time: 24 - 48 Hours',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to AuthScreen
            },
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Apply for a Campus Booth')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primaryColor.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.storefront_rounded,
                      size: 34,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Become a Campus Vendor',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Complete your stall profile and upload compliance documents for admin verification.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Section 1: Stall & Booth Details
              const Text(
                '1. Stall & Booth Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stallNameController,
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Enter your proposed stall name'
                    : null,
                decoration: InputDecoration(
                  labelText: 'Proposed Stall Name',
                  hintText: 'e.g., Quetta Karak Chai & Paratha',
                  prefixIcon: const Icon(Icons.store_mall_directory_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _selectedZone,
                decoration: InputDecoration(
                  labelText: 'Preferred Campus Zone',
                  prefixIcon: const Icon(Icons.place_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _campusZones.map((zone) {
                  return DropdownMenuItem(value: zone, child: Text(zone));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedZone = val);
                },
              ),
              const SizedBox(height: 14),
              const Text(
                'Primary Food Category',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    selectedColor: primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Section 2: Owner / Applicant Information
              const Text(
                '2. Applicant Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _applicantNameController,
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Enter owner full name'
                    : null,
                decoration: InputDecoration(
                  labelText: 'Owner Full Name',
                  hintText: 'e.g., Tariq Mahmood',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cnicController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().length < 13) {
                    return 'Enter a valid 13-digit CNIC (e.g., 61101-1234567-1)';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'CNIC / National ID',
                  hintText: '61101-1234567-1',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || !val.contains('@')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Business Email',
                  hintText: 'owner@vendor.pk',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.trim().length < 10) {
                    return 'Enter a valid mobile number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: '0300-1234567',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section 3: Sample Menu Highlights
              const Text(
                '3. Sample Menu Highlights (Min. 2)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _menuItemController,
                      onSubmitted: (_) => _addMenuItem(),
                      decoration: InputDecoration(
                        hintText:
                            'Add a signature dish (e.g., Chicken Biryani)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onPressed: _addMenuItem,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _sampleMenuItems.map((dish) {
                  return Chip(
                    avatar: const Icon(
                      Icons.restaurant_menu,
                      size: 16,
                      color: Colors.orange,
                    ),
                    label: Text(dish, style: const TextStyle(fontSize: 12)),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() {
                        _sampleMenuItems.remove(dish);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Section 4: Required Document Attachments
              const Text(
                '4. Required Compliance Documents',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap each item to attach a scanned PDF or image copy.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: _uploadedDocs.keys.map((docKey) {
                    final attachedFile = _uploadedDocs[docKey];
                    final isUploaded = attachedFile != null;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isUploaded
                            ? Colors.green.withOpacity(0.15)
                            : Colors.grey.withOpacity(0.15),
                        child: Icon(
                          isUploaded
                              ? Icons.check_circle_rounded
                              : Icons.upload_file_rounded,
                          color: isUploaded ? Colors.green : Colors.grey,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        docKey,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        isUploaded
                            ? 'Attached: $attachedFile (1.2 MB)'
                            : 'Tap to attach PDF / JPG',
                        style: TextStyle(
                          fontSize: 11,
                          color: isUploaded
                              ? Colors.green
                              : Colors.grey.shade600,
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () => _simulateDocumentPick(docKey),
                        child: Text(isUploaded ? 'Remove' : 'Upload'),
                      ),
                      onTap: () => _simulateDocumentPick(docKey),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Safety & Hygiene Agreement Checkbox
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'I agree to abide by the Campus Cafeteria Hygiene, Electrical Safety (no open-flame gas cylinders in indoor zones), and Pricing Policy.',
                  style: TextStyle(fontSize: 12),
                ),
                value: _agreedToGuidelines,
                onChanged: (val) {
                  setState(() => _agreedToGuidelines = val ?? false);
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submitApplication,
                  icon: const Icon(Icons.send_rounded, size: 20),
                  label: const Text(
                    'Submit Vendor Application',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
