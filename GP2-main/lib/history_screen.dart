import 'package:flutter/material.dart';
import 'home_screen.dart';

class HistoryScreen extends StatelessWidget {
  final List<Appointment> appointments;

  const HistoryScreen({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
        backgroundColor: Colors.white,
      ), backgroundColor: Colors.white,
      body: appointments.isEmpty
          ? const Center(child: Text('No bookings available'))
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: ListTile(
                    title: Text(appointment.providerName),
                    subtitle: Text(
                      'Issue: ${appointment.issueDescription}\n'
                      'Date: ${appointment.date} at ${appointment.time}',
                    ),
                    // Removed the "Book Again" button
                  ),
                );
              },
            ),
    );
  }
}