import 'package:flutter/material.dart';
import 'package:furniswap/presentation/screens/repairRequestScreen.dart'; // غيّر المسار لو مختلف

class MyWorkshopScreen extends StatelessWidget {
  const MyWorkshopScreen({super.key});

  final List<Map<String, dynamic>> workshops = const [
    {
      'image': 'assets/images/workshop1.png',
      'title': 'Craft Haven',
      'subtitle': 'Antique Restoration',
      'rating': 4.9
    },
    {
      'image': 'assets/images/workshop2.png',
      'title': 'FixIt Woodworks',
      'subtitle': 'Custom Design',
      'rating': 4.6
    },
    {
      'image': 'assets/images/workshop3.png',
      'title': 'Timber Touch',
      'subtitle': 'Repair & Polish',
      'rating': 4.8
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Workshops',
          style: TextStyle(
            color: Color(0xff694A38),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xff694A38)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Color(0xff694A38)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: workshops.length,
        separatorBuilder: (_, __) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final workshop = workshops[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    workshop['image'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workshop['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xff4A3F35),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            workshop['subtitle'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              SizedBox(width: 4),
                              Text(
                                workshop['rating'].toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RepairRequestScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff694A38),
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Repair request",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
