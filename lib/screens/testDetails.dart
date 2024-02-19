// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import '../model/labModal.dart';
import '../model/testModal.dart';
import '../provider/auth_provider.dart';
import 'booking.dart';

class TestDetailsScreen extends StatefulWidget {
  final TestModel test;

  const TestDetailsScreen({
    super.key,
    required this.test,
  });

  @override
  _TestDetailsScreenState createState() => _TestDetailsScreenState();
}

class _TestDetailsScreenState extends State<TestDetailsScreen> {
  List<LabModel> labs = [];

  @override
  void initState() {
    super.initState();
    fetchLabsForTest();
  }

  void fetchLabsForTest() async {
    try {
      // Assuming widget.test.labIds contains the list of lab IDs associated with the test
      List<LabModel> fetchedLabs = await AuthProvider().fetchLabsForTest(
        widget.test.labIds,
      );

      setState(() {
        labs = fetchedLabs;
      });
    } catch (error) {
      print("Error fetching labs for test: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.test.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description: ${widget.test.description}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                "Price: \$${widget.test.price}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                "Labs Offering this Test:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (labs.isNotEmpty)
                Column(
                  children: labs.map((lab) {
                    return LabtestCard(
                      lab: lab,
                      onBookNowPressed: () {
                        // Implement your book now logic here
                        // You can use lab.id, lab.name, or any other lab details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookingScreen(),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              else
                const Text(
                  "No labs available for this test.", // Update with appropriate message or UI
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LabtestCard extends StatelessWidget {
  final LabModel lab;
  final VoidCallback onBookNowPressed;

  const LabtestCard({
    super.key,
    required this.lab,
    required this.onBookNowPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/fever.jpg', // Replace with the actual image path
            fit: BoxFit.cover,
            height: 120,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lab.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Timings: ${lab.timings}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Address: ${lab.address}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E69FE),
                  ),
                  onPressed: onBookNowPressed,
                  child: const Text("Book Now"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
