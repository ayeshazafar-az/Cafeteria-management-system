import 'package:flutter/material.dart';
import 'shop_detail_screen.dart';

class Shop {
  final String id;
  final String name;
  final String category;
  final double rating;
  final bool isOpen;
  final IconData icon;

  const Shop({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.isOpen,
    required this.icon,
  });
}

class StudentShopsScreen extends StatelessWidget {
  const StudentShopsScreen({super.key});

  final List<Shop> mockShops = const [
    Shop(
      id: 's1',
      name: 'Central Fast Food',
      category: 'Burgers, Fries, Rolls',
      rating: 4.8,
      isOpen: true,
      icon: Icons.fastfood_rounded,
    ),
    Shop(
      id: 's2',
      name: 'Campus Chai & Snacks',
      category: 'Tea, Coffee, Samosa, Paratha',
      rating: 4.6,
      isOpen: true,
      icon: Icons.coffee_rounded,
    ),
    Shop(
      id: 's3',
      name: 'Fresh Juice & Shakes Bar',
      category: 'Juices, Milkshakes, Ice Cream',
      rating: 4.9,
      isOpen: false,
      icon: Icons.local_drink_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cafeteria Stalls'), elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockShops.length,
        itemBuilder: (context, index) {
          final shop = mockShops[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: shop.isOpen
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShopDetailScreen(shop: shop),
                        ),
                      );
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: shop.isOpen
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        shop.icon,
                        size: 32,
                        color: shop.isOpen
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shop.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: shop.isOpen ? Colors.black : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            shop.category,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${shop.rating}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: shop.isOpen
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        shop.isOpen ? 'OPEN' : 'CLOSED',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: shop.isOpen ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
