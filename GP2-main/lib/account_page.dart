import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'EditProfileScreen.dart';
import 'Login_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'payment.dart';
import 'location_screen.dart';

class AccountPage extends StatefulWidget {
  final List<Appointment> appointments;

  const AccountPage({super.key, required this.appointments});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  LatLng? _lastSavedLocation;
  String _firstName = 'New'; // Default first name
  String _lastName = 'User'; // Default last name

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('images/profile.png'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_firstName $_lastName', // Display the updated name
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      // Navigate to EditProfileScreen and wait for the result
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );

                      // If the result is not null, update the name in the UI
                      if (result != null) {
                        setState(() {
                          _firstName = result['firstName'];
                          _lastName = result['lastName'];
                        });
                      }
                    },
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu Items
            ListTile(
              leading: const Icon(Icons.history, color: Colors.black),
              title: const Text('History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HistoryScreen(appointments: widget.appointments),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.black),
              title: const Text('Payments'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentScreen(),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.black),
              title: const Text('Location'),
              onTap: () async {
                final LatLng? selectedLocation = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationScreen(
                      initialLocation: _lastSavedLocation ?? const LatLng(31.9539, 35.9106),
                    ),
                  ),
                );

                if (selectedLocation != null) {
                  setState(() {
                    _lastSavedLocation = selectedLocation;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Location saved: ${_lastSavedLocation!.latitude}, ${_lastSavedLocation!.longitude}',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}