// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../model/booking_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AllBookingsScreen extends StatelessWidget {
  const AllBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Bookings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return FutureBuilder<List<BookingModel>>(
            future: authProvider.getBookings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(child: Text('No bookings available.'));
              } else {
                List<BookingModel> bookings = snapshot.data!;

                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return BookingCard(booking: bookings[index]);
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lab Name:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Lab Speciality:',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Preferred Pathologist:',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          booking.preferredPathologist,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/irontest.jpg', // Replace with the actual image asset path
                      width: 80.0,
                      height: 80.0,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Appointment Date:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          booking.appointmentDate,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E69FE),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Appointment Time:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          booking.appointmentTime,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E69FE),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Status: ${booking.appointmentStatus}',
                  style: const TextStyle(fontSize: 14.0),
                ),
                Text(
                  'Payment Status: ${booking.paymentStatus}',
                  style: const TextStyle(fontSize: 14.0),
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 1.0,
                  width: double.infinity,
                  color: Colors.white, // Adjust the color as needed
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Add logic for reviewing the booking
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return FeedbackForm(booking: booking);
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3E69FE),
                        ),
                        child: const Text(
                          'Review',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: 16.0, // Adjust the space between buttons
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Add logic for rescheduling the booking
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3E69FE),
                        ),
                        child: const Text(
                          'Reschedule',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Booking'),
                                  content: const Text(
                                    'Are you sure you want to delete this booking?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await authProvider
                                            .deleteBooking(booking.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeedbackForm extends StatelessWidget {
  final BookingModel booking;

  const FeedbackForm({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    double rating = 0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review Appointment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          // Add a TextField for entering feedback
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Feedback',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          // Add a RatingBar for rating the appointment
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30.0,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (value) {
              rating = value;
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Add logic to submit the feedback and rating
              // ...

              // Close the modal bottom sheet
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3E69FE),
            ),
            child: const Text(
              'Submit Review',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
