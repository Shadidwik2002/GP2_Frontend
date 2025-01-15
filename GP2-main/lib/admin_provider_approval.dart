import 'package:flutter/material.dart';

class AdminProviderApproval extends StatefulWidget {
  const AdminProviderApproval({super.key});

  @override
  _AdminProviderApprovalState createState() => _AdminProviderApprovalState();
}

class _AdminProviderApprovalState extends State<AdminProviderApproval> {
  final List<Map<String, dynamic>> _providers = [
    {
      'id': '1',
      'name': 'John Doe',
      'phone': '1234567890',
      'serviceCategory': 'Plumbing',
      'status': 'Pending',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'phone': '9876543210',
      'serviceCategory': 'Electrician',
      'status': 'Pending',
    },
    {
      'id': '3',
      'name': 'Alice Johnson',
      'phone': '4561237890',
      'serviceCategory': 'Cleaning',
      'status': 'Pending',
    },
  ];

  void _updateProviderStatus(String providerId, String status) {
    setState(() {
      final providerIndex = _providers.indexWhere((provider) => provider['id'] == providerId);
      if (providerIndex != -1) {
        _providers[providerIndex]['status'] = status;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Provider status updated to $status.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: _providers.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_off, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No pending providers found',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _providers.length,
              itemBuilder: (context, index) {
                final provider = _providers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      provider['name'] ?? 'No Name',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone: ${provider['phone']}'),
                        Text('Service Category: ${provider['serviceCategory']}'),
                        const SizedBox(height: 8),
                        Text(
                          'Status: ${provider['status']}',
                          style: TextStyle(
                            color: provider['status'] == 'Pending'
                                ? Colors.orange
                                : provider['status'] == 'Approved'
                                    ? Colors.green
                                    : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Approve') {
                          _updateProviderStatus(provider['id'], 'Approved');
                        } else if (value == 'Decline') {
                          _updateProviderStatus(provider['id'], 'Declined');
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Approve', child: Text('Approve')),
                        const PopupMenuItem(value: 'Decline', child: Text('Decline')),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}